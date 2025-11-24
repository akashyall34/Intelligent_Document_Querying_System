resource "aws_rds_cluster" "aurora_serverless" {
  cluster_identifier      = var.cluster_identifier
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = var.engine_version
  database_name           = var.database_name
  master_username         = var.master_username
  master_password         = random_password.master_password.result

  db_subnet_group_name    = aws_db_subnet_group.aurora_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.aurora_sg.id]
  
  enable_http_endpoint    = true
  skip_final_snapshot     = true
  apply_immediately       = true

  allow_major_version_upgrade = true

  serverlessv2_scaling_configuration {
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier         = "${var.cluster_identifier}-instance-1"
  cluster_identifier = aws_rds_cluster.aurora_serverless.id
  instance_class     = "db.serverless"
  engine             = "aurora-postgresql"
  engine_version     = var.engine_version

  publicly_accessible = false
}

resource "aws_db_subnet_group" "aurora_subnet_group" {
  name       = "${var.cluster_identifier}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.cluster_identifier}-subnet-group"
  }
}

resource "aws_security_group" "aurora_sg" {
  name        = "${var.cluster_identifier}-sg"
  description = "Aurora PostgreSQL security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "master_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "aurora_secret" {
  name                    = "${var.cluster_identifier}-credentials"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aurora_secret_version" {
  secret_id = aws_secretsmanager_secret.aurora_secret.id
  secret_string = jsonencode({
    dbClusterIdentifier = aws_rds_cluster.aurora_serverless.cluster_identifier
    password            = random_password.master_password.result
    engine              = aws_rds_cluster.aurora_serverless.engine
    port                = 5432
    host                = aws_rds_cluster.aurora_serverless.endpoint
    username            = aws_rds_cluster.aurora_serverless.master_username
    db                  = aws_rds_cluster.aurora_serverless.database_name
  })
}
