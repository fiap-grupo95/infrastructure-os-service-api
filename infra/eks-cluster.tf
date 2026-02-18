resource "aws_eks_cluster" "cluster" {
  name = "eks-${var.projectName}"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet_public[0].id,
      aws_subnet.subnet_public[1].id,
      aws_subnet.subnet_public[2].id
    ]
    security_group_ids = [aws_security_group.sg.id]
  }


  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# resource "aws_eks_addon" "ebs_csi" {
#   cluster_name = aws_eks_cluster.cluster.name
#   addon_name   = "aws-ebs-csi-driver"
#   # addon_version = "v1.30.0-eksbuild.1" # descomente para travar uma versão

#   depends_on = [
#     aws_eks_cluster.cluster,
#     aws_iam_role_policy_attachment.node-AmazonEBSCSIDriverPolicy
#   ]
# }