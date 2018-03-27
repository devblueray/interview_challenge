resource "aws_security_group" "us-east-1_server_sg" {
        name = "us-east-1_server_sg"
        vpc_id="${aws_vpc.us-east-1_server_vpc.id}"
        
	egress {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        }

        tags {
                Name="us-east-1_server_sg"
                Environment="server"
        }


}

resource "aws_security_group_rule" "us-east-1_server_sg"{
        type="ingress"
        from_port= 8023
        to_port= 8023
        protocol= "tcp"
        cidr_blocks=["${aws_instance.client.private_ip}/32"]
        security_group_id="${aws_security_group.us-east-1_server_sg.id}"
  }


resource "aws_instance" "server" {
  	ami = "ami-66506c1c"
  	instance_type="t2.micro"
  	subnet_id="${aws_subnet.us-east-1a_server_subnet.id}"
  	vpc_security_group_ids = ["${aws_security_group.us-east-1_server_sg.id}"]

  	user_data = <<EOF
#!/bin/bash
date
ping -c4 www.google.com
for count in $(seq 1 65000); do
  nc -z -v -w 5 gist.github.com 443 2>&1
  if [ "$?" == "0" ] ; then
    echo $?
    break
  else
    sleep 5
fi
done
time apt-get update
time apt-get -y install docker.io
time docker run -d -p 8023:8023 devblueray/interview:east
date
EOF
  	key_name = "us-east-1-Desktop"
  	tags {
        	Name="us-east-1_server_instance"
        	Environment="server"
  	}
        key_name="us-east-1-Desktop"
  	iam_instance_profile="${aws_iam_instance_profile.ec2-cw-sg_profile.id}"
}

