resource "aws_dynamodb_table" "tf_notes_table" {
  name = var.dynamodb_name
  billing_mode = "PAY_PER_REQUEST"
  read_capacity= "2"
  write_capacity= "2"
  attribute {
      name = var.partition_key
      type = var.partition_key_type
  }
  hash_key = var.partition_hash_key

  tags = {
    Project = "${var.project}"
    Terraform = "true"
    Request   = "${var.manager_project}"  
  }
}