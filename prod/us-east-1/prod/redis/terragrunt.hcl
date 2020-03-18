locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract out common variables for reuse
  env = local.environment_vars.locals.environment
}

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder.
#terraform {
#  source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//asg-elb-service?ref=v0.1.0"
#}
terraform {
  // source = "git::git@github.com:gruntwork-io/terragrunt-infrastructure-modules-example.git//path/to/module?ref=v0.0.1"
  source = "git::git@github.com:umotif-public/terraform-aws-elasticache-redis.git"
  // source  = "umotif-public/elasticache-redis/aws"
}

# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

# These are the variables we have to pass in to use the module specified in the terragrunt configuration above
inputs = {
  number_cache_clusters = "2"
  node_type = "cache.t2.micro"
  name_prefix = "redis-${local.env}"
  subnet_ids        = ["subnet-12c4ba75", "subnet-12c4ba75", "subnet-12c4ba75"]
  vpc_id         = "vpc-d5b933af"
}
