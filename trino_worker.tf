resource "aws_iam_instance_profile" "instance_profile_trino_worker" {
  name = "instance_profile_trino_worker"
  role = "role_trino_vd"
}

data "template_file" "user_data_worker" {
  template = file("${path.module}/user_data_worker.sh")

  vars = {
    role_arn = aws_iam_role.role_trino_vd.arn,
    role_arn_glue = aws_iam_role.role_trino_for_glue_vd.arn
    private_ip_master = aws_instance.trino-master.private_ip
  }
}

resource "aws_instance" "trino-worker" {
  ami                   = "ami-078c1149d8ad719a7"
  instance_type         = "t2.medium"
  key_name              = "trino-test"
  subnet_id             = aws_subnet.subnet_tf.id
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
  iam_instance_profile  = aws_iam_instance_profile.instance_profile_trino_worker.name
  user_data = data.template_file.user_data_worker.rendered
  tags = {
    Name = "trino-worker-vd"
  }
}
output "public_ip_worker" {
  value = aws_instance.trino-worker.public_ip
}
output "private_dns_worker" {
  value = aws_instance.trino-worker.private_dns
  description = "The private DNS name of the instance"
}
output "private_ip_worker" {
  value = aws_instance.trino-worker.private_ip
  description = "The private IPv4 address of the instance"
}