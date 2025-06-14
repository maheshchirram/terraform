module "ec2_instace" {

    source = "./ec2_instance"
    instance_type = "t2.micro"
    key_name = "mahesh"
    tags = "prod_server"
    ami = "ami-0f88e80871fd81e91"

  
}
