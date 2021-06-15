variable "SSH_PUBLIC_KEY" {}

resource "aws_key_pair" "flugel" {
  key_name   = "flugel_key"
  public_key = var.SSH_PUBLIC_KEY
}
