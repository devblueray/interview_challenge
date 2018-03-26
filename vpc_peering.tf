resource "aws_vpc_peering_connection" "server_to_client" {
	peer_vpc_id="${aws_vpc.us-west-2_client_vpc.id}"
	vpc_id="${aws_vpc.us-west-2_server_vpc.id}"
	auto_accept=true

	tags {
		Name = "us-west-2_vpc_peering"
		Environment="shared"
	}

}
