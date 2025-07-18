module "s3" {
    source = "./modules/terraform-aws-s3"
     bucket_1 = var.bucket_1
     bucket_2 = var.bucket_2
}

module "lambda" {
    source = "./modules/terraform-aws-lambda"
    bucket_1 = var.bucket_1
    bucket_2 = var.bucket_2
    bucket_id = module.s3.bucket_id
    sns_arn = module.sns.sns_topic_arn
}

module "sns" {
    source = "./modules/terraform-aws-sns"
    # sns_topic_arn = var.sns_topic_arn
    sns_endpoint = var.sns_endpoint
}