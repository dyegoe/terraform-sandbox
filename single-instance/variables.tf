variable "profile" {}
variable "region" {
  default = "eu-west-1"
}
variable "amis" {
  type = "map"
  default = {
    "ap-south-1" = "ami-0a08ded67c78aa042"
    "eu-west-3" = "ami-0e8b2ecaa4cbf286c"
    "eu-west-2" = "ami-fe768399"
    "eu-west-1" = "ami-05e006b617583aef1"
    "ap-northeast-2" = "ami-039ee2dca03377671"
    "ap-northeast-1" = "ami-0fd37f88c0357f538"
    "sa-east-1" = "ami-080929dca7aafb3da"
    "ca-central-1" = "ami-b91b96dd"
    "ap-southeast-1" = "ami-0c2120d5f14d0084f"
    "ap-southeast-2" = "ami-0246dae1c02564c60"
    "eu-central-1" = "ami-05f73a7e32db22fac"
    "us-east-1" = "ami-0df51bbdb09841968"
    "us-east-2" = "ami-0f6518a82d7e57b76"
    "us-west-1" = "ami-079fdd1830a96cfb0"
    "us-west-2" = "ami-b0cfeec8"
  }
}