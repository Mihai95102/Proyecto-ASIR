# Configuramos el proveedor de AWS
provider "aws" {
  region = "us-east-1"
}

# Creamos un grupo de seguridad para Plesk
resource "aws_security_group" "sg_plesk" {
  name        = "sg_plesk"
  description = "Grupos de seguridad para las instancias de Plesk"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8880
    to_port     = 8880
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 21
    to_port     = 21
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 110
    to_port     = 110
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 143
    to_port     = 143
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 993
    to_port     = 993
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7080
    to_port     = 7080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 7081
    to_port     = 7081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8847
    to_port     = 8847
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Creamos un grupo de seguridad para BD_Plesk
resource "aws_security_group" "sg_bd" {
  name        = "sg_bd"
  description = "Grupo de seguridad para la instancia de BD"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Creamos un grupo de seguridad para NFS_Server
resource "aws_security_group" "sg_nfs" {
  name        = "sg_nfs"
  description = "Grupo de seguridad para la instancia de NFS Server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Creamos una instancia EC2 para Plesk 1
resource "aws_instance" "Plesk1" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.sg_plesk.name]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Plesk1"
  }
}

# Creamos una instancia EC2 para Plesk 2
resource "aws_instance" "Plesk2" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.sg_plesk.name]
  
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "Plesk2"
  }
}

# Creamos una instancia EC2 para BD_Plesk
resource "aws_instance" "BD_Plesk" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.sg_bd.name]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 50
    delete_on_termination = true
  }

  tags = {
    Name = "BD_Plesk"
  }
}

# Creamos una instancia EC2 para NFS_Server
resource "aws_instance" "NFS_Server" {
  ami             = "ami-00874d747dde814fa"
  instance_type   = "t2.medium"
  key_name        = "vockey"
  security_groups = [aws_security_group.sg_nfs.name]

  tags = {
    Name = "NFS_Server"
  }
}

# Creamos una IP elástica y la asociamos a la instancia del Plesk 1
resource "aws_eip" "ip_elastica1" {
  instance = aws_instance.Plesk1.id
}

# Creamos una IP elástica y la asociamos a la instancia del Plesk 2
resource "aws_eip" "ip_elastica2" {
  instance = aws_instance.Plesk2.id
}

# Creamos una IP elástica y la asociamos a la instancia del BD_Plesk
resource "aws_eip" "ip_elastica3" {
  instance = aws_instance.BD_Plesk.id
}

# Creamos una IP elástica y la asociamos a la instancia del NFS_Server
resource "aws_eip" "ip_elastica4" {
  instance = aws_instance.NFS_Server.id
}

# Creamos una variable de salida con la IP pública de la instancia Plesk 1
output "ip_publica1" {
  value = aws_instance.Plesk1.public_ip
}

# Creamos una variable de salida con la IP pública de la instancia Plesk 2
output "ip_publica2" {
  value = aws_instance.Plesk2.public_ip
}

# Creamos una variable de salida con la IP pública de la instancia BD_Plesk
output "ip_publica3" {
  value = aws_instance.BD_Plesk.public_ip
}

# Creamos una variable de salida con la IP pública de la instancia NFS_Server
output "ip_publica4" {
  value = aws_instance.NFS_Server.public_ip
}