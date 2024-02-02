resource "aws_iam_instance_profile" "instance_profile_trino_master" {
  name = "instance_profile_trino_master"
  role = "role_trino_vd"
}

data "template_file" "user_data_master" {
  template = base64encode(file("${path.module}/user_data_master.sh"))

  vars = {
    role_arn = aws_iam_role.role_trino_vd.arn,
    role_arn_glue = aws_iam_role.role_trino_for_glue_vd.arn
  }
}

resource "aws_instance" "trino-master" {
  ami                   = "ami-078c1149d8ad719a7"
  instance_type         = "t2.medium"
  key_name              = "trino-test"
  subnet_id             = aws_subnet.subnet_tf.id
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
  iam_instance_profile  = aws_iam_instance_profile.instance_profile_trino_master.name
  user_data = data.template_file.user_data_master.rendered
  tags = {
    Name = "trino-master-vd"
  }
}
output "public_ip_master" {
  value = aws_instance.trino-master.public_ip
}
output "private_dns_master" {
  value = aws_instance.trino-master.private_dns
  description = "The private DNS name of the instance"
}
output "private_ip_master" {
  value = aws_instance.trino-master.private_ip
  description = "The private IPv4 address of the instance"
}

#resource "aws_ami_from_instance" "trino-ami" {
#  name               = "trino-ami"
#  source_instance_id = aws_instance.trino-master.id
#  snapshot_without_reboot = true
#
#  tags = {
#    Name = "trino-ami"
#  }
#  depends_on = [aws_instance.trino-master]
#}