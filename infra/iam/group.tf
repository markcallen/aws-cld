resource "aws_iam_group" "engineering" {
  name = "${var.project}-engineering"
}

resource "aws_iam_group_policy_attachment" "eng_attach" {
  group      = aws_iam_group.engineering.name
  count      = length(var.eng_iam_policy)
  policy_arn = var.eng_iam_policy[count.index]
}

resource "aws_iam_group_policy_attachment" "ecr_attach" {
  group      = aws_iam_group.engineering.name
  policy_arn = aws_iam_policy.ecr.arn
}

resource "aws_iam_group_policy_attachment" "ssh_connect_attach" {
  group      = aws_iam_group.engineering.name
  policy_arn = aws_iam_policy.ssh_connect.arn
}

resource "aws_iam_group_policy_attachment" "eks_console_attach" {
  group      = aws_iam_group.engineering.name
  policy_arn = aws_iam_policy.eks_console.arn
}

resource "aws_iam_group" "operations" {
  name = "${var.project}-operations"
}

resource "aws_iam_group_policy_attachment" "ops_attach" {
  group      = aws_iam_group.operations.name
  count      = length(var.ops_iam_policy)
  policy_arn = var.ops_iam_policy[count.index]
}
