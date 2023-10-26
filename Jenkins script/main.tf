resource "aws_security_group" "Jenkins-SG" {
    name = "Jenkins-SG"
    description = "This is security group for Jenkins"


    ingress = [
        for port in [22, 443, 80, 8080, 9000, 3000] : {
            description      = "TLS from VPC"
            from_port        = port
            to_port          = port
            protocol         = "tcp"
            cidr_blocks      = ["0.0.0.0/0"]
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            security_groups  = []
            self             = false
  }
]

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "Jenkins-SG"
  }
}

resource "aws_instance" "Amazon" {
    ami = "ami-0fc5d935ebf8bc3bc"
    instance_type = "t2.large"
    vpc_security_group_ids = [ aws_security_group.Jenkins-SG.id ]

    tags = {
      Name = "Amazon"
    }
  
}
