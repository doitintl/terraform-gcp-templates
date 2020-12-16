# Terraform GCP plans

Execute the following plans first:
* gcp-terraform
* gcp-organization

Then feel free to execute the other plans as you need.

Once the gcp-terraform plan has been executed, you can use the resulting terraform GCP serviceaccount in your automated CI/CD.

You can also uncomment the GCS backend state configuration in every plan.

---

|**plan**|**description**|
|---|---|
|gcp-terraform| bootstraps all necessary resources for the Terraform GCP serviceaccount and state GCS resources.|
|gcp-organization| bootstraps the organization folder best practices and projects. Needs a preexisting organization folder, and a preexisting billing account.|
|gcp-networking| bootstraps all shared VPC host and service projects.|
|gcp-monitoring| bootstraps common monitoring alerts and metrics.|
