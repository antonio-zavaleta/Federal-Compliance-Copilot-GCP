# EXAMPLE USAGE
# poetry run python tools/chunk_documentai_output.py --input input.json --output output.jsonl
import json
import argparse
import uuid

def chunk_documentai_json(json_path, output_path):
    with open(json_path, 'r') as f:
        doc = json.load(f)

    full_text = doc.get('text', '')
    chunks = []
    for page in doc.get('pages', []):
        page_num = page.get('pageNumber', None)
        for block in page.get('blocks', []):
            text_segments = block.get('layout', {}).get('textAnchor', {}).get('textSegments', [])
            for seg in text_segments:
                start = int(seg.get('startIndex', 0))
                end = int(seg.get('endIndex', 0))
                chunk_text = full_text[start:end].strip()
                if chunk_text:
                    chunk_id = str(uuid.uuid4())
                    chunks.append({
                        'chunk_id': chunk_id,
                        'chunk_text': chunk_text,
                        'metadata': f'page:{page_num}',
                    })

    with open(output_path, 'w') as out:
        for chunk in chunks:
            out.write(json.dumps(chunk) + '\n')
    print(f"Wrote {len(chunks)} chunks to {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Chunk DocumentAI JSON output for BigQuery ingestion.")
    parser.add_argument("--input_json", required=True, help="Path to DocumentAI output JSON file.")
    parser.add_argument("--output_jsonl", required=True, help="Path to output JSONL file.")
    args = parser.parse_args()
    chunk_documentai_json(args.input_json, args.output_jsonl)