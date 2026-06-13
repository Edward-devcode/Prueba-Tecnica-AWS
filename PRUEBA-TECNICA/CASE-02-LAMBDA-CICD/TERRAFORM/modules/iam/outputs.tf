output "lambda_role_arn" { # Output del ARN del rol de IAM creado para la función Lambda
  value = aws_iam_role.lambda_role.arn
}

output "lambda_role_name" { # Output del nombre del rol de IAM creado para la función Lambda
  value = aws_iam_role.lambda_role.name

}
