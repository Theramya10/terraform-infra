# 🌩️ AWS Infrastructure as Code for Portfolio Website

This repository automates the deployment of a **secure, production-grade static website infrastructure** on AWS using **Terraform**.

---

## 🏗️ Architecture Overview

The infrastructure includes:

- **S3 Bucket (Private)** — Stores static website files.
- **CloudFront Distribution (OAC)** — Delivers content globally with HTTPS and caching.
- **ACM Certificate (us-east-1)** — Enables SSL/TLS for your custom domain.
- **Route 53 Hosted Zone** — Manages DNS for `mygruham.com` and `portfolio.mygruham.com`.
- **IAM Role + OIDC Trust** — Allows GitHub Actions to deploy without long-term AWS keys.

---

## 🔐 Security Best Practices

- **Private S3 + OAC** — No public S3 URLs.
- **TLS via ACM (DNS validation)** — Automated SSL.
- **GitHub OIDC Federation** — No permanent AWS credentials in CI/CD.
- **Least Privilege IAM Policy** — Restricts access to specific S3 and CloudFront resources.

---

## ⚙️ Project Structure

infra-portfolio-aws/
│
├── main.tf # Core Terraform config
├── variables.tf # Input variables
├── outputs.tf # Outputs (domain, distribution URL)
├── iam/
│ ├── github-oidc-trust.json
│ └── github-oidc-policy.json
├── providers.tf # AWS providers (ap-south-1, us-east-1)
├── backend.tf # (optional) Terraform remote state config
└── README.md