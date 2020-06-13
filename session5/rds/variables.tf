variable "db_instance_type" {
    description = "RDS db insttance type"
    default     = "db.t2.micro"
    type        = string
}

variable "db_storage" {
    description = "RDS db size"
    default     = 10
    type        = number
}

variable "skip_final_snapshot" {
    description = "Identifies if the final snapshot will be taken when db is deleted"
    type        = bool
    default     = true
}

variable "final_snapshot_name" {
    default = "rds_snapshot"
}