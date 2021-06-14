##variables
variable "bucket_name" {
  description = "Name of the bucket"
  default = "-testexample"
}

##resources
resource "time_static" "t" {}

resource "aws_s3_bucket" "fb" {
  bucket = "fb${var.bucket_name}"
}

resource "aws_s3_bucket_object" "test1" {
  bucket = aws_s3_bucket.fb.id
  key = "test1.txt"
  content = time_static.t.rfc3339
}

resource "aws_s3_bucket_object" "test2" {
  bucket = aws_s3_bucket.fb.id
  key = "test2.txt"
  content = time_static.t.rfc3339
}

##outputs
output "bucket_objects_time" {
  value = time_static.t.rfc3339
}
