module "iam-role" {
  source              = "../../BMG.Template/modules/IdentityAccessManagement/Role/Lambda"
  role_lambda_name           = var.role_lambda_name
}

module "iam-policy" {
  source              = "../../BMG.Template/modules/IdentityAccessManagement/Policy/Lambda"
  policy_lambda_function           = var.policy_lambda_name
}

module "iam-attach" {
  source              = "../../BMG.Template/modules/IdentityAccessManagement/AttachPolicyToRole"
  policy_arn          = module.iam-policy.policy_arn
  role_name           = var.role_lambda_name
  ["module.iam-policy", "module.iam-role"]
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "./files/${var.lambda_runtime}"
  output_path = "./files/${var.lambda_runtime}/hello.zip"
}

resource "aws_lambda_function" "terraform_lambda_func" {
  filename                       = "./files/${var.lambda_runtime}/hello.zip"
  function_name                  = var.function_name
  role                           = module.iam-role.role_arn
  handler                        = "index.lambda_handler"
  runtime                        = var.lambda_runtime == "python" ? "python3.8" : "nodejs16.x"
  depends_on                     = ["module.iam-attach"]
  tags = {
    Project = "${var.project}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }
}