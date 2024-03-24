resource "local_file" "AnsibleInventory" {
    content = <<-EOF
        [host-vm]
        ${google_compute_instance.host_vm.network_interface.0.access_config.0.nat_ip}
    EOF
    filename = "${path.module}/../ansible/inventory.ini"
}