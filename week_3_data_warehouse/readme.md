## Data Warehouse and BigQuery

- [Slides](https://docs.google.com/presentation/d/1a3ZoBAXFk8-EhUsd7rAZd-5p_HpltkzSeujjRGB2TAI/edit?usp=sharing)  
- [Big Query basic SQL](big_query.sql)

   * OLAP vs OLTP
   * What is data warehouse
   * BigQuery
     - Cost
     - Partitions and Clustering
     - Best practices
     - Internals
     - ML in BQ

    * Images: OLTP vs OLAP
      - ![image](https://github.com/dtlam2601/Data-engineering-zoomcamp/assets/12412633/50cc3fd9-cdb7-4934-93ed-1bf7f40ef7bb)
      - ![image](https://github.com/dtlam2601/Data-engineering-zoomcamp/assets/12412633/bb9795bf-79d3-4000-86de-15ca459a2baa)

    * What is data warehouse
      - Description
    ![image](https://github.com/dtlam2601/Data-engineering-zoomcamp/assets/12412633/53c8bbf7-1a44-49bd-a48e-fa5881ba427c)

    * BigQuery
      - Data Warehouse solution
      - Serverless: no servers to manage or database software.
      - Built-in features like
        - Machine learning
        - Geospatial analysis
        - Business intelligence
      - Separate compute engine for analyzes data from storage.
    * BigQuery > Costs
      - 1 TB of data: $5
      - Flat rate pricing:
        - Numbers of pre requested slots.
        - 1 slot -> $20/month = 4 TB data processed.

    * BigQuery > create table from sources
      ```sql
      -- Creating external table referring to gcs path
      CREATE OR REPLACE EXTERNAL TABLE 'taxi-rides-ny.nytaxi.external_yellow_tripdata'
      OPTIONS (
        format = 'CSV',
        uris = ['gs://data/yellow/yellow_tripdata_2019*.csv', 'gs://data/yellow/yellow_tripdata_2020*.csv']
      );
      ```

    * BigQuery > Partition
      - Example: partitioning by date for tripdata
      ```sql
      -- Creating a non partiton table from external table
      CREATE OR REPLACE EXTERNAL TABLE 'taxi-rides-ny.nytaxi.yellow_tripdata_non_partitioned' AS
      SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;
      -- or
      -- Creating a partitoned table from external table
      CREATE OR REPLACE EXTERNAL TABLE 'taxi-rides-ny.nytaxi.yellow_tripdata_partitioned'
      PARTITION BY
        DATE(tpep_pickup_datetime) AS
      SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;

      -- Check for performance of the total data scanning FOR non partitioned and partitioned table
      SELECT DISTINCT(VendorID)
      FROM
      WHERE DATE(tpep_pickup_datetime)
      ```
    * BigQuery > Partition and Cluster
      ```sql
      -- Creating a partiton and cluster table
      CREATE OR REPLACE EXTERNAL TABLE 'taxi-rides-ny.nytaxi.yellow_tripdata_partitioned_clustered'
      PARTITION BY DATE(tpep_pickup_datetime)
      CLUSTERD BY VendorID AS
      SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;

      -- Check performance: query on the partition and cluster table
      ```
### Data Warehouse

- [Data Warehouse and BigQuery](https://youtu.be/jrHljAoD6nM)
- ![image](https://github.com/dtlam2601/Data-engineering-zoomcamp/assets/12412633/f7caea3e-a7e4-4708-944a-04fb656c632a)

### Partitoning and clustering

- [Partioning and Clustering](https://youtu.be/jrHljAoD6nM?t=726)  
- [Partioning vs Clustering](https://youtu.be/-CqXf7vhhDs)
- [Resources](https://cloud.google.com/bigquery/docs/partitioned-tables)
  - BigQuery partition
    - Daily(default): common for medium size
    - Hourly:
      - Huge amount of data coming
      - Carefully about the number of partitions, bigquery limits till 4000 partitions, so need to the expire partitioning strategy.
    - Monthly or yearly: a small amount of data, across different ranges
   - BigQuery cluster
     - Important: order of column
     - Can spicify up to four clustering columns.
     - Improve
       - Filter queries
       - Aggregate queries
     - Data size < 1 GB, don't need to use partition and cluster because don't show improvement even add significant cost for metadata.
     - Clustering columns must to be top-level, non-repeated columns, and on these types
       - DATE
       - BOOL
       - GEOGRAPHY
       - INT64
       - NUMERIC
       - BIGNUMERIC
       - STRING
       - TIMESTAMP
       - DATETIME
  - Clustering over paritioning
    - The size of per partition is less than 1 GB and granulity of column is high
    - The numbers of partitions beyond the limits on partitioned tables (4000)
    - The frequently of modifying the majority of partitions in the table (every hour)
  - Reclustering
    ![image](https://github.com/dtlam2601/Data-engineering-zoomcamp/assets/12412633/32e22d2a-f38d-488b-8513-9be7856a493c)

### Best practices

- [BigQuery Best Practices](https://youtu.be/k81mLJVX08w)
- Cost reduction
  - Avoid SELECT *
  - Price your queries before running them
  - Use clustered or partitioned tables
  - Use streaming inserts with caution
  - Materialize query results in stages


### Internals of BigQuery

- [Internals of Big Query](https://youtu.be/eduHi1inM4s)  
