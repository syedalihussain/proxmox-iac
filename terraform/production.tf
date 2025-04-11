resource "proxmox_vm_qemu" "production" {
  vmid        = 201
  name        = "ubuntu-2204-production"
  target_node = "proxmoxau"

  clone  = "ubuntu-2204-template"
  bios   = "seabios"
  agent  = 1
  scsihw = "virtio-scsi-single"

  os_type  = "cloud-init"
  cpu_type = "x86-64-v2-AES"
  cores    = 2
  memory   = 2048

  # Cloud-Init configuration
  ipconfig0 = "ip=dhcp,ip6=dhcp"

  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "100G"
          storage = "seagate-barr-1TB"
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  network {
    id       = 0
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }
}