variable "cluster_identifier" {
  description = "The cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "Aurora Postgres engine version"
  type        = string
  default     = "14.15"
}

variable "database_name" {
  description = "Name of the initial database"
  type        = string
  default     = "mydb"
}

variable "master_username" {
  description = "Master username for the DB"
  type        = string
  default     = "dbadmin"
}

variable "vpc_id" {
  description = "The VPC ID where the cluster and security group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs to use for the Aurora cluster"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "The CIDR blocks allowed to access the cluster"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "min_capacity" {
  description = "Minimum Aurora capacity units"
  type        = number
  default     = 0.5
}

variable "max_capacity" {
  description = "Maximum Aurora capacity units"
  type        = number
  default     = 1
}
