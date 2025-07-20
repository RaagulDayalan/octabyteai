resource "aws_iam_role" "ec2_cw_role" {
  name = "${var.infra_prefix}-ec2-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "${var.infra_prefix}-ec2-cw-role"
  }
}

data "aws_iam_policy_document" "ec2_cw_policy" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "cloudwatch:PutMetricData",
                "cloudwatch:ListMetrics",
                "ec2:DescribeTags", 
                "cloudwatch:PutMetricData",
                "ec2:DescribeVolumes",
                "ec2:DescribeTags",
                "logs:PutLogEvents",
                "logs:PutRetentionPolicy",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup",
                "xray:PutTraceSegments",
                "xray:PutTelemetryRecords",
                "xray:GetSamplingRules",
                "xray:GetSamplingTargets",
                "xray:GetSamplingStatisticSummaries"]
    resources = ["*"]
  }
  statement {
    effect    = "Allow"
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"]
  }
  
}

resource "aws_iam_policy" "ec2_cw_policy" {
  name        = "${var.infra_prefix}-ec2-cw-policy"
  description = "ec2_cw_policy for ${var.infra_prefix}"
  policy      = data.aws_iam_policy_document.ec2_cw_policy.json
  tags = {
    Name = "${var.infra_prefix}-ec2-cw-policy"
  }
}
resource "aws_iam_role_policy_attachment" "ec2_cw_policy_attachment" {
  role       = aws_iam_role.ec2_cw_role.name
  policy_arn = aws_iam_policy.ec2_cw_policy.arn
}