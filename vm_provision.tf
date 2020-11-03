provider "openstack" {
  user_name   = "admin"
  password    = "Av1x6Vm4uoBxo3EGp4HAyWBK9"
  auth_url    =  "http://10.81.1.150:5000/v3"
  tenant_name = "admin"
  project_domain_name= "default"
  region      = "regionOne"
}


resource "openstack_compute_instance_v2" "Instance" {
  name = "asad"
  flavor_id = var.flavor_id
  image_id = var.image_id
  key_pair = local.normalized_value.key_name
  security_groups = local.security_groups_list 
  user_data = file("bootstrap.sh")
                 
   dynamic "network" {
    for_each = local.net_ids
    content {
      uuid                 = network.value
           }
    }
  
    block_device {
    uuid                  = var.image_id
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
                 }
 

    dynamic "block_device" {
       for_each = local.volume_list
    content {

    uuid                  = block_device.value
    source_type           = "volume"
    destination_type      = "volume"
    delete_on_termination = true
    boot_index            = 1
            }
  }
}






output "instance_ip" {
    value = openstack_compute_instance_v2.Instance.access_ip_v4
}


output "terraorm-provide" {
	value= "Connect with openstack auth"

}



output "netwrk" {
  value = local.net_ids
}

output "volumes" {
  value = local.volume_list
}



locals {
     json_data = jsondecode(file("${path.module}/openstack-vm-prov.json"))
     normalized_value = {
     key_name   = tostring(try(local.json_data.server.key_name, null))
     networks = try([tostring(local.json_data.server.networks)],tolist(local.json_data.server.networks),)   
     security_groups = try([tostring(local.json_data.server.security_groups)],tolist(local.json_data.server.security_groups),[])
     volume_objects = try([tostring(local.json_data.server.volumes)],tolist(local.json_data.server.volumes),[])
          }
    net_ids = [
             for person in local.normalized_value.networks:
      person.uuid
             ]
   
    security_groups_list = [
             for person in local.normalized_value.security_groups:
      person.name
             ]
    volume_list = [
             for person in local.normalized_value.volume_objects:
      person.uuid
             ]



}
