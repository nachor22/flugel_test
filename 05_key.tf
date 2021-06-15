resource "aws_key_pair" "flugel" {
  key_name   = "flugel_key"
  public_key = file("id_rsa.pub")
}
