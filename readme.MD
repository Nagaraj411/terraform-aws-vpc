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

### ✅ 1. Clone the Repo

```bash
git clone https://github.com/Nagaraj411/terraform-aws-vpc.git
cd terraform-cost-optimizer

✅ 2. Install Dependencies

pip install -r requirements.txt

boto3 — AWS SDK for Python

openai — GPT-based AI logic

- `python-hcl2` — For reading Terraform files