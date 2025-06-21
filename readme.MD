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

# 🌐 Terraform VPC Setup with Peering – Project Overview

This Terraform module sets up a complete VPC environment on AWS, including subnets, internet gateway, route tables, and peering with another VPC. It is designed for modular infrastructure, multi-account support, and production-readiness.

---

## 📋 Project Highlights

- Creates a customizable VPC with CIDR block of your choice.
- Supports public and private subnets across multiple availability zones.
- Sets up internet access through an Internet Gateway.
- Configures custom route tables and associations for traffic routing.
- Establishes VPC peering with another VPC (same or cross-account).
- Adds routing between VPCs to enable secure communication.
- Modular structure for easier reuse and integration into CI/CD pipelines.

---

## 🚀 Setup Steps

### Step 1: Initialize Terraform

Begin by initializing the Terraform project to install necessary providers and modules.

### Step 2: Configure the VPC

Define the CIDR range, name, and region for the primary VPC. Include subnet details for public and private access.

### Step 3: Create Network Components

Set up subnets, internet gateway, route tables, and associate them correctly to allow outbound internet access and internal routing.

### Step 4: Configure VPC Peering

Establish a peering connection between the current VPC and a target peer VPC. This enables private connectivity between them.

### Step 5: Accept the Peering Connection

If peering is across different AWS accounts or regions, configure acceptance of the connection from the peer side.

### Step 6: Add Routing for Peering

Modify the route tables in both VPCs to allow traffic to flow across the peered VPCs using their respective CIDR ranges.

### Step 7: Apply the Configuration

Run Terraform commands to validate and apply the configuration. This provisions all infrastructure resources.

---

## 🛡️ Best Practices

- Use remote state backend (like S3 + DynamoDB) for collaboration and state locking.
- Parameterize environment-specific values using input variables.
- Output key resource values (e.g., VPC ID, subnet IDs) for downstream modules.
- Follow least privilege principle for IAM roles used with Terraform.

---

## 📁 Folder Structure

terraform/
├── main.tf ├── variables.tf
├── outputs.tf
├── vpc.tf
├── peering.tf
├── README.md