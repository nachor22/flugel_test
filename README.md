# Flugel evaluation test

Terraform module that creates an AWS S3 bucket with two files: `test1.txt` and `test2.txt`. The content of these files is the timestamp when the code was executed.

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
