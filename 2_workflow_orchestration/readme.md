## Week 2: Workflow Orchestration

### Data Lake (GCS)
* What is a Data Lake
  * Data Lake is a system or repository of data stored in natural/raw format.
  * Users: Data Scientist, and Data Analysts
  * Usecases: Stream Processing, Real-time analysis, Machine learning.
  * Usage: store and access data as soon as possible.
  * Gotcha of Data Lake
    * Converting into Data Swamp
    * No versioning
    * Incompatiple schemas for same data without versioning
    * No metadata associated
    * Joins not possible
* ELT vs. ETL
  * ELT for large amounts of data: Data Lake. Provides Schema on Read.
  * ETL for a small amount of data: Data Warehouse
* Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
  * GCP - Cloud
  * AWS - S3
  * AZURE - AZURE Blob
* Video
* Slides

### 1. Introduction to Workflow orchestration
* What is orchestration?
  * Orchestration is a governing for data flow in a way that respects orchestration rules and business logic.
  * Orchestration turn any code into workflow that you can schedule and obverse.
  * Data flow that binds and otherwise disparate set of applications together.
* Workflow orchestrators vs. other types of orchestrators
  * Workflow orchestration and example
    * Workflow: order, packed, delivery address
    * Workflow Configuration: order of execution, packaging, and delivery type
    * Workflow Orchestration: schedule, privacy, if return, restarts or retries.
* Core features of a workflow orchestration tool
  - Remote Execution
  - Scheduling
  - Retries
  - Caching
  - Integration with external systems (APIs, database)
  - Ad-hoc runs
  - Parameterization
  - Alert you when something fails
* Different types of workflow orchestration tools that currently exist
  - Ingest Saas
  - Ingest Tech
  - Object Storage
  - Megastore
  - Git for Data
  - Open Table Formats
  - Compute
  - Orchestration
  - Observability
  - MLOps End-to-End
  - Data Centric AI/ML
  - Feature Stores
  - ML Observability
  - Notebooks
  - Analytics Workflow
  - Discovery & Governance
🎥  [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=17&pp=iAQB&ab_channel=DataTalksClub%E2%AC%9B)

### 2. Introduction to Prefect concepts
* What is Prefect?
* Installing Prefect
* Prefect flow
* Creating an ETL
* Prefect task
* Blocks and collections
* Orion UI
🎥 [Video](https://www.youtube.com/watch?v=8oLs6pzHp68&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=19&ab_channel=DataTalksClub%E2%AC%9B)

### 3. ETL with GCP & Prefect
* Flow 1: Putting data to Google Cloud Storage
  * Data: https://github.com/DataTalksClub/nyc-tlc-data/releases/
  * Scenario: using Prefect with features as observability and orchestration, schedule, run and monitor.
  * Create a Virtualenv and Install Dependencies
    - Create a Virtualenv
    ```bash
    conda -n zoomcamp python:3.9
    conda activate zoomcamp
    ```
    - Install Dependencies: requirements.txt
    ```bash
    pip install -r requirements.txt
    ```
  * Recap: 'ingest_data.py' and pgAdmin
  * Transform the Script into a Prefect Flow
  * Running your first Prefect Flow
  * Prefect Task: Extract Data
  * Prefect Task: Transform / Data Cleanup
  * Prefect Task: Load Data into Postgres
  * Prefect Flow: Parameterization & Subflows
  * Prefect Orion: Quick Tour through the UI
  * Overview of Notifications & Task Run Concurrency
  * Overview of Prefect Blocks
  * Prefect Blocks: SQLAlchemy - Part I
  * Prefect Collections Catalog
  * Prefect Blocks: SQLAlchemy - Part II
  * Wrapping up & Review
🎥 [Video](https://www.youtube.com/watch?v=cdtN6dhp708&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=19&ab_channel=DataTalksClub%E2%AC%9B)

4. From Google Cloud Storage to Big Query
* Flow 2: From GCS to BigQuery
  
🎥 Video

### 5. Parametrizing Flow & Deployments
* Parametrizing the script from your flow
* Parameter validation with Pydantic
* Creating a deployment locally
* Setting up Prefect Agent
* Running the flow
* Notifications
🎥 Video

### 6. Schedules & Docker Storage with Infrastructure
* Scheduling a deployment
* Flow code storage
* Running tasks in Docker
🎥 Video

### 7. Prefect Cloud and Additional Resources
* Using Prefect Cloud instead of local Prefect
* Workspaces
* Running flows on GCP
🎥 Video

* Prefect docs
* Pefect Discourse
* Prefect Cloud
* Prefect Slack
