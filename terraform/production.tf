resource "proxmox_vm_qemu" "terraform" {
  vmid        = 201
  name        = "ubuntu-2204-terraform"
  target_node = "proxmoxau"
  tags = "22.04,cloudinit,ubuntu,terraform"

  clone  = "ubuntu-2204-template"
  bios   = "seabios"
  agent  = 1
  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  cpu_type = "host"
  cores    = 4
  memory   = 4096

  # Cloud-Init configuration
  ipconfig0 = "ip=dhcp,ip6=dhcp"
  sshkeys   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDTSDn0YLvI8z18B+jELPWWOmDSFsyppE1GGg5zffLVr215xjGFioz1SfgvvMN/8p3bn1y96+6yMmQDkgy+LU6m5KAmnjqalXEOVyIA3s2jCmdDuAkgCdPHww0XaieUO08QJW28ubYgBTDJOQbGzW9IIF5qwDYatOqTfa+p1PfIX+WN7YPO9xybRw/N9pD1TeN2CLzWKnmc8MZKN6lwgVhmja5KTbhrEajRHKf5KcLmp/g1ax/JOKBQgwm4nmpUVEg8OaBdDtvxsTTR2+/JWaTz06a3tJ5YSyslAja+i9BknRrtw/0XP0tvVoKzesb3WX6Dcz1xV1EUKD9yVuP21hvl5cvIAJzVfoYGuUxIaMxI+QLGs+OrPCOfhoOqA4sy+iMVCLrQwGleBVMu1TZZS1JSeZy9J7zoLFUGnQ/GTIT8SMQQRfGG6XOYRW8++0BAylH1KI6wmVbeiM3q1z7FTEKKmO26pR24TC/TrR42QB2a2VawdMGM2zS9TtjmkLHs5xdos+8x+ohlvZ+nQdTaRwITpo8uBHJstCWkYAjcdv0lsSz2XUqyaqyrL6Sg5YTUc1tEAn+2l0DIeOV9OWxiZKBLuK0AI9r9sMTFHKDQ3Slskk83Mesj5rCDZLqQznJBPQKTrAPr4JmFcs1QnCoq+2HYvh7LTf/a2OhxVnTi26mJw== root@proxmoxau\nssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAI9W0doIkFc+a7oFQkOdE3DE69tUTVNH92xglz69VE ali.hussain@GHXJCD6VHK"
  cicustom  = "vendor=local:snippets/vendor.yaml"
  ciuser    = "ali"
  serial {
    id = 0
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "50G"
          storage = "seagate-barr-1TB"
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide0 {
        cloudinit {
          storage = "seagate-barr-1TB"
        }
      }
      ide2 {
        cdrom {

        }
      }
    }
  }

  skip_ipv6 = true
  network {
    id       = 0
    bridge   = "vmbr0"
    model    = "virtio"
    firewall = true
  }
}