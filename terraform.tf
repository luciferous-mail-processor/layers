# ================================================================
# Terraform Config
# ================================================================

terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.71"
    }
  }

  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "prepare-bucketterraformstates-cxxp0e0isfpp"
    key            = "cloud/state.json"
    dynamodb_table = "prepare-TableTerraformLocks-5OEJP1YJFV3Z"
  }
}

# ================================================================
# Provider Config
# ================================================================

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      SystemName = var.system_name
    }
  }
}

# ================================================================
# Variables
# ================================================================

variable "region" {
  type     = string
  nullable = false
}

variable "system_name" {
  type     = string
  nullable = false
}

variable "s3_bucket" {
  type     = string
  nullable = false
}

variable "s3_key_prefix" {
  type     = string
  nullable = false
}

# ================================================================
# Modules
# ================================================================

module "base" {
  source = "./modules/layer"

  source_directory = "layers/base"
  parameter_name   = "BaseLayer"

  s3_bucket     = var.s3_bucket
  s3_key_prefix = var.s3_key_prefix
}

# ================================================================
# Outputs
# ================================================================

output "base_layer_arn" {
  value = module.base.layer_arn
}
