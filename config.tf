data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  name              = "SAMPLE"
  aws_region        = data.aws_region.current.name
  aws_partition     = data.aws_partition.current.partition
  vpc_cidr          = "172.25.0.0/16"
  availability_zone = "${local.aws_region}a"
  subnet_cidr       = "172.25.128.0/25"
  vpc_id            = "vpc-073a71538e6890e3c"
  vpc_igw_id        = "igw-05fe51775897bc436"
  instance_type     = "t3.medium"
}
