terraform {
  required_providers {

    aci = {
      source  = "CiscoDevNet/aci"
      version = "2.12.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    fmc = {
      source = "CiscoDevNet/fmc"
    }
  }
}

provider "aci" {
  # username = ""                                   # Environment Variable ACI_USERNAME
  # password = ""                                   # Use environment variable ACI_PASSWORD 
  # url      = "https://apic1.local.domain"         # Environment Variable ACI_URL
}

provider "aws" {
  # region = "us-east-1" #required param, but region is not needed
  # Use Env Var AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION
}

provider "fmc" {
  # fmc_username              = "terraform_user"              # user ENV: FMC_USERNAME
  # fmc_password              = "SecurePasswordFromTfvars"    # use ENV: FMC_PASSWORD
  # fmc_host                  = "fmc.local.domain"            # USE ENV: FMC_HOST
  # fmc_insecure_skip_verify  = false
}

