resource "aws_ami_from_instance" "trino-ami-worker" {
  name               = "trino-ami-worker"
  source_instance_id = aws_instance.trino-worker.id
  snapshot_without_reboot = true

  tags = {
    Name = "trino-ami-worker"
  }
  depends_on = [aws_instance.trino-worker]
}

resource "aws_launch_template" "trino_worker_lt" {
  name = "trino-worker-launch-template"

  image_id      = aws_ami_from_instance.trino-ami-worker.id
  instance_type = "t2.medium"
  key_name      = "trino-test"

  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile_trino_worker.name
  }

  vpc_security_group_ids = [aws_security_group.sg_tf.id]

  user_data = base64encode(file("${path.module}/user_data_asg.sh"))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "trino-worker"
    }
  }
  depends_on = [aws_ami_from_instance.trino-ami-worker]
}
resource "aws_autoscaling_group" "trino_worker_asg" {
  name = "trino-worker-auto-scaling-group"

  min_size           = 1
  max_size           = 3
  desired_capacity   = 1
  launch_template {
    id      = aws_launch_template.trino_worker_lt.id
    version = "$Latest"
  }

  vpc_zone_identifier = [aws_subnet.subnet_tf.id]

  tag {
    key                 = "Name"
    value               = "trino-worker"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.trino_worker_lt]
}

