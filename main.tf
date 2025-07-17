# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  count             = 3
  ami               = "ami-06b6e5225d1db5f46"  #Ubuntu
  #ami               = "ami-0d2614eafc1b0e4d2"  #windows
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  #availability_zone = "eu-west-2b"
  tags = {
     "Name" = "web"
    #"tag1" = "Update-test-1"    
  }
}

