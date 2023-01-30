terraform {
  backend "s3" {
    bucket  = "#{BUCKET_NAME}#"
    encrypt = true
    key     = "#{BUCKET_PATH}#/terraform.tfstate"
    region  = "#{REGION_AWS}#"
  }
}