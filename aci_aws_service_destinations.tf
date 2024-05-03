# AWS Public Services prefixes
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ip_ranges
# https://docs.aws.amazon.com/general/latest/gr/aws-ip-ranges.html

# Create Match Rules based on service and region, default to common tenant
resource "aci_match_rule" "rm_match_aws_services" {
  tenant_dn = "uni/tn-${var.aci_tenant}"
  for_each  = toset([for rm in local.aci_aws_service_dest : rm.rm_name])
  name      = each.key
}

# Create match enty for each subnet of each service of each region
## set aggregate = "yes" to match all longer prefixes of subnet [ <subnet> le 32 ]
resource "aci_match_route_destination_rule" "rm_aws_prefix_lists" {
  for_each      = { for obj in local.aci_aws_service_dest : "${obj.rm_name}_${obj.ip}" => obj }
  match_rule_dn = aci_match_rule.rm_match_aws_services["${each.value.rm_name}"].id
  ip            = each.value.ip
  aggregate     = "no"
}
