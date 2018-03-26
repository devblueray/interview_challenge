resource "aws_iam_role" "ec2-cw-sg" {
        name = "ec2-cw-sg"
        assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2-cw-sg_policy" {
  name = "ec2-cw-sg_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:RevokeSecurityGroupIngress",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:us-west-2:*:log-group:pinger",
                "arn:aws:logs:us-west-2:*:log-group:pinger:*:pinger"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_policy_attachment" "ec2-cw-sg_attach" {
  name = "ec2-cw-sg_attach"
  roles = ["${aws_iam_role.ec2-cw-sg.name}"]
  policy_arn = "${aws_iam_policy.ec2-cw-sg_policy.arn}"

}

resource "aws_iam_instance_profile" "ec2-cw-sg_profile" {
  name = "ec2-cw-sg_profile"
  role = "${aws_iam_role.ec2-cw-sg.name}"
}

