# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Ensure this matches your region
}

# Create a security group to allow SSH and HTTP
resource "aws_security_group" "web_sg" {
  name        = "web-security-group"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from anywhere (restrict in production)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = "ami-0e86e20dae9224db8" # Ubuntu 22.04 AMI in us-east-1
  instance_type = "t2.micro"              # Free-tier eligible
  security_groups = [aws_security_group.web_sg.name]
  key_name      = "my-ec2-key"            # Reference the key pair name you created

  tags = {
    Name = "Simple-Web-Server"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.web_server.public_ip
}