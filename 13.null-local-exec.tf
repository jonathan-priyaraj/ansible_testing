resource "null_resource" "webservers" {
  provisioner "local-exec" {
    command = <<EOH
      sleep 60

      # Ensure .ssh dir exists
      mkdir -p ~/.ssh
      chmod 700 ~/.ssh

      # Add host keys
      for host in $(grep -oE '\\b([0-9]{1,3}\\.){3}[0-9]{1,3}\\b' invfile | sort -u); do
        ssh-keyscan -t rsa -H $host >> ~/.ssh/known_hosts 2>/dev/null || true
      done

      chmod 600 ~/.ssh/known_hosts

      # Disable host key checking for Ansible
      export ANSIBLE_HOST_KEY_CHECKING=False

      # Run Ansible correctly
      ansible all -i invfile -m ping --private-key pvt
    EOH
  }

  depends_on = [local_file.ansible-inventory-file]
}

