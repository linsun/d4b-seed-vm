output "manager_public_ip" {
    value = "${ibmcloud_infra_virtual_guest.manager.ipv4_address}"
}

output "manager_private_ip" {
    value = "${ibmcloud_infra_virtual_guest.manager.ipv4_address_private}"
}

output "worker_count_initial" {
    value = "${var.worker_count}"
}
