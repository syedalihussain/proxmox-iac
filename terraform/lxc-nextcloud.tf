
# resource "proxmox_lxc" "lxc-nextcloud" {
#   target_node  = "proxmoxau"
#   vmid         = 101
#   hostname     = "nextcloud"
#   ostemplate   = "local:vztmpl/alpine-3.21-default_20241217_amd64.tar.xz"
#   password     = var.lxc_nextcloud_password
#   unprivileged = true
#   cores        = 1

#   tags         = "personal,nextcloud"

#   # features {
#   #   mount   = "nfs"
#   # }
#   // Terraform will crash without rootfs defined
#   rootfs {
#     storage = "local-lvm"
#     size    = "8G"
#   }

#   mountpoint {
#     slot    = "0"
#     key     = 0
#     storage = "/mnt/lxc_shares/nextcloud_rwx"
#     mp      = "/mnt/nas"
#     # size    = "8T"
#   }

#   network {
#     name   = "eth0"
#     bridge = "vmbr0"
#     ip     = "dhcp"
#   }
# }