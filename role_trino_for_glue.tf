resource "aws_iam_role" "role_trino_for_glue_vd" {
  name = "role_trino_for_glue_vd"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "glue.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "athena_full_access_a" {
  role       = aws_iam_role.role_trino_for_glue_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access_a" {
  role       = aws_iam_role.role_trino_for_glue_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_console_full_access_a" {
  role       = aws_iam_role.role_trino_for_glue_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_databrew_service_role_a" {
  role       = aws_iam_role.role_trino_for_glue_vd.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueDataBrewServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_schema_registry_full_access_a" {
  role       = aws_iam_role.role_trino_for_glue_vd.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueSchemaRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_service_role_a" {
  role       = aws_iam_role.role_trino_for_glue_vd.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

output "role_trino_for_glue_vd_arn" {
  value = aws_iam_role.role_trino_for_glue_vd.arn
}
