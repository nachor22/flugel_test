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

data "template_file" "userdata" {
  template = file("userdata.yaml")
  vars = {
    s3_domain_name = aws_s3_bucket.fb.bucket_regional_domain_name
  }
}

##resources
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data = data.template_file.userdata.rendered
  key_name = "nachor_key"
  vpc_security_group_ids = ["sg-acc556c7"]
}

##outputs
output "ec2_domain" {
  value = aws_instance.web.public_dns
}
