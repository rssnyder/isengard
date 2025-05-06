module "vcn" {
  source                       = "oracle-terraform-modules/vcn/oci"
  version                      = "3.6.0"
  compartment_id               = var.compartment_id
  region                       = var.region
  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null
  vcn_name                     = "k8s-vcn"
  vcn_dns_label                = "k8svcn"
  vcn_cidrs                    = ["10.0.0.0/16"]
  create_internet_gateway      = true
  create_nat_gateway           = true
  create_service_gateway       = true
}

resource "oci_core_network_security_group" "ingress_lb" {
  #Required
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id

  display_name = "ingress"
}

resource "oci_core_network_security_group_security_rule" "ingress_http" {
  network_security_group_id = oci_core_network_security_group.ingress_lb.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  #Optional
  description = "ingress_80_lb"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "ingress_https" {
  network_security_group_id = oci_core_network_security_group.ingress_lb.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  #Optional
  description = "ingress_443_lb"

  source      = "0.0.0.0/0"
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}