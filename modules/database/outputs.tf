output "cluster_endpoint" {
  description = "Writer endpoint of the Aurora cluster"
  value       = aws_rds_cluster.aurora_serverless.endpoint
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint of the Aurora cluster"
  value       = aws_rds_cluster.aurora_serverless.reader_endpoint
}

output "cluster_port" {
  description = "Cluster port"
  value       = aws_rds_cluster.aurora_serverless.port
}

output "cluster_id" {
  description = "Cluster identifier"
  value       = aws_rds_cluster.aurora_serverless.id
}

output "instance_endpoint" {
  description = "Instance endpoint"
  value       = aws_rds_cluster_instance.aurora_instance.endpoint
}

output "database_arn" {
  description = "ARN of the Aurora cluster"
  value       = aws_rds_cluster.aurora_serverless.arn
}

output "database_master_username" {
  description = "Master username of the Aurora cluster"
  value       = aws_rds_cluster.aurora_serverless.master_username
}

output "database_secretsmanager_secret_arn" {
  description = "ARN of the Secrets Manager secret for the cluster credentials"
  value       = aws_secretsmanager_secret.aurora_secret.arn
}
