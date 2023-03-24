resource "aws_eks_cluster" "aws_eks" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.aws_eks-cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.aws_eks-cluster.id}"]
    subnet_ids         = ["${aws_subnet.aws_eks.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.aws_eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.aws_eks-cluster-AmazonEKSServicePolicy",
  ]
}