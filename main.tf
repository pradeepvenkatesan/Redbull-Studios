provider "aws" {
    region = "us-east-1"
}

resource "aws_security_group" "mysg" {
  name = "my-sg"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Redbull" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  key_name = "Red"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  user_data = file("script.sh")


  provisioner "file" {
    source = "Master/"
    destination = "/home/ubuntu"

    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("C:/Users/rockp/Downloads/Red.pem")
      host = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp -r /home/ubuntu/* /var/www/html/",
      "sudo systemctl restart apache2"
    ] 
    
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("C:/Users/rockp/Downloads/Red.pem")
      host = self.public_ip
    }
  } 

  tags = {
   name = "terraform-local"
  }
  
}
output "public_ip" {
  value = aws_instance.Redbull.public_ip
}