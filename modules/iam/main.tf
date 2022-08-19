data "aws_iam_policy_document" "instance-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy" "full-admin" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# resource "aws_iam_policy" "admin" {
#   name = "admin"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action   = "*"
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

resource "aws_iam_role" "instance" {
  name               = "kops"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [data.aws_iam_policy.full-admin.arn]
}

resource "aws_iam_instance_profile" "kops_profile" {
  name = "kops_profile"
  role = aws_iam_role.instance.name
}

resource "aws_iam_role" "cwagent" {
  name               = "cwagent"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
  managed_policy_arns = [data.aws_iam_policy.CloudWatchAgentServerPolicy.arn]
}

resource "aws_iam_instance_profile" "cwagent_profile" {
  name = "cwagent_profile"
  role = aws_iam_role.cwagent.name
}