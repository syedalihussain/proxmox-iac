variable "proxmox_api_url" {
    type = string
}

variable "proxmox_api_token_id" {
    type = string
}

variable "proxmox_api_token_secret" {
    type = string
    sensitive = true
}

source "proxmox-clone" "debian" {
  clone_vm                 = "debian-10-4"
  cores                    = 1
  insecure_skip_tls_verify = true
  memory                   = 2048
  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
  }
  node                 = "proxmoxau"
  os                   = "l26"
  password             = "${var.proxmox_password}"
  pool                 = "api-users"
  proxmox_url          = "https://my-proxmox.my-domain:8006/api2/json"
  sockets              = 1
  ssh_username         = "root"
  template_description = "image made from cloud-init image"
  template_name        = "debian-scaffolding"
  username             = "${var.proxmox_username}"
}

build {
  sources = ["source.proxmox-clone.debian"]
}
