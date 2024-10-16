module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = [var.private_subnet1,var.private_subnet2]


  eks_managed_node_groups = {
    nodegroup = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = [ var.instance_type ]

      min_size     = var.min_nodes
      max_size     = var.max_nodes
      desired_size = var.desired_nodes

      tags = {
        "k8s.io/cluster-autoscaler/enabled" = "true"
        "k8s.io/cluster-autoscaler/${var.cluster_name}" = "true"
      }
      iam_role_additional_policies = {
        "AutoScalingFullAccess" = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
      }
    }
  }
  enable_cluster_creator_admin_permissions = true
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = local.gitlab-ns

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.region
  }
  depends_on = [ helm_release.gitlab_runner ]
}

resource "helm_release" "gitlab_runner" {
  name       = "gitlab-runner"
  repository = "http://charts.gitlab.io/"
  chart      = "gitlab-runner"
  namespace  = local.gitlab-ns
  create_namespace = true

  values = [
    file("${path.module}/Values.yaml")
  ]

  set {
    name  = "runnerToken"
    value = var.runner_token
  }
}

resource "null_resource" "role-sa-attachment" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<-EOT
     aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region} --profile ${local.env}
     kubectl annotate serviceaccount ${local.gitlab-sa} \
      -n ${local.gitlab-ns} \
      eks.amazonaws.com/role-arn=arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.gitlab-role}
    EOT
  }
  depends_on = [helm_release.gitlab_runner]
}

resource "aws_iam_policy" "runner_access_policy" {
  name        = "${local.gitlab-role}-policy"
  description = "Policy for GitLab Runner to access cloud resources"
  
  policy = file("${path.module}/RunnerPolicy.json")
}

resource "aws_iam_role" "service_account_role" {
  name = "${local.gitlab-role}"
  depends_on = [ helm_release.gitlab_runner ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${local.gitlab-ns}:${local.gitlab-sa}",
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "runner_policy_attachment" {
  role       = aws_iam_role.service_account_role.name
  policy_arn = aws_iam_policy.runner_access_policy.arn
}