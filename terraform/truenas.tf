resource "proxmox_vm_qemu" "truenas" {
  vmid        = 600
  name        = "truenas-scale"
  target_node = "proxmoxau"
  tags        = "personal,truenas-scale"
  protection  = true

  bios   = "seabios"
  agent  = 1
  scsihw = "virtio-scsi-single"

  cpu_type = "host"
  cores    = 2
  memory   = 8192

  disks {
    ide {
     ide2 {
        cdrom {
          iso = "local:iso/TrueNAS-SCALE-25.04.0.iso"
        }
     }
    }
    scsi {
      scsi0 {
        disk {
          size       = "32G"
          storage    = "local-lvm"
          emulatessd = true
          iothread   = true
          discard    = true
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