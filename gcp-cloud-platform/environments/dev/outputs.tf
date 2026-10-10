output "vpc_id" {
  value = module.network.vpc_id
}

output "subnet_id" {
  value = module.network.subnet_id
}

output "instance_group_id" {
  value = module.compute.instance_group_id
}

output "bucket_name" {
  value = module.storage.bucket_name
}

output "bucket_url" {
  value = module.storage.bucket_url
}

output "load_balancer_ip" {
  value = module.load-balancer.load_balancer_ip
}