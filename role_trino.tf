resource "aws_iam_role" "role_trino_vd" {
  name = "role_trino_vd"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_outposts_full_access" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3OutpostsFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_read_only_access" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "glue_console_full_access" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_schema_registry_full_access" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueSchemaRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_service_role" {
  role       = aws_iam_role.role_trino_vd.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

output "role_trino_vd_arn" {
  value = aws_iam_role.role_trino_vd.arn
}
