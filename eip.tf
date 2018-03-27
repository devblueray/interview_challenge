resource "aws_eip" "us-east-1_server_eip" {
	vpc=true
}

resource "aws_eip" "us-east-1_client_eip" {
        vpc=true
}

resource "aws_eip_association" "us-east-1_server_eip_assoc" {
	instance_id="${aws_instance.server.id}"
	allocation_id = "${aws_eip.us-east-1_server_eip.id}"
	
}

resource "aws_eip_association" "us-east-1_client_eip_assoc" {
	instance_id="${aws_instance.client.id}"
	allocation_id = "${aws_eip.us-east-1_client_eip.id}"
	
}

