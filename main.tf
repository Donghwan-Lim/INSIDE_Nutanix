terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "INSIDE_CS_PART2"
    workspaces {
      name = "INSIDE_Nutanix"
    }
  }
  required_providers {
    nutanix = {
      source = "nutanix/nutanix"
      version = "1.9.5"
    }
  }
}

provider "nutanix" {
  username     = var.nutanix_username
  password     = var.nutanix_password
  endpoint     = var.nutanix_endpoint
  port         = var.nutanix_port
  insecure     = false
  wait_timeout = 10
}

#data "nutanix_clusters" "clusters" {}
data "nutanix_cluster" "cluster" {
    name = "Main-Cluster"
}

resource "nutanix_virtual_machine" "vm01" {
  name                 = "Donghwan-Terraform-Provisioning-VM"
  cluster_uuid         = data.nutanix_cluster.cluster.cluster_id #data.nutanix_clusters.clusters.entities.0.metadata.uuid
  num_vcpus_per_socket = 1
  num_sockets          = 2
  memory_size_mib      = 8

  disk_list {
    disk_size_bytes = 85899345920
    disk_size_mib   = 81920

    storage_config {
      storage_container_reference {
        kind = "Inside-Container"
      }
    }
  }
}

resource "nutanix_subnet" "next-iac-managed" {
  # What cluster will this VLAN live on?
  cluster_uuid = data.nutanix_cluster.cluster.cluster_id #"${data.nutanix_clusters.clusters.entities.0.metadata.uuid}"

  # General Information
  name        = "terraform-provsioning"
  vlan_id     = 0
  subnet_type = "VLAN"
  vswitch_name = "vs0"
}