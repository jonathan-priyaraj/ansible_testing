resource "null_resource" "webservers" {
  provisioner "local-exec" {
    command = <<EOH
      sleep 10
      ssh-keyscan -t rsa -H invfile >> ~/.ssh/known_hosts 2>/dev/null || true
      ansible -i invfile pvt -m ping
    EOH
  }
  depends_on = [local_file.ansible-inventory-file]
}

