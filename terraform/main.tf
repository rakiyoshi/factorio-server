###########################
# IAM User for discord bot
###########################
#resource "aws_iam_user" "discord_bot" {
#  name = "discord-bot"
#}
#
#resource "aws_iam_policy" "discord_bot" {
#  name   = "discord-bot-policy"
#  policy = data.aws_iam_policy_document.discord_bot.json
#}
#
#data "aws_iam_policy_document" "discord_bot" {
#  statement {
#    actions = [
#    ]
#    resources = [
#    ]
#  }
#}


###############
# EC2 Instance
###############
resource "aws_instance" "factorio" {
  ami              = data.aws_ssm_parameter.amzn2.value
  user_data_base64 = data.local_file.user_data.content_base64
  root_block_device {
    volume_size = 10
  }
  subnet_id              = var.subnet_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.factorio.id
  vpc_security_group_ids = [aws_security_group.factorio.id]

  tags = {
    Name = "factorio"
  }

  lifecycle {
    ignore_changes = [
      ami,
      user_data_base64,
    ]
  }
}

data "local_file" "user_data" {
  filename = "${path.module}/data/user_data.sh"
}

data "aws_ssm_parameter" "amzn2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_iam_instance_profile" "factorio" {
  name = "factorio"
  role = aws_iam_role.factorio.name
}

resource "aws_iam_role" "factorio" {
  name               = "factorio"
  assume_role_policy = data.aws_iam_policy_document.factorio_assume_role.json
}

data "aws_iam_policy" "ssm" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "factorio_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "factorio_ssm" {
  role       = aws_iam_role.factorio.name
  policy_arn = data.aws_iam_policy.ssm.arn
}


##################
# Security groups
##################
resource "aws_security_group" "factorio" {
  name        = "factorio"
  description = "Security group for factorio"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "factorio_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  security_group_id = aws_security_group.factorio.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "factorio_ingress" {
  type              = "ingress"
  from_port         = 34197
  to_port           = 34197
  protocol          = "udp"
  security_group_id = aws_security_group.factorio.id
  cidr_blocks       = ["0.0.0.0/0"]
}
