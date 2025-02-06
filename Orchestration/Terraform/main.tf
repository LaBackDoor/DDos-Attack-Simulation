# main.tf
data "vsphere_datacenter" "datacenter" {
  name = "vSAN Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "vsanDatastore"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.network_adapter
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "/vSAN Datacenter/host/CTCR Cluster/Resources/Research/DDoS Dataset/Automation/${var.resource_pool}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vms" {
  count            = var.vm_count
  name             = "${var.vm_name_prefix}-${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus           = data.vsphere_virtual_machine.template.num_cpus
  memory            = data.vsphere_virtual_machine.template.memory
  guest_id          = data.vsphere_virtual_machine.template.guest_id
  scsi_type         = data.vsphere_virtual_machine.template.scsi_type
  firmware          = "bios"
  nested_hv_enabled = true

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.vm_name_prefix}-${count.index + 1}"
        domain    = "local"
      }

      network_interface {
        ipv4_address = cidrhost(
          "${var.network_config.network}/24",
          160 + count.index
        )
        ipv4_netmask = 24
      }

      ipv4_gateway = var.network_config.gateway
      dns_server_list = [var.network_config.dns_server]
    }
  }
}