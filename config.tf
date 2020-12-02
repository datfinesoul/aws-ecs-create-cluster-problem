data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

locals {
  name              = "SAMPLE"
  aws_region        = data.aws_region.current.name
  aws_partition     = data.aws_partition.current.partition
  availability_zone = "${local.aws_region}a"
  instance_type     = "t3.medium"
}
