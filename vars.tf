# Softlayer credentials
variable ibmid {}
variable ibmid_password {}

# Empty string defaults to the Bluemix default account
variable softlayer_account_number {
    default=""
}

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

# Name substring to identify the manager
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
