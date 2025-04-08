module "s3_buckets" {
  source             = "../../../../terracode-aws-common/modules/s3-buckets"
  bucket_name        = "my-app"
  create_data_bucket = true
  use_shared_kms     = true
}
