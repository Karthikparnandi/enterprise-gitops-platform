# Fetch the latest stable Ubuntu 22.04 LTS official image base
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical Official Owner ID
}

resource "aws_instance" "devops_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" # Free Tier Eligible

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Automation Script: Install Docker & Docker Compose on startup automatically
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io
              sudo systemctl enable docker
              sudo systemctl start docker
              
              # Pull Docker Compose CLI Plugin
              sudo mkdir -p /usr/local/lib/docker/cli-plugins/
              sudo curl -SL https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
              sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
              EOF

  tags = {
    Name = "gitops-target-compute-node"
  }
}

# Output the server's public IP once created so we know where to point our deployment
output "node_public_ip" {
  value       = aws_instance.devops_node.public_ip
  description = "The target deployment node public IPv4 address."
}