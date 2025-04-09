FROM alpine/ansible:2.18.1

# Install dependencies
RUN apk add --no-cache python3 py3-pip openssl ca-certificates py3-jmespath

# Install Ansible Proxmox collection
RUN ansible-galaxy collection install community.general