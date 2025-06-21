# 🤖 Terraform Cost Optimizer (AI + AWS Pricing)
This project analyzes your AWS Terraform infrastructure, estimates monthly costs using real-time AWS Pricing API, and suggests cost-saving alternatives using OpenAI's GPT model.

* 📦 Features
🔍 Parse Terraform .tf files to identify AWS resources.
* 💸 Estimate Monthly Costs:
Uses live AWS Pricing API
Supports resources like:
EC2 (aws_instance)
NAT Gateway (aws_nat_gateway)
Elastic IP (aws_eip)
VPC Peering (estimated)
* 🧠 AI-Based Suggestions:
Uses GPT to recommend:
Lower-cost instance types
Elimination of idle resources
Better networking architecture
* 📁 Modular Design:
parse_tf.py: Extracts resources from Terraform
cost_estimator.py: Calculates cost using AWS Pricing API
ai_suggester.py: AI-powered savings recommendations



This module is developed for joindevops company. Projects inside joindevops follows this module to create their VPC.

## Inputs
* project (required) - Users should specify their project name
* environment (required) - Users should specify their environment
* cidr_block (optional) - Users can provide their CIDR block. Default is 10.0.0.0/16