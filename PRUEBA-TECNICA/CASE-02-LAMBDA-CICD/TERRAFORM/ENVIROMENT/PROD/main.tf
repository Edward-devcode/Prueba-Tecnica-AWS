module "iam" {

  source = "../../modules/iam"

  function_name = var.function_name
  environment   = var.environment
}


module "lambda" {

  source = "../../modules/lambda"

  function_name = var.function_name
  environment   = var.environment

  role_arn = module.iam.lambda_role_arn

  runtime      = var.runtime
  architecture = var.architecture

  handler      = var.handler
  package_file = var.package_file

  environment_variables = {

    DB_HOST    = var.db_host
    REDIS_HOST = var.redis_host
  }
}

module "lambda_alias" {

  source = "../../modules/lambda_alias"

  function_name    = module.lambda.function_name
  alias_name       = var.environment
  function_version = module.lambda.function_version
}
