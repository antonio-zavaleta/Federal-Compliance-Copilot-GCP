---
---

## Reality-Based Knowledge Base Operational Steps

1. **Create BigQuery Dataset and Table**
	- Set up a BigQuery dataset (`compliance_profile_dataset`) and table (`sample_table`) with columns for chunk ID, chunk text, embedding vector, and metadata.

2. **Process and Chunk PDF Data**
	- Use Document AI to extract text from PDFs, then run `chunk_documentai_output.py` to split the output into chunks (JSONL).

3. **Upload and Ingest Chunks**
	- Upload chunked JSONL to GCS and ingest into BigQuery, matching the Feature View schema.

4. **Generate Embeddings and Update Table**
	- Use `generate_embeddings.py` to generate embeddings for each chunk with Vertex AI, updating the `embedding_vector` column in BigQuery.

5. **Configure Feature Store and Feature View**
	- Create a Vertex AI Feature Store and Feature View, set BigQuery as the source, select relevant features, and configure sync settings.

6. **Assign IAM Permissions**
	 - Grant the following roles to your service account(s) for secure access to BigQuery and Vertex AI models:
		 - `roles/bigquery.dataEditor`
		 - `roles/bigquery.user`
		 - `roles/aiplatform.user`
		 - `roles/aiplatform.modelUser`
         - `roles/storage.admin` (for GCS access)
	 - Optionally, grant these roles to your root/user account for manual operations and debugging:
		 - `roles/bigquery.dataEditor`
		 - `roles/bigquery.user`
		 - `roles/aiplatform.user`
		 - `roles/aiplatform.modelUser`
		 - `roles/owner` (if full project access is needed)

7. **Sync Feature View**
	- Manually or automatically sync the Feature View to reflect the latest data and embeddings from BigQuery.

8. **Integrate and Test LLM Connectivity**
	- Retrieve chunks and query Gemini (LLM) using the populated knowledge base; validate results with a test script.

9. **Monitor, Troubleshoot, and Document**
	- Monitor pipeline, verify results, update documentation, and ensure reproducibility for future runs.

10. **Best Practices: Infrastructure as Code**
	- Use Terraform or similar IaC tools for reproducible, maintainable cloud infrastructure and automation.

---

## Roles and Permissions

To ensure Vertex AI Feature Store can access your BigQuery dataset, you must grant the following roles to the Vertex AI Feature Store service account:

- `roles/bigquery.dataEditor`
- `roles/bigquery.user`

The service account typically has the format:
`service-<project-number>@gcp-sa-aiplatform.iam.gserviceaccount.com`

For your project, the service account is:
`service-270263865468@gcp-sa-aiplatform.iam.gserviceaccount.com`

**Grant the required roles using these commands:**
```bash
gcloud projects add-iam-policy-binding federal-compliance-copilot-gcp \
	--member="serviceAccount:service-270263865468@gcp-sa-aiplatform.iam.gserviceaccount.com" \
	--role="roles/bigquery.dataEditor"
## Step 11: Adding Necessary Roles to Service Account for Embedding Generation


gcloud projects add-iam-policy-binding federal-compliance-copilot-gcp \
	--member="serviceAccount:service-270263865468@gcp-sa-aiplatform.iam.gserviceaccount.com" \
	--role="roles/bigquery.user"
```

After granting these roles, the Feature Store will be able to access your BigQuery dataset for offline storage and analytics.
---

## Best Practices: Automating Cloud Infrastructure

When building and maintaining cloud-based pipelines, especially on platforms like GCP or AWS, it is highly recommended to use Infrastructure as Code (IaC) tools such as Terraform instead of relying solely on manual steps, bash scripts, or ad-hoc Python scripts.

**Why use IaC tools like Terraform?**
- They reduce human error and speed up onboarding for new team members.
- They help you keep up with changes in cloud GUIs and APIs, since your infrastructure is defined in code.

**When to consider IaC:**
- If you find yourself writing scripts to automate cloud resource creation.
- If you want to ensure consistency across environments (dev, staging, prod).
- If you want to track infrastructure changes in git, alongside your application code.

**Tip:**
If you’re ever unsure, ask: “Is there a best practice or tool for automating this?” or “Should I use Infrastructure as Code for this?”

For more, see the [Terraform appendix](#appendix-what-is-terraform) in this document.
...existing code...
