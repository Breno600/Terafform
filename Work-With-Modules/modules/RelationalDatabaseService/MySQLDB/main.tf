resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_size
  apply_immediately      = true
  db_name                = "db-${var.database_name}"
  engine                 = "mysql"
  instance_class         = var.instance_class_size 
  username               = var.username
  password               = var.password
  skip_final_snapshot    = true
  replicate_source_db    = 1
  storage_type           = "gp3"
  vpc_security_group_ids =
  storage_encrypted      = true
}