# EXECUTION EXAMPLE
# python tools/test_llm_integration.py --user_query "What are the compliance requirements for

import sys
import argparse
from google.cloud import bigquery
from vertexai.preview.generative_models import GenerativeModel

# CONFIGURATION

parser = argparse.ArgumentParser(description="Test Gemini LLM integration with context chunks from BigQuery.")
parser.add_argument("--user_query", required=True, help="Query to send to Gemini LLM")
args = parser.parse_args()

PROJECT_ID = "federal-compliance-copilot-gcp"
DATASET = "compliance_profile_dataset"
TABLE = "sample_table"
QUERY = "SELECT chunk_text, embedding_vector FROM `{}`.{} WHERE chunk_text IS NOT NULL".format(DATASET, TABLE)

# Step 1: Fetch sample chunks and embeddings from BigQuery
client = bigquery.Client(project=PROJECT_ID)
rows = client.query(QUERY).result()
chunks = []
for row in rows:
    chunks.append(row["chunk_text"])


# Step 2: Format context for Gemini

context = "\n".join(chunks)
user_query = args.user_query


# Step 3: Call Gemini API (Vertex AI)
model = GenerativeModel("gemini-2.0-flash-lite")
response = model.generate_content([context, user_query])
print("Gemini Response:", response.text)
