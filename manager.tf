# Set your SL/IBMID creds in the following environment variables
# IBMID=...
# IBMID_PASSWORD=...
# Also add your ssh key into SL

# Run this script by running 'terraform plan -var "ssh_key_label=publickey"'
# see 'vars.tf' for variable names and defaults

provider "ibmcloud" {
    ibmid                    = "${var.ibmid}"
    ibmid_password           = "${var.ibmid_password}"
    softlayer_account_number = "${var.softlayer_account_number}"
}

data "ibmcloud_infra_ssh_key" "my_key" {
    label = "${var.ssh_key_label}"
}

resource "ibmcloud_infra_virtual_guest" "manager" {
    count                   = "1"
    hostname                = "devd4i-dal10-docker-${var.name}-mgr${count.index}"
    domain                  = "ibmcloud.com"
    os_reference_code       = "UBUNTU_LATEST"
    datacenter              = "${var.datacenter}"
    cores                   = 1
    memory                  = 2048
    local_disk              = true
    #private_network_only   = true
    hourly_billing          = true
    #post_install_script_uri = "https://d4b-userdata.mybluemix.net/execute-userdata.sh"
    user_metadata           = "#!/bin/bash\nmkdir -p ${var.working_dir}/groups\neth0_ip=$(ifconfig eth0|grep 'inet addr:'|cut -d: -f2|awk '{print $1}')\ncat \u003c\u003c EOF \u003e ${var.working_dir}/groups/d4b-vars.json\n{\n\"cluster_swarm_join_ip\":\"$eth0_ip\",\n\"cluster_swarm_worker_size\":${var.worker_count},\n\"cluster_swarm_worker_name\":\"${var.name}\",\n\"cluster_swarm_sshkey_id\":${data.ibmcloud_infra_ssh_key.my_key.id},\n\"infrakit_docker_image\":\"${var.infrakit_image}\"\n}\nEOF\n"

    ssh_key_ids = [
        "${data.ibmcloud_infra_ssh_key.my_key.id}"
    ]

    # Ensure that the working directory on the manager exists
    provisioner "remote-exec" {
        inline = [
          "mkdir -p ${var.working_dir}"
        ]
        connection {
          type        = "ssh"
          user        = "root"
          private_key = "${file("${var.ssh_private_key_file}")}"
      }
    }

    # Push manager files
    provisioner "file" {
        source = "./manager_files"
        destination = "${var.working_dir}"
        connection {
          type        = "ssh"
          user        = "root"
          private_key = "${file("${var.ssh_private_key_file}")}"
      }
    }

    # Push group files
    provisioner "file" {
        source = "./groups"
        destination = "${var.working_dir}"
        connection {
          type        = "ssh"
          user        = "root"
          private_key = "${file("${var.ssh_private_key_file}")}"
      }
    }

    provisioner "remote-exec" {
        inline = [
          "chmod +x ${var.working_dir}/manager_files/init_manager.sh",
          "DOCKER_IMAGE=${var.infrakit_image} ${var.working_dir}/manager_files/init_manager.sh",
          "docker run --rm -v ${var.working_dir}/groups/:/tmp/infrakit_files ${var.infrakit_image} infrakit template file:////tmp/infrakit_files/infrakit.sh | tee ${var.working_dir}/groups/infrakit.boot | IBMID=${var.ibmid} IBMID_PASSWORD=${var.ibmid_password} LOGGING_LEVEL=${var.logging_level} sh"
        ]
        connection {
          type        = "ssh"
          user        = "root"
          private_key = "${file("${var.ssh_private_key_file}")}"
      }
    }

    # On destroy commands
    provisioner "remote-exec" {
        when       = "destroy"
        inline = [
          "for grp in $(docker exec d4b-manager infrakit group ls | tail -n +2); do docker exec d4b-manager infrakit group destroy $grp --log 5; done"
        ]
        connection {
          type        = "ssh"
          user        = "root"
          private_key = "${file("${var.ssh_private_key_file}")}"
      }
    }
}
