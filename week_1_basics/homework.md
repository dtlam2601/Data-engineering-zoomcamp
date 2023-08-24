>[Back to Setting up the Environment on Google Cloud](env_setup.md)

>Next: []()

>Reference:
 * [Week 1 Introduction](https://itnadigital.notion.site/Week-1-Introduction-f18de7e69eb4453594175d0b1334b2f4)
 * [Note](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/1_intro.md?plain=1)

### Table of contents
* [The Data School](#the-data-school)
* [Part A: docker-sql](#part-a-docker-sql)
  * [Question 1. Knowing docker tags](#question-1-knowing-docker-tags)
  * [Question 2. Understanding docker first run]()
  * [Prepare Postgres]()
  * [Question 3. Count records]()
  * [Question 4. Largest trip for each day]()
  * [Question 5. The number of passengers]()
  * [Question 6. Largest tip]()
* [Part B: Terraform](#part-b-terraform)

## The Data School
* [sql-join-types-explained-visually](https://dataschool.com/how-to-teach-people-sql/sql-join-types-explained-visually/)
* [Join(SQL)](https://www.wikiwand.com/en/Join_(SQL))

## Part A: docker-sql
### Question 1. Knowing docker tags
```
docker --help
docker build --help
--iidfile string
```

### Question 2. Understanding docker first run
```bash
docker run -it --entrypoint bash python:3.9
# How many python packages/modules are installed? 3
```

### Prepare Postgres
```ipython
!wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz
!wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv

# uncompress/decompress
!unzip -d green_tripdata_2019-01.csv.gz
```

### Question 3. Count records
```sql
SELECT count(*) from green_taxi_trips
WHERE TO_CHAR(lpep_pickup_datetime, 'MM-DD')='01-15' and 
TO_CHAR(lpep_dropoff_datetime, 'MM-DD')='01-15';

# or
SELECT count(*) from green_taxi_trips
WHERE DATE(lpep_pickup_datetime)='2019-01-15' and 
DATE(lpep_dropoff_datetime)='2019-01-15';
```
* How many taxi trips were totally made on January 15? 20530

### Question 4. Largest trip for each day
* Which was the day with the largest trip distance Use the pick up time for your calculations. 2019-01-15
```sql
SELECT DATE(lpep_pickup_datetime)
FROM green_taxi_trips
WHERE trip_distance = (SELECT MAX(trip_distance) FROM green_taxi_trips);

# or
SELECT date(lpep_pickup_datetime), MAX(trip_distance) as M
FROM green_taxi_trips
GROUP BY date(lpep_pickup_datetime)
ORDER BY M DESC
LIMIT 1;
```

### Question 5. The number of passengers
* In 2019-01-01 how many trips had 2 and 3 passengers? 2: 1282 ; 3: 254
```sql
(SELECT COUNT(*) FROM green_taxi_trips WHERE DATE(lpep_pickup_datetime) = '2019-01-01' AND passenger_count = 2)
UNION
(SELECT COUNT(*) FROM green_taxi_trips WHERE DATE(lpep_pickup_datetime) = '2019-01-01' AND passenger_count = 3);

# or
SELECT passenger_count, COUNT(*)
FROM green_taxi_trips
WHERE DATE(lpep_pickup_datetime) = '2019-01-01'
GROUP BY passenger_count;
```

### Question 6. Largest tip
* For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip? We want the name of the zone, not the id.
* Note: it's not a typo, it's tip , not trip
```sql
SELECT z2."Zone", MAX(tip_amount) as Max_tip
FROM green_taxi_trips g
JOIN zones z
on "PULocationID" = z."LocationID"
JOIN zones z2
on "DOLocationID" = z2."LocationID"
WHERE z."Zone" = 'Astoria'
GROUP BY z2."Zone"
ORDER BY Max_tip DESC
LIMIT 1;
```

As a final note, SQL commands can be categorized into the following categories:
* ***DDL***: Data Definition Language.
    * Define the database schema (create, modify, destroy)
    * `CREATE`, `DROP`, `ALTER`, `TRUNCATE`, `COMMENT`, `RENAME`
* ***DQL***: Data Query Language.
    * Perform queries on the data within schema objects. Get data from the database and impose order upon it.
    * `SELECT`
* ***DML***: Data Manipulation Language.
    * Manipulates data present in the database.
    * `INSERT`, `UPDATE`, `DELETE`, `LOCK`...
* ***DCL***: Data Control Language.
    * Rights, permissions and other controls of the database system.
    * Usually grouped with DML commands.
    * `GRANT`, `REVOKE`
* ***TCL***: Transaction Control Language.
    * Transactions within the database.
    * Not a universally considered category.
    * `COMMIT`, `ROLLBACK`, `SAVEPOINT`, `SET TRANSACTION`

_[Back to the top](#table-of-contents)_

## Part B: Terraform
In this homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP install Terraform. Copy the files from the course repo
[here](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_1_basics_n_setup/1_terraform_gcp/terraform) to your VM.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.

* Terraform divides information into ***blocks***, which are defined within braces (`{}`), similar to Java or C++. However, unlike these languages, statements are not required to end with a semicolon `;` but use linebreaks instead.
* By convention, arguments with single-line values in the same nesting level have their equal signs (`=`) aligned for easier reading.
* There are 3 main blocks: `terraform`, `provider` and `resource`. There must only be a single `terraform` block but there may be multiple `provider` and `resource` blocks.
* The `terraform` block contains settings:
    * The `required_providers` sub-block specifies the providers required by the configuration. In this example there's only a single provider which we've called `google`.
        * A _provider_ is a plugin that Terraform uses to create and manage resources.
        * Each provider needs a `source` in order to install the right plugin. By default the Hashicorp repository is used, in a similar way to Docker images.
            * `hashicorp/google` is short for `registry.terraform.io/hashicorp/google` .
        * Optionally, a provider can have an enforced `version`. If this is not specified the latest version will be used by default, which could introduce breaking changes in some rare cases.
    * We'll see other settings to use in this block later.
* The `provider` block configures a specific provider. Since we only have a single provider, there's only a single `provider` block for the `google` provider.
    * The contents of a provider block are provider-specific. The contents in this example are meant for GCP but may be different for AWS or Azure.
    * Some of the variables seen in this example, such as `credentials` or `zone`, can be provided by other means which we'll cover later.
* The `resource` blocks define the actual components of our infrastructure. In this example we have a single resource.
    * `resource` blocks have 2 strings before the block: the resource ***type*** and the resource ***name***.
#### Run Terraform commands
    ```bash
    terraform init
    terraform plan
    terraform apply
    terraform destroy
    ```

_[Back to the top](#table-of-contents)_

>[Back to Index](env_setup.md)

>Next:

>Reference:
 * [Week 1 Introduction](https://itnadigital.notion.site/Week-1-Introduction-f18de7e69eb4453594175d0b1334b2f4)
 * [Note](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/1_intro.md?plain=1)
