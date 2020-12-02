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
  instance_type     = "t3.medium"
}
