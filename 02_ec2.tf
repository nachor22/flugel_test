##data
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "ud-lb" {
  template = file("userdata/userdata_traefik.yaml")
  vars = {
    ec2_domain_name = aws_instance.web01.private_dns
  }
}

data "template_file" "ud-web" {
  template = file("userdata/userdata_web.yaml")
  vars = {
    s3_bucket_name = aws_s3_bucket.fb.id
  }
}

##resources
resource "aws_instance" "lb" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data = data.template_file.ud-lb.rendered
  key_name = "nachor_key"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = ["${aws_security_group.lb.id}"]
  #depends on internet gateway
  #depends_on = [aws_internet_gateway.gw]
}

resource "aws_instance" "web01" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data = data.template_file.ud-web.rendered
  key_name = "nachor_key"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.prof.name}"
  #depends on internet gateway
  #depends_on = [aws_internet_gateway.gw]
}

##outputs
output "lb_domain" {
  value = aws_instance.lb.public_dns
}
