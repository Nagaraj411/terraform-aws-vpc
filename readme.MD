# 🤖 Terraform Cost Optimizer (AI + AWS Pricing)

Terraform Cost Optimizer helps you **analyze, estimate, and optimize** your AWS infrastructure costs — directly from your Terraform `.tf` files. By integrating **real-time AWS Pricing** and **AI-driven insights**, it provides actionable suggestions to save cloud costs before they spiral out of control.

---

## 📦 Features

- 🔍 **Parse Terraform Files**  
  Extracts AWS resources from `.tf` files using Python + HCL2 parser.

- 💸 **Estimate Monthly Costs**  
  Uses AWS Pricing API for real-time cost estimation.  
  Currently supports:
  - EC2 (`aws_instance`)
  - NAT Gateway (`aws_nat_gateway`)
  - Elastic IP (`aws_eip`)
  - VPC Peering (`aws_vpc_peering_connection` – estimated)

- 🧠 **AI-Powered Cost Suggestions**  
  Leverages OpenAI GPT to:
  - Recommend cheaper instance types
  - Flag idle or underutilized resources
  - Suggest networking improvements

- ⚙️ **Modular & Extensible**
  - `parse_tf.py` — Parses Terraform code
  - `cost_estimator.py` — Pulls real AWS pricing
  - `ai_suggester.py` — AI cost-reduction logic

---

## 🛠 Setup Instructions

## 🌐 VPC Setup Instructions (Terraform)

This guide walks you through creating an AWS VPC, its associated resources, and peering it with another VPC using Terraform.

---

### ✅ 1. Initialize Terraform Project

```bash
terraform init

✅ 2. Create a VPC
Define your VPC in vpc.tf:

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "main-vpc"
  }
}

✅ 3. Create Subnets

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "main-public-subnet"
  }
}
