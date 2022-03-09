# Usage
```terraform
module "factorio" {
  source = "https://github.com/rakiyoshi/factorio-server/factorio-server/terraform"

  vpc_id        = data.aws_vpc.default.id
  subnet_id     = data.aws_subnets.subnets.ids[1]
  instance_type = "t3a.medium"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
```
