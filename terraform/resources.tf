# This file was responsible for creating an Ansible inventory composed of the vm IP.
# This is not used anymore, because refreshing the ansible inventory deletes all previous variables, including terraform outputs. 

# resource "local_file" "AnsibleInventory" {
#     content = <<-EOF
#         [host-vm]
#         ${google_compute_instance.host_vm.network_interface.0.access_config.0.nat_ip}
#     EOF
#     filename = "${path.module}/../ansible/inventory.ini"
# }
