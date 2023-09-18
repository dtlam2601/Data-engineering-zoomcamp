# Week 4: Analytics Engineering 
Goal: Transforming the data loaded in DWH to Analytical Views developing a [dbt project](taxi_rides_ny/README.md).

[Slides](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)

## Prerequisites
We will build a project using dbt and a running data warehouse. 
By this stage of the course you should have already: 
- A running warehouse (BigQuery or postgres) 
- A set of running pipelines ingesting the project dataset (week 3 completed): [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/)
    * Yellow taxi data - Years 2019 and 2020
    * Green taxi data - Years 2019 and 2020 
    * fhv data - Year 2019. 

_Note:_
  *  _A quick hack has been shared to load that data quicker, check instructions in [week3/extras](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_3_data_warehouse/extras)_
  * _If you recieve an error stating "Permission denied while globbing file pattern." when attemting to run fact_trips.sql this video may be helpful in resolving the issue_ 
 
 :movie_camera: [Video](https://www.youtube.com/watch?v=kL3ZVNL9Y4A)
    
### Setting up dbt for using BigQuery (Alternative A - preferred)
You will need to create a dbt cloud account using [this link](https://www.getdbt.com/signup/) and connect to your warehouse [following these instructions](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-setting-up-bigquery-oauth). More detailed instructions in [dbt_cloud_setup.md](dbt_cloud_setup.md)

_Optional_: If you feel more comfortable developing locally you could use a local installation of dbt as well. You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or follow the [dbt with BigQuery on Docker](docker_setup/README.md) guide to setup dbt locally on docker. You will need to install the latest version (1.0) with the BigQuery adapter (dbt-bigquery). 

### Setting up dbt for using Postgres locally (Alternative B)
As an alternative to the cloud, that require to have a cloud database, you will be able to run the project installing dbt locally.
You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or use a docker image from oficial [dbt repo](https://github.com/dbt-labs/dbt/). You will need to install the latest version (1.0) with the postgres adapter (dbt-postgres).
After local installation you will have to set up the connection to PG in the `profiles.yml`, you can find the templates [here](https://docs.getdbt.com/reference/warehouse-profiles/postgres-profile)
## Content
### Introduction to analytics engineering
 * What is analytics engineering?
   - Data Domain Developments
     - Massive parallel processing (MPP) databases
     - Data-pipeline-as-a-service
     - SQL-first
     - Version control systems
     - Self service analytics
     - Data governance
   - Roles in a data team
     - Data Engineer: prepare and maintain infrastructure
     - Analytics Engineer: introduce the good software engineering practices from the data engineer to the efforts of the data analysts and the data scients.
     - Data Analyst: is going to be using the data hosted in that infrestructure to answer questions and solve the problems
   - Tooling
     - Data loading: pipe tool  or stich or it could be: Prefect, Airflow
     - Data storing: cloud data warehouses like: BigQuery, Snowflake, Redshift
     - Data modeling: dbt or Dataform
     - Data presentation: bi tools like Google Data Studio, Looker, Mode, and Tableau
 * ETL vs ELT
   - ETL
     - Extract (sources) > Transform > Load (Data Warehouse) > Reporting
     - Slightly more stable and compliant data analysis (because data is cleaned before load into Data Warehouse)
     - Higher storage and compute costs
   - ELT
     - Extract (sources) > Load (Data Warehouse) > Transform (in Data Warehouse) > Reporting
     - Faster and more flexible data analysis
     - Lower cost and lower maintainance (because load into DW and transform in it)
 * Data modeling concepts (fact and dim tables: Star Schema)
   - Kimball's Dimensional Modeling
     - Objective
       - Deliver data understandable to the business users
       - Deliver fast query performance
     - Approach: priorities understandability and query performance over non-redundant data (3NF)
     - Other modelings
       - Bill Inmon
       - Data Vault
   - Elements of Dimensional Modeling
     - Facts Tables
       - Measurement, metrics, or facts
       - as business process
       - Verbs (etc. Sales, Order, ..)
     - Dimensions Tables
       - Provide contexts to the facts table (business process)
       - as Business entity
       - Nouns (etc. Product, ..)
   - Architecture of Dimensional Modeling
     - Stage Area
       - Raw data
       - In order to process it
     - Processing Area
       - Takes raw data > make data models
       - Focus efficiency
       - Ensuring standard
     - Presentation Area
       - Presentation data
       - Deliver to Business stakeholder

 :movie_camera: [Video](https://www.youtube.com/watch?v=uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=32)

### What is dbt? 
 * Intro to dbt
   ```text
   dbt is a transformation tool by use the good software practice like modularity, portability, CI/CD, and documentation
   - from defining a deployment workflow > develop a model
   - test and document
   - deployment phase: using Version control and CI/CD
   ```
 * How does dbt work?
   - Raw data (in DW) > model data (persist in DW)
   - How
     - Writing a .sql file
     - Select statement
     - dbt compile and run it, ddl and dml are generating, dbt push these file into DW, and then we have table or view in DW
 * How to use dbt?
   - dbt Core: free and open sources, for data transformation
     - builds and runs project (.sql or .yml files)
     - includes SQL compilation logic, imagine macros (functions), database adapters (for change db)
     - CLI interface for run dbt
   - dbt Cloud: web application, manages dbt project
     - includes web-baseds ide to develop run and test dbt project,
     - and schuduler (jobs orchestration)
     - Login and alerting
     - host document (integrated documentation)
     - Free for individuals (one developer seat)
   - How are we going to be use dbt?
     - BigQuery
       - Use cloud IDE
     - Postgres
       - Use local IDE
       - Local installation of dbt core connecting to the Postgres database
       - Running dbt models through the CLI
 
 :movie_camera: [Video](https://www.youtube.com/watch?v=4eCouvVOJUw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=33)

### Starting a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt cloud setup
 * project.yml

 :movie_camera: [Video](https://www.youtube.com/watch?v=iMxh6s_wL4Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=34)
 
#### Alternative b: Using Postgres + dbt core (locally)
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt core local setup
 * profiles.yml
 * project.yml

 :movie_camera: [Video](https://www.youtube.com/watch?v=1HmL63e-vRs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=35)
### Development of dbt models
 * Anatomy of a dbt model: written code vs compiled Sources
   - Written codes a dbt model in .sql file
   - Run .sql file with file_name > compiled code (this compiled code "ddl, dml" runs in the data warehouse)
   - Runs with (without .sql extension): dbt run --select file_name
 * Materialisations: table, view, incremental, ephemeral  
 * Seeds, sources and ref
   - Sources
     - Data that loaded in DWH
     - Configuration defined in the yml files
     - Source freshness
   - Seeds
     - CSV files stores under the seed folder
     - Equivalent to the copy command
     - Recommended for data that doesn't change frequently
     - Runs with: dbt seed -s file_name or dbt seed --full-refresh
   - Ref
     - Reference to the tables and views that were building the data warehouse
     - Dependencies are built automatically
     - tripdata.sql ref both stg_green_tripdata, and stg_yellow_tripdata
       ```sql
       -- dbt model
       with green_data as (
          select *
          from {{ ref('stg_green_tripdata') }}
       )

       -- compiled code
       with green_data as (
          select *
          from "project_id"."dataset_id"."stg_green_tripdata"
       )
       ```
     - schema.yml
       ```yml
       version: 2

       sources:
         - name: staging
           database: dtc-de-396509
           schema: dbt_ny_taxi
      
           tables:
             - name: green_tripdata
             - name: yellow_tripdata
       ```
     - stg_green_tripdata.sql
       ```sql
       select *
       from {{ source("staging", "green_tripdata") }}
       ```
 * Jinja and Macros
   - In macros folder
     ```sql
     {#
         This macro returns the description of the payment type
     #}
      
     {% macro get_payment_type_description(payment_type) -%}
      
         case {{ payment_type }}
              when 1 then 'Credit card'
              when 2 then 'Cash'
              when 3 then 'No charge'
              when 4 then 'Dispute'
              when 5 then 'Unknown'
              when 6 then 'Voided trip'
         end
     {%- endmacro %}
     ```
 - stg_green_tripdata.sql
   ```sql
   select *
       cast(payment_type as integer) as payment_type,
       {{ get_payment_type_description('payment_type')}} as payment_type_description,
       ..
   from {{ source("staging", "green_tripdata") }}
   limit 100
   ```
 * Packages
   - Create packages.yml in directory project
     ```yml
     packages:
       - package: dbt-labs/dbt_utils
         version: 0.8.0
     ```
   - dbt_utils is installed under the dbt_packages folder
   - Runs with (install packages): dbt deps
   - Usage: stg_green_tripdata.sql
     ```sql
     select 
     -- identifiers
       {{ dbt_utils.surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
       ..
     from {{ source("staging", "green_tripdata") }}
     limit 100
     ```
 * Variables
   - Varibles can be defined in two ways
     - In the dbt_project.yml
       ```yml
       vars:
         payment_type_values: [1, 2, 3, 4, 5, 6]
       ```
     - On the command line
   - Usage: {{ var('...') }}
 * Dim and Fact tables
   - models/core/dim_zones.sql:
     - From seeds/taxi_zone_lookup.csv
     - Runs with dbt seed -s seed_file_name or dbt seed --full-refresh
     - dbt_project.yml
       ```yml
       seeds:
          taxi_rides_ny:
             taxi_zone_lookup:
                +column_types:
                   locationid: numeric
         ```
     - dim_zones.sql
       ```sql
       {{ config(materialized="table") }}
       select
           locationid,
           borough,
           zone,
           replace(service_zone,'Boro','Green') as service_zone
       from {{ ref('taxi_zone_lookup') }}
       ```
   - models/core/fact_trips.sql:
     - Runs with dbt seed -s seed_file_name or dbt seed --full-refresh
     - fact_trips.sql
       ```sql
       {{ config(materialized="table") }}
         
       with green_data as (
          select *
          from {{ ref('stg_green_tripdata') }} 
       ),
         
       yellow_data as (
          select *
          from {{ ref('stg_yellow_tripdata') }} 
       ),
         
       trip_unioned as (
          select * from green_data
          union
          select * from yellow_data
       ),
         
       dim_zones as (
           select * from {{ ref('dim_zones') }}
           where borough != 'Unknown'
       )
       select 
           trips_unioned.tripid,
           trips_unioned.vendorid,
           trips_unioned.service_type,
           trips_unioned.ratecodeid,
           trips_unioned.pickup_locationid,
           pickup_zone.borough as pickup_borough,
           pickup_zone.zone as pickup_zone,
           trips_unioned.dropoff_locationid,
           dropoff_zone.borough as dropoff_borough,
           dropoff_zone.zone as dropoff_zone,
           trips_unioned.pickup_datetime,
           trips_unioned.dropoff_datetime,
           trips_unioned.store_and_fwd_flag,
           trips_unioned.passenger_count,
           trips_unioned.trip_distance,
           trips_unioned.trip_type,
           trips_unioned.fare_amount,
           trips_unioned.extra,
           trips_unioned.mta_tax,
           trips_unioned.tip_amount,
           trips_unioned.tolls_amount,
           trips_unioned.ehail_fee,
           trips_unioned.improvement_surcharge,
           trips_unioned.total_amount,
           trips_unioned.payment_type,
           trips_unioned.payment_type_description,
           trips_unioned.congestion_surcharge
       from trips_unioned
       inner join dim_zones as pickup_zone
       on trips_unioned.pickup_locationid = pickup_zone.locationid
       inner join dim_zones as dropoff_zone
       on trip_unioned.dropoff_locationid = dropoff_zone.locationid
       ```
     - Runs with:
       - dbt run (only model)
       - dbt build (everything includes models and seeds)
       - dbt build --select fact_trips (only fact_trips)
       - dbt build --select +fact_trips (everything that fact_trips need)
 ![image](https://github.com/dtlam2601/Data-engineering-zoomcamp/assets/12412633/260873dc-dbfc-4f4d-9453-39072b1abfb2)
 
 :movie_camera: [Video](https://www.youtube.com/watch?v=UVI30Vxzd6c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=36)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

### Testing and documenting dbt models
 * Tests
   - Tests defined on a column in the .yml files
   - Basics tests to check if the column values are:
      - Unique
      - Notnull
      - Accepted values
      - Relationship (A foreign key to another table)
   - Custom tests as queries
 * Documentation
   - Documentation about project is generated and genders as a website
   - The documentation about:
     - Project
     - Data warehouse (information_schema)

 :movie_camera: [Video](https://www.youtube.com/watch?v=UishFmq1hLM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=37)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

### Deploying a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Deployment: development environment vs production 
 * dbt cloud: scheduler, sources and hosted documentation

 :movie_camera: [Video](https://www.youtube.com/watch?v=rjf6yZNGX8I&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=38)
  
#### Alternative b: Using Postgres + dbt core (locally)
 * Deployment: development environment vs production 
 * dbt cloud: scheduler, sources and hosted documentation

 :movie_camera: [Video](https://www.youtube.com/watch?v=Cs9Od1pcrzM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=39)

### Visualising the transformed data
 * Google data studio 
 * [Metabase (local installation)](https://www.metabase.com/)

 :movie_camera: [Google data studio Video](https://www.youtube.com/watch?v=39nLTs74A3E&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=42) 
 
 :movie_camera: [Metabase Video](https://www.youtube.com/watch?v=BnLkrA7a6gM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=43) 

 
### Advanced knowledge:
 * [Make a model Incremental](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models)
 * [Use of tags](https://docs.getdbt.com/reference/resource-configs/tags)
 * [Hooks](https://docs.getdbt.com/docs/building-a-dbt-project/hooks-operations)
 * [Analysis](https://docs.getdbt.com/docs/building-a-dbt-project/analyses)
 * [Snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots)
 * [Exposure](https://docs.getdbt.com/docs/building-a-dbt-project/exposures)
 * [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics)


## Workshop: Maximizing Confidence in Your Data Model Changes with dbt and PipeRider

To learn how to use PipeRider together with dbt for detecting changes in model and data, sign up for a workshop [here](https://www.eventbrite.com/e/maximizing-confidence-in-your-data-model-changes-with-dbt-and-piperider-tickets-535584366257)

[More details](../cohorts/2023/workshops/piperider.md)


## Useful links

- [Visualizing data with Metabase course](https://www.metabase.com/learn/visualization/)
