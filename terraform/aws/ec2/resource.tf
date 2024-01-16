resource "aws_instance" "server01" {
  ami                    = "ami-06eecef118bbf9259"
  instance_type          = "t2.micro"
  key_name               = "deployer-key"
  vpc_security_group_ids = [aws_security_group.default.id]


  tags = {
    Name = "server01"
  }
}

