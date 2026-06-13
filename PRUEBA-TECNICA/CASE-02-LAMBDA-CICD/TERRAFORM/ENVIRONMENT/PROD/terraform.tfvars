environment = "prod"

function_name = "orders-service"

runtime = "python3.13"

architecture = "arm64"

handler = "lambda_function.lambda_handler"

package_file = "../../lambda/function.zip"

db_host = "prod-db.internal"

redis_host = "prod-redis.internal"

aws_region = "us-east-1"
