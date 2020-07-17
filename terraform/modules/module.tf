module "ec2-module" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "ec2-module"
  ami = "ami-ami-0a313d6098716f372"
  subnet_id = "subnet-1bc0bb7c"
  vpc_security_group_ids = ["sg-c8bf828e"]
  instance_type = "t2.micro"
}