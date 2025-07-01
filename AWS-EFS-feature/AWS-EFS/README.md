
#  AWS EFS Setup with Terraform & GitHub Actions

This project uses Terraform to create an AWS EFS (Elastic File System) with automated deployment via GitHub Actions.

---

##  What It Does

- Creates an EFS file system
- Creates mount targets in multiple subnets
- Sets up a security group allowing NFS traffic (port 2049)
- Automates the deployment using GitHub Actions CI/CD

---

##  File Structure

```
.
├── main.tf                # EFS, SG, Mount Targets
├── provider.tf            # AWS provider config
├── backend.tf             # S3 remote state backend
├── variables.tf           # Variable definitions
├── terraform.tfvars       # Variable values (like vpc_id, subnets)
├── outputs.tf             # Output EFS ID
└── .github/
    └── workflows/
        └── terraform.yml  # GitHub Actions pipeline
```

---

##  Prerequisites

- AWS account with appropriate IAM access
- **S3 bucket created manually before first run** (used for remote `terraform.tfstate`)
- Terraform CLI installed (v1.6+ recommended)
- GitHub repo with Secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

>  **Note:** If using an S3 backend (in `backend.tf`), make sure the bucket exists before running `terraform init`. Terraform cannot create the backend bucket itself.

---

##  Terraform Setup

### 1️ Initialize Terraform

```bash
terraform init
```

>  If using remote state (S3), make sure your state bucket exists in AWS before running this.

### 2️ Validate Configuration

```bash
terraform validate
```

### 3 Run Terraform Plan

```bash
terraform plan -var-file="terraform.tfvars"
```

### 4 Apply the Infrastructure

```bash
terraform apply -auto-approve -var-file="terraform.tfvars"
```

---

##  GitHub Actions CI/CD

The GitHub Actions workflow runs on every push to `main` branch and performs:

- `terraform init`
- `terraform validate`
- `terraform plan`
- `terraform apply`

Configure your secrets under **Settings → Secrets → Actions**.

---

##  Sample `terraform.tfvars`

```hcl
region        = "us-east-1"
vpc_id        = "vpc-0cef9ead579ee42cf"
subnet_ids    = ["subnet-xxxx", "subnet-yyyy"]
efs_name      = "MyEFS"
efs_sg_name   = "efs-sg"
```

---

##  Outputs

After apply, Terraform will output the EFS file system ID:

```
efs_id = fs-1234567890abcdefg
```

---

##  Notes

- Ensure subnets are in different AZs for high availability.
- EFS works over NFS (port 2049), so SG should allow inbound TCP on 2049.

---

##  Cleanup

To destroy the created resources:

```bash
terraform destroy -var-file="terraform.tfvars"
```

---
##  How to Create S3 Bucket for Remote tfstate

Before running `terraform init`, make sure your S3 bucket is created:

###  Using AWS CLI

```bash
aws s3api create-bucket \
  --bucket your-terraform-state-bucket-name \
  --region us-east-1
```

> ⚠ Replace `your-terraform-state-bucket-name` with a globally unique name.

You can also enable versioning (recommended):

```bash
aws s3api put-bucket-versioning \
  --bucket your-terraform-state-bucket-name \
  --versioning-configuration Status=Enabled
```


