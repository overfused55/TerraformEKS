data "aws_availability_zones" "available" {}

resource "aws_vpc" "aws_eks" {
  cidr_block = "10.0.0.0/16"

  tags = "${
    map(
     "Name", "terraform-eks-aws-node",
     "kubernetes.io/cluster/${var.aws_eks}", "shared",
    )
  }"
}

resource "aws_subnet" "aws_eks" {
  count = 2

  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = "${aws_vpc.aws_eks.id}"

  tags = "${
    map(
     "Name", "terraform-eks-aws-node",
     "kubernetes.io/cluster/${var.aws_eks}", "shared",
    )
  }"
}

resource "aws_internet_gateway" "aws_eks" {
  vpc_id = "${aws_vpc.aws_eks.id}"

  tags = {
    Name = "terraform-eks-aws"
  }
}

resource "aws_route_table" "aws_eks" {
  vpc_id = "${aws_vpc.aws_eks.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.aws_eks.id}"
  }
}

resource "aws_route_table_association" "aws_eks" {
  count = 2

  subnet_id      = "${aws_subnet.aws_eks.*.id[count.index]}"
  route_table_id = "${aws_route_table.aws_eks.id}"
}