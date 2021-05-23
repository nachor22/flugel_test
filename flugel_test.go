package test

import (
	"fmt"
	"strings"
	"testing"
  "time"
  "crypto/tls"

//	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
//	"github.com/stretchr/testify/assert"
  http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
)

// An example of how to test the Terraform module in examples/terraform-aws-s3-example using Terratest.
func TestTerraformAwsS3Example(t *testing.T) {
	t.Parallel()

	// Give this S3 Bucket a unique ID for a name tag so we can distinguish it from any other Buckets provisioned
	// in your AWS account
	expectedName := fmt.Sprintf("-%s", strings.ToLower(random.UniqueId()))

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	//awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: ".",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name": expectedName,
		},

		// Environment variables to set when running Terraform
		//EnvVars: map[string]string{
	  //		"AWS_DEFAULT_REGION": awsRegion,
		//},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	bucketDomain := terraform.Output(t, terraformOptions, "bucket_domain")

  expectedTimeStamp := terraform.Output(t, terraformOptions, "bucket_objects_time")

  tlsConfig := tls.Config{}

  http_helper.HttpGetWithRetry(t, "https://" + bucketDomain + "/test1.txt", &tlsConfig, 200, expectedTimeStamp, 3, 5 * time.Second)
}
