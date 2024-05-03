# This terraform will maintain state of FMC object groups for AWS S3 Destinations.

resource "fmc_network_group_objects" "fmc_aws_service_dest" {
  # Create Network Group Object for each region specified
  for_each = { for thing in local.fmc_aws_service_dest : "TF-TEST_aws_${thing.service}_${thing.region}" => thing }

  name        = each.key
  description = "Terraform Managed. Do Not Modify."

  dynamic "literals" {
    # Create ACE/entry for each subnet per service per region
    for_each = { for ip in each.value.cidrs : ip => ip }
    content {
      value = literals.key
      type  = "Network"
    }
  }
}
