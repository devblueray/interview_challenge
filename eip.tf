resource "aws_eip" "us-west-2_server_eip" {
	vpc=true
}

resource "aws_eip" "us-west-2_client_eip" {
        vpc=true
}

resource "aws_eip_association" "us-west-2_server_eip_assoc" {
	instance_id="${aws_instance.server.id}"
	allocation_id = "${aws_eip.us-west-2_server_eip.id}"
	
}

resource "aws_eip_association" "us-west-2_client_eip_assoc" {
	instance_id="${aws_instance.client.id}"
	allocation_id = "${aws_eip.us-west-2_client_eip.id}"
	
}

