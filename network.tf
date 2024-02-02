resource "aws_vpc" "vpc_tf" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc_tf"
  }
}
resource "aws_subnet" "subnet_tf" {
  vpc_id            = aws_vpc.vpc_tf.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-southeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet_tf"
  }
}
resource "aws_security_group" "sg_tf" {
  name        = "sg_tf"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.vpc_tf.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_tf"
  }
}

resource "aws_internet_gateway" "igw_tf" {
  vpc_id = aws_vpc.vpc_tf.id
  tags = {
    Name = "igw_tf"
  }
}

resource "aws_route_table" "rt_tf" {
  vpc_id = aws_vpc.vpc_tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_tf.id
  }

  tags = {
    Name = "rt_tf"
  }
}

resource "aws_route_table_association" "a_tf" {
  subnet_id      = aws_subnet.subnet_tf.id
  route_table_id = aws_route_table.rt_tf.id
}

