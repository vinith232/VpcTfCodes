# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami               = "ami-00bb6a80f01f03502"  #Ubuntu
  #ami               = "ami-0d2614eafc1b0e4d2"  #windows
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1b"
  #availability_zone = "ap-south-1a"
  tags = {
     "Name" = "web"
    #"tag1" = "Update-test-1"    
  }
}

