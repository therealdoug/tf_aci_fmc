# Get all the different region prefixes into a single data
data "aws_ip_ranges" "service_regions" {
  for_each = { for service in var.aws_services : "${service.services}_${service.regions}" => service }

  regions  = [each.value.regions]
  services = [each.value.services]
}

variable "aci_tenant" {
  description = "Name of ACI Tenant to place match rules"
  type        = string

  default = "common"
}

variable "aws_services" {
  description = "Get IP Prefixes for AWS Services"
  type        = list(any)

  default = [
    {
      regions  = "us-east-2"
      services = "dynamodb"
    },
    {
      regions  = "us-east-1"
      services = "s3"
    },
    {
      regions  = "us-east-2"
      services = "s3"
    },
    {
      regions  = "us-gov-east-1"
      services = "s3"
    },
    {
      regions  = "us-gov-west-1"
      services = "s3"
    }
  ]
}

locals {
  # Put data in a format that ACI provider can work with
  aci_aws_service_dest = flatten([
    for service in data.aws_ip_ranges.service_regions : [
      for block in setproduct(service.services, service.regions, service.cidr_blocks) : {
        rm_name = "TF-TEST_rm_match_aws_${tolist(service.services)[0]}_${tolist(service.regions)[0]}"
        service = block[0]
        region  = block[1]
        ip      = block[2]
      }
    ]
  ])

  # Put data in a format that FMC provider can work with
  fmc_aws_service_dest = flatten([
    for service in data.aws_ip_ranges.service_regions : [
      for region, cidrs in service.regions : {
        region  = region
        cidrs   = service.cidr_blocks
        service = tolist(service.services)[0]
      }
    ]
  ])
}