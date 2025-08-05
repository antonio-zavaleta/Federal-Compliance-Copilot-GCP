# EXECUTION EXAMPLE
# poetry run python tools/generate_embeddings.py --table_name federal-compliance-copilot-gcp.compliance_profile_dataset.sample_table --project_id federal-compliance-copilot-gcp --location us-east4 --embedding_model_name text-embedding-005
import argparse
from google.cloud import bigquery
import vertexai
from vertexai.preview.language_models import TextEmbeddingModel, TextEmbeddingInput

# Set up Vertex AI and BigQuery clients

def generate_and_update_embeddings(table_name, project_id, location, embedding_model_name):
    client = bigquery.Client(project=project_id)
    vertexai.init(project=project_id, location=location)
    model = TextEmbeddingModel.from_pretrained(embedding_model_name)

    # Query all rows from the table
    query = f"SELECT chunk_id, chunk_text FROM `{table_name}` WHERE embedding_vector IS NULL"
    rows = client.query(query).result()

    for row in rows:
        chunk_id = row['chunk_id']
        chunk_text = row['chunk_text']
        if chunk_text:
            text_embedding_input = TextEmbeddingInput(
                task_type="RETRIEVAL_QUERY",
                title="",
                text=chunk_text
            )
            embedding = model.get_embeddings([text_embedding_input])[0].values
            import numpy as np
            embedding_bytes = np.array(embedding, dtype=np.float32).tobytes()
            update_query = f"""
            UPDATE `{table_name}`
            SET embedding_vector = @embedding_bytes
            WHERE chunk_id = @chunk_id
            """
            job_config = bigquery.QueryJobConfig(
                query_parameters=[
                    bigquery.ScalarQueryParameter("embedding_bytes", "BYTES", embedding_bytes),
                    bigquery.ScalarQueryParameter("chunk_id", "STRING", chunk_id),
                ]
            )
            client.query(update_query, job_config=job_config)
            print(f"Updated embedding for chunk_id: {chunk_id}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate embeddings for chunked text and update BigQuery table.")
    parser.add_argument("--table_name", required=True, help="BigQuery table name (project.dataset.table)")
    parser.add_argument("--project_id", required=True, help="GCP project ID")
    parser.add_argument("--location", default="us-east4", help="Vertex AI region")
    parser.add_argument("--embedding_model_name", default="text-embedding-005", help="Vertex AI embedding model name")
    args = parser.parse_args()
    generate_and_update_embeddings(args.table_name, args.project_id, args.location, args.embedding_model_name)
