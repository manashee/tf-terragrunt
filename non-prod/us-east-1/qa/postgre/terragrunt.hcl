locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
terraform {
  #source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//mysql?ref=v0.1.0"
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-rds.git"
  
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}



inputs = {
  identifier = "postgre${local.env}"
  engine            = "postgres"
  engine_version    = "9.6.3"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  name = "postgre${local.env}"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "demouser"

  password = "YourPwdShouldBeLongAndSecure!"
  port     = "5432"

  vpc_security_group_ids = ["sg-07650541"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "${local.env}"
  }

  # DB subnet group
  subnet_ids      = ["subnet-12c4ba75", "subnet-31ebe57b", "subnet-36cb4608"]
  # DB parameter group
  family = "postgres9.6"
  major_engine_version = "9.6"
  # Snapshot name upon DB deletion
  final_snapshot_identifier = "postgre${local.env}"
   deletion_protection = false
  }

