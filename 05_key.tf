variable "ssh_public_key" {}

resource "aws_key_pair" "flugel" {
  key_name   = "flugel_key"
  public_key = var.ssh_public_key
}
