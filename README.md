# Flugel evaluation test

Terraform code that creates:
- Private S3 bucket with two files: `test1.txt` and `test2.txt`. The content of these files is the timestamp when the code was executed.
- An EC2 instance running Traefik as LB
- Two EC2 instances, behind the LB, that serve the files from the S3 bucket using `s3-proxy`
- Every instances are created in a new VPC with only a public subnet
- S3 bucket is only accesible by EC2 instances using IAM Role
- The LB routes the `/s3` path to the S3 bucket
- Files are reachable through the LB port 80. ie: `http://LB_DNS_NAME/s3/file1.txt`

It also includes `flugel_test.go` to test the module with Terratest, which is triggered on every push/PR by Github Actions

### Running automated test
- Terraform installed
- Go installed
- Env vars defined:`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- Run `go mod init github.com/nachor22/flugel_test`
- Run `go mod tidy`
- Run `go test`

### Running only module manually
- Terraform installed
- Env vars defined:`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
- Run `terraform init`
- Run `terraform apply`
- When it's done `terraform destroy`
