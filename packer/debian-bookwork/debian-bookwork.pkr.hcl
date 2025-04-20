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

source "proxmox-iso" "debian--bookworm" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"
  # (Optional) Skip TLS Verification
  insecure_skip_tls_verify = true

  // VM Settings
  node                 = "proxmoxau"  // Your Proxmox node name
  vm_id                = 520    // Template ID
  vm_name              = "debian-bookworm"
  template_description = <<EOT
  Debian Bookworm Image - Built using Packer
  Packages:
  - docker
  EOT

  # VM OS Settings
  os = "l26"
  boot_iso {
    iso_file = "local:iso/ubuntu-22.04.5-live-server-amd64.iso"
    unmount = true
    iso_checksum = "sha256:9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
    keep_cdrom_device = true
  }

  # VM System Settings
  qemu_agent = true

  # VM Memory and CPU Settings
  cores = "2"
  cpu_type = "host"
  sockets = 1
  memory = "2048"

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
