
# Federal Compliance Copilot (GCP) 🤖📜

An AI-powered agentic system designed to analyze US Federal Request for Proposal (RFP) documents, extract key requirements, and identify compliance risks using Google Cloud Platform (GCP) and state-of-the-art GenAI models.

---


## 🎯 The Problem

Federal RFPs are lengthy and complex. Manual review is slow, error-prone, and risky. Missing a requirement can mean a non-compliant proposal and lost opportunities.

This project builds an "Analyst Copilot" to automate RFP review, saving time and reducing risk.

---


## ✨ Key Features

* **Interactive Q&A:** Ask questions about RFPs in plain English.
* **Automated Requirements Extraction:** Identifies and lists mandatory requirements ("shall", "must", etc.).
* **Risk Identification:** Flags ambiguous or contradictory language for legal review.
* **Executive Summary:** Generates concise summaries with key dates, deliverables, and sections.
* **Knowledge Base:** Creates a searchable KB from uploaded PDFs using a RAG pipeline.

---


## ⚙️ Tech Stack & Architecture

* **Cloud & AI Services:**
    * **Google Cloud Storage:** Stores uploaded RFP PDFs.
    * **Vertex AI / Document AI:** Foundation models and document parsing (planned).
* **Core Framework:**
    * **LangChain / LangGraph:** RAG pipeline and agent orchestration.
* **Application & Deployment:**
    * **FastAPI:** REST API for agent functionality.
    * **Poetry:** Python dependency and packaging management.
    * **Docker:** Containerized deployment for portability.

---


## 🚀 Getting Started

### Prerequisites

* Python 3.10+
* Poetry installed
* Google Cloud account and project
* Service account credentials for GCP (see GCP docs)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/antonio-zavaleta/Federal-Compliance-Copilot-GCP.git
    cd Federal-Compliance-Copilot-GCP
    ```

2.  **Install dependencies using Poetry:**
    ```bash
    poetry install
    ```

3.  **Configure GCP credentials:**
    - Set up your service account and download the JSON key file.
    - Set the environment variable:
      ```bash
      export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/key.json"
      ```

4.  **Run the application:**
    ```bash
    poetry run uvicorn use_case_contracts.main:app --reload
    ```

---


## Usage

Once running, the API and docs are available at `http://127.0.0.1:8000/docs`. You can interact with endpoints directly from this interface.

<!-- Update with curl examples and GCP bucket upload instructions as the API evolves. -->

---


## 🗂 Project Roadmap

- RAG pipeline for PDF ingestion and KB creation
- App for querying the KB
- Logging and monitoring
- Test-driven development (TDD)
- CI/CD pipeline
- Security and compliance (FedRAMP, NIST)
- Documentation and user stories

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on branching, commit messages, and pull requests.

---

## ⚖️ License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
