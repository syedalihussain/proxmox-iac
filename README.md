# proxmox-iac

### Run script using command

```sh
docker run -v ./:/workdir -v ~/.ssh:/root/.ssh -w /workdir --rm -it alpine/ansible:2.18.1 ansible-playbook -i inventory.yaml -k -u root playbook-post-install.yaml
```

```sh
docker compose -f docker-compose.yaml run --rm terraform init
```
