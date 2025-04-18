# Ubuntu Server jammy
# ---
# Packer Template to create an Ubuntu Server (jammy) on Proxmox

# Variable Definitions
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

# Resource Definiation for the VM Template
source "proxmox-iso" "ubuntu-server-jammy" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username = "${var.proxmox_api_token_id}"
  token = "${var.proxmox_api_token_secret}"
  # (Optional) Skip TLS Verification
  insecure_skip_tls_verify = true

  # VM General Settings
  node = "proxmoxau"
  vm_id = "502"
  vm_name = "ubuntu-server-2204"
  template_description = <<EOT
  Ubuntu Server Jammy Image - Built using Packer
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

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size = "25G"
    storage_pool = "local-lvm"
    type = "scsi"
  }

  # VM Memory and CPU Settings
  cores = "2"
  cpu_type = "host"
  sockets = 1
  memory = "2048"

  # VM Network Settings
  network_adapters {
    model = "virtio"
    bridge = "vmbr0"
    firewall = "false"
  }

  # VM Cloud-Init Settings
  cloud_init = true
  cloud_init_storage_pool = "local-lvm"
  tags = "cloudinit;packer"

  # PACKER Boot Commands
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "ip=::::::dhcp::: ",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
     "<f10><wait>"
  ]
  boot = "c"
  boot_wait = "5s"

  # PACKER Autoinstall Settings
  http_directory = "ubuntu-server-jammy/http"
  # (Optional) Bind IP Address and Port
  # http_bind_address = "0.0.0.0"
  http_port_min = 8802
  http_port_max = 8802
  # http_interface = "en0"
  ssh_username = "ali"

  # (Option 1) Add your Password here
  ssh_password = "supersimplepassword"
  # - or -
  # (Option 2) Add your Private SSH KEY file here
  # ssh_private_key_file = "~/.ssh/id_ed25519"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "30m"
}

# Build Definition to create the VM Template
build {
  name = "ubuntu-server-jammy"
  sources = ["source.proxmox-iso.ubuntu-server-jammy"]

  # Post-processor
  # post-processors {
  #     post-processor "shell-local" {
  #         inline = [
  #             "cd /home/homelab/terraform",
  #             "terraform init",
  #             "terraform apply -auto-approve"
  #         ]
  #     }
  # }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
  provisioner "file" {
    source = "ubuntu-server-jammy/files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #3
  provisioner "shell" {
    inline = [ "sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg" ]
  }

  # Provisioning the VM Template with Docker Installation #4
  provisioner "shell" {
    inline = [
      "sudo apt-get install -y ca-certificates curl gnupg lsb-release",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get -y update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io"
    ]
  }
}