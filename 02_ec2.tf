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
    ec2_domain_name_0 = aws_instance.web[0].private_dns
    ec2_domain_name_1 = aws_instance.web[1].private_dns
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
  key_name = "flugel_key"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = ["${aws_security_group.lb.id}"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  count = 2
  instance_type = "t2.micro"
  user_data = data.template_file.ud-web.rendered
  key_name = "flugel_key"
  subnet_id = aws_subnet.main.id
  vpc_security_group_ids = ["${aws_security_group.web.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.prof.name}"
}

##outputs
output "lb_domain" {
  value = aws_instance.lb.public_dns
}
