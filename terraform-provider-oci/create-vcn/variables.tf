
    variable "compartment_ocid" {}
    variable "tenancy_ocid" {}
    variable "region" {}

    variable "vcn_display_name" {
      default = "Terravcn"
    }
    
    variable "vcn_cidr" {
      default = "10.0.0.0/16"
    }

    variable "vcn_dns_label" {
      default     = "Terra"
    }
# SUBNET INFO
    variable "subnet_dns_label" {
      default = "terra"
    }
    variable "subnet_display_name"{
      default = "terrasub" 
      }

    variable "subnet_cidr"{
      default = "10.0.1.0/24" 
    }   
 provider "oci" {
      tenancy_ocid     = var.tenancy_ocid
      region           = var.region
    }

  
