resource "aws_lambda_alias" "alias" {
  name             = var.alias_name       # El nombre del alias, por ejemplo "dev", "staging" o "prod"
  function_name    = var.function_name    # El nombre de la función Lambda a la que se le asignará el alias
  function_version = var.function_version # La versión de la función Lambda a la que apuntará el alias

}
