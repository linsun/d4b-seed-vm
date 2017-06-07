# Softlayer credentials
variable softlayer_username {}
variable softlayer_api_key {}

# Number of workers to deploy
variable worker_count {
    default = 1
}

# Softlayer label for SSH key to use for the manager
variable ssh_key_label {
    default = "publickey"
}

# Local private SSH key file associated with the "ssh_key_label" above
variable ssh_private_key_file {
    default = "~/.ssh/id_rsa"
}

# Softlayer datacenter to deploy the manager
variable datacenter {
    default = "dal10"
}

# Swarm name; workers and managers have this prefix
variable name {
    default = "D4B"
}

# Working directy on the manager
variable working_dir {
    default = "/opt/ibm/d4b"
}

# Logging for terraform when spinning up the worker nodes. 1 is the least verbose, 5 is the most verbose
# The exact levels are: 5=TRACE, 4=DEBUG, 3=INFO, 2=WARN or 1=ERROR
variable logging_level {
    default = 4
}

# Image used for deployment
variable infrakit_image {
    default = ""
}

# Load Balancer IP address
variable lb_ip {
    default = ""
}

# Load Balancer Vlan ID
variable lb_vlanid {
    default = 0
}

# Load Balancer Private Vlan ID
variable lb_vlanid_private {
    default = 0
}

# Number of Load Balancer workers
variable lb_count {
    default = 0
}
