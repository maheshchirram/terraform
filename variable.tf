variable "vpc_cidr" {

  default = "10.81.0.0/16"

}

variable "sub_cidr_block" {
 
  default = "10.81.3.0/24"

}

variable "nic" {

    default = "10.81.3.33"
  
}

variable "aws_eip" {

    default =  "10.81.3.33"
  
}

variable "ami" {

    default = "ami-0f88e80871fd81e91"
  
}

variable "instance_type" {

      default = "t2.micro"  

}

variable "key_name" {
    default = "mahesh"
  
}

variable "tags" {

  default = "terraform" 
   
}


