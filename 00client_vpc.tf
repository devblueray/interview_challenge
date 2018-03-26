
resource "aws_vpc" "us-west-2_client_vpc" {
	cidr_block = "10.2.0.0/16"
	enable_dns_support = true
	enable_dns_hostnames = true

	tags {
		Name="us-west-2_client_vpc"
		Environment="client"
	}
}

resource "aws_subnet" "us-west-2a_client_subnet" {
	vpc_id = "${aws_vpc.us-west-2_client_vpc.id}"
	cidr_block="10.2.0.0/24"
	availability_zone="us-west-2a"
	map_public_ip_on_launch = false

	tags {
		Name="us-west-2a_client_subnet"
		Environment="client"
	}
	
}

resource "aws_internet_gateway" "us-west-2_client_gateway" {
	vpc_id = "${aws_vpc.us-west-2_client_vpc.id}"

	tags {
		Name="us-west-2_client_ig"
		Environment="client"
	}
}

resource "aws_route_table" "us-west-2_client_routetable" {
	vpc_id = "${aws_vpc.us-west-2_client_vpc.id}"
	
	route {
		cidr_block="0.0.0.0/0"
		gateway_id="${aws_internet_gateway.us-west-2_client_gateway.id}"
	}

        route {
                cidr_block="${aws_vpc.us-west-2_server_vpc.cidr_block}"
                gateway_id="${aws_vpc_peering_connection.server_to_client.id}"
        }

	
	tags {
		Name="us-west-2_client_rt"
		Environment="client"
	}
}

resource "aws_route_table_association" "us-west-2a_client_subnet_rta" {
	subnet_id="${aws_subnet.us-west-2a_client_subnet.id}"
	route_table_id = "${aws_route_table.us-west-2_client_routetable.id}"
}



