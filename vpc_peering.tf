resource "aws_vpc_peering_connection" "server_to_client" {
	peer_vpc_id="${aws_vpc.us-east-1_client_vpc.id}"
	vpc_id="${aws_vpc.us-east-1_server_vpc.id}"
	auto_accept=true

	tags {
		Name = "us-east-1_vpc_peering"
		Environment="shared"
	}

}
