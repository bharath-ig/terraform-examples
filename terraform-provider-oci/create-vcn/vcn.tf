
    terraform {
      required_version = ">= 0.12.0"
    }
#################
# VCN
#################
    
    resource oci_core_vcn "vcnterra" {
      dns_label      = var.vcn_dns_label
      cidr_block     = var.vcn_cidr
      compartment_id = var.compartment_ocid
      display_name   = var.vcn_display_name
    }
######################
# Internet Gateway
######################    
    resource oci_core_internet_gateway "gtw" {
      compartment_id = var.compartment_ocid
      vcn_id         = oci_core_vcn.vcnterra.id 
      display_name = "terra-igw"
      enabled = "true"
    }
######################
# Default Route Table
######################       

    resource "oci_core_default_route_table" "rt" {
      manage_default_resource_id = oci_core_vcn.vcnterra.default_route_table_id
    
      route_rules {
        destination       = "0.0.0.0/0"
        network_entity_id = oci_core_internet_gateway.gtw.id
      }
    }
######################
# Security Lists
######################

resource "oci_core_security_list" "terra_sl" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcnterra.id
  display_name = "terra-sl"
  egress_security_rules {
     protocol    = "all"
    destination = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 80
      max = 80
    }
  }

ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }
}

######################
# Availability Domains
######################
    data "oci_identity_availability_domains" "ad1" {
      compartment_id = var.compartment_ocid
    }  
######################
# Subnet
######################

    resource "oci_core_subnet" "terrasub" {
#      count               = length(data.oci_identity_availability_domains.ad1.availability_domains)
      availability_domain = lookup(data.oci_identity_availability_domains.ad1.availability_domains[0], "name")
     # cidr_block          = cidrsubnet(var.vcn_cidr, ceil(log(len527gth(data.oci_identity_availability_domains.ad1.availability_domains) * 2, 2)), count.index)
    #      display_name        = "Default Subnet ${lookup(data.oci_identity_availability_domains.ad1.availability_domains[count.index], "name")}"
      cidr_block     = var.subnet_cidr 
      display_name   = var.subnet_display_name
      prohibit_public_ip_on_vnic  = false
      dns_label                   = "${var.subnet_dns_label}"
      compartment_id              = var.compartment_ocid
      vcn_id                      = oci_core_vcn.vcnterra.id
      route_table_id              = oci_core_default_route_table.rt.id
      security_list_ids           = ["${oci_core_security_list.terra_sl.id}"]
      dhcp_options_id             = oci_core_vcn.vcnterra.default_dhcp_options_id
      #security_list_ids   = ["${oci_core_vcn.vcnterra.default_security_list_id}"]
    }
 
    
