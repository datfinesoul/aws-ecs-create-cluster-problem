data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

output "aws_ecs_ami_id" {
  value = data.aws_ami.ecs_ami.id
}
