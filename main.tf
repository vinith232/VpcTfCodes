# Create EC2 Instance
resource "aws_instance" "my-ec2-vm" {
  ami               = "ami-01e479df1702f1d13"  #Ubuntu
  #ami               = "ami-0d2614eafc1b0e4d2"  #windows
  instance_type     = "t2.micro"
  availability_zone = "ap-south-1a"
  #availability_zone = "eu-west-2b"
  tags = {
     "Name" = "web"
    #"tag1" = "Update-test-1"    
  }
}

