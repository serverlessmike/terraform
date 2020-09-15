resource "aws_rds_cluster_instance" "staging-automic-1" {
  count                        = 2
  identifier                   = "staging-automic-${count.index}"
  cluster_identifier           = "${aws_rds_cluster.staging-automic.id}"
  instance_class               = "db.r4.large"
  engine                       = "aurora-postgresql"
  engine_version               = "10.7"
  db_subnet_group_name         = "automic-subnet-group"
  db_parameter_group_name      = "automic-db-pg"
  preferred_maintenance_window = "mon:19:00-mon:20:00"
  auto_minor_version_upgrade   = false
}

resource "aws_rds_cluster" "staging-automic" {
  cluster_identifier              = "staging-automic"
  availability_zones              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_name                   = ""
  master_username                 = "postgres"
  master_password                 = "p05tGr35!"
  backup_retention_period         = 7
  preferred_backup_window         = "18:00-19:00"
  preferred_maintenance_window    = "mon:19:00-mon:20:00"
  port                            = "5432"
  engine                          = "aurora-postgresql"
  engine_version                  = "10.7"
  vpc_security_group_ids          = ["${aws_security_group.automic-security-group.id}"]
  db_subnet_group_name            = "automic-subnet-group"
  db_cluster_parameter_group_name = "aurora-cluster-pg"
}

resource "aws_db_subnet_group" "automic-subnet-group" {
  name       = "automic-subnet-group"
  subnet_ids = ["subnet-0588bd6801b9784ba", "subnet-05cb6eb6e8db5d82d", "subnet-0697442c6ba2dff81"]

  tags = {
    Name = "automic-subnet-group"
  }
}

resource "aws_db_parameter_group" "automic-db-pg" {
  name   = "automic-db-pg"
  family = "aurora-postgresql10"

  parameter {
    name  = "shared_preload_libraries"
    value = "pg_stat_statements"
  }

  parameter {
    name  = "log_lock_waits"
    value = "on"
  }

  parameter {
    name  = "idle_in_transaction_session_timeout"
    value = "300000"
  }

  parameter {
    name  = "pg_stat_statements.track_utility"
    value = "on"
  }

  parameter {
    name  = "random_page_cost"
    value = "1.0"
  }
}

resource "aws_rds_cluster_parameter_group" "automic-cluster-pg" {
  name        = "aurora-cluster-pg"
  family      = "aurora-postgresql10"
  description = "RDS default cluster parameter group"

  parameter {
    name  = "autovacuum_vacuum_cost_delay"
    value = "0"
  }

  parameter {
    name  = "vacuum_cost_limit"
    value = "10000"
  }

  parameter {
    name  = "autovacuum_vacuum_scale_factor"
    value = "0.01"
  }

  parameter {
    name  = "autovacuum_naptime"
    value = "60"
  }

  parameter {
    name  = "client_encoding"
    value = "LATIN1"
  }
}

resource "aws_db_option_group" "automic-og" {
  name                     = "automic-option-group"
  option_group_description = "Automic Option Group"
  engine_name              = "aurora-postgresql"
  major_engine_version     = 10
}

resource "aws_security_group" "automic-security-group" {
  name        = "automic-sg"
  description = "automic-security-group"
  vpc_id      = "vpc-0be3658f035bdf311"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
