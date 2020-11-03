


variable "keypair_name" {
    description = "The keypair to be used."
    default  = "ahmed-key"
}

variable "network_name" {
    description = "The network to be used."
    default  = "net_test"
}

variable "instance_name" {
    description = "The Instance Name to be used."
    default  = "tf-test"

}

variable "image_id" {
    description = "The image ID to be used."
    default  = "c2e4639f-e09f-44e5-81c5-d02c10e1a827"
}

variable "flavor_id" {
    description = "The flavor id to be used."
    default  = "340a6e45-d635-4c2e-b916-1c6724afa308"
}

variable "floating_ip_pool" {
    description = "The pool to be used to get floating ip"
    default = ""
}

variable "volume_size" {
    description = "The size of volume used to instantiate the instance"
    default = "5G"
}

variable "security_groups" {
    description = "List of security group"
    type = list
    default = ["default"]
}


