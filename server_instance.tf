resource "aws_security_group" "us-west-2_server_sg" {
        name = "us-west-2_server_sg"
        vpc_id="${aws_vpc.us-west-2_server_vpc.id}"
        
	ingress {
	from_port=22
	to_port=22
	protocol="tcp"
	cidr_blocks=["0.0.0.0/0"]
	}
	egress {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        }

        tags {
                Name="us-west-2_server_sg"
                Environment="server"
        }


}

resource "aws_security_group_rule" "us-west-2_server_sg"{
        type="ingress"
        from_port= 8023
        to_port= 8023
        protocol= "tcp"
        cidr_blocks=["${aws_instance.client.private_ip}/32"]
        security_group_id="${aws_security_group.us-west-2_server_sg.id}"
  }

resource "aws_instance" "server" {
  	ami = "ami-79873901"
  	instance_type="t2.micro"
  	subnet_id="${aws_subnet.us-west-2a_server_subnet.id}"
  	vpc_security_group_ids = ["${aws_security_group.us-west-2_server_sg.id}"]

  	user_data = <<EOF
#!/bin/bash
date
for count in $(seq 1 65000); do
  nc -z -v -w 5 gist.github.com 443 2>&1
  if [ "$?" == "0" ] ; then
    echo $?
    break
  else
    sleep 5
fi
done
apt-get update
apt-get -y install python-pip awscli
pip install --upgrade pip
pip install boto3
git clone https://gist.github.com/78d9c2c34c9cff5256056b23cda9222c.git /opt/server/
python /opt/server/server.py &
date
EOF
  	key_name = "us-west-2-Desktop"
  	tags {
        	Name="us-west-2_server_instance"
        	Environment="server"
  	}

  	iam_instance_profile="${aws_iam_instance_profile.ec2-cw-sg_profile.id}"
}

