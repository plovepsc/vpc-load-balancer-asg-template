variable "AWS_ACCESS_KEY" {


}

variable "AWS_SECRET_KEY" {
  
 
  
}

variable "AWS_REGION" {
    type = string
  default = "ap-south-1"
}


variable "please-insert-new-ami" {
  
}


# Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "production"
}
# Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type = string
  default = "automation"
}