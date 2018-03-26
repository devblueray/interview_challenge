resource "aws_security_group" "us-west-2_client_sg" {
        name = "us-west-2_client_sg"
        vpc_id="${aws_vpc.us-west-2_client_vpc.id}"
        
        egress {
        from_port=0
        to_port=0
        protocol="-1"
        cidr_blocks=["0.0.0.0/0"]
        }

	tags {
		Name="us-west-2_client_sg"
		Environment="client"
	}
}

resource "aws_instance" "client" {
        ami = "ami-79873901"
        instance_type="t2.micro"
	subnet_id="${aws_subnet.us-west-2a_client_subnet.id}"
	vpc_security_group_ids = ["${aws_security_group.us-west-2_client_sg.id}"]
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

time apt-get update
time apt-get -y install awscli python3
time ln -s /usr/bin/python3 /usr/bin/python
time echo "* * * * * echo ping | nc ${aws_instance.server.private_ip} 8023 >> /tmp/pinger.log" > /tmp/cronnie
time crontab -u ubuntu /tmp/cronnie
time git clone https://gist.github.com/e3c992ee3a6e0a90d23f5635de5a4b46.git /opt/aws-logs-config/
time wget https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -P /tmp/
time python /tmp/awslogs-agent-setup.py -n -r us-west-2 -c /opt/aws-logs-config/aws-log-config
date
EOF
  key_name = "us-west-2-Desktop"
  tags {
        Name="us-west-2_client_instance"
	Environment="client"
  }
  iam_instance_profile="${aws_iam_instance_profile.ec2-cw-sg_profile.id}"
}

