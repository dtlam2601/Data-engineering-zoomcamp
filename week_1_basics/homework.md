>[Back to Index](env_setup.md)

>Next: [Data Ingestion](2_data_ingestion.md)

### Table of contents
* [The Data School](#the-data-school)
* [Part docker-sql](#part-docker-sql)
  * [Question 1. Knowing docker tags][#Question-1.-Knowing-docker-tags]
  * [Question 2. Understanding docker first run]
  * [Prepare Postgres]
  * [Question 3. Count records]
  * [Question 4. Largest trip for each day]
  * [Question 5. The number of passengers]
  * [Question 6. Largest tip]
* [Part B: Terraform]()

## The Data School
https://dataschool.com/how-to-teach-people-sql/sql-join-types-explained-visually/
https://www.wikiwand.com/en/Join_(SQL)

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



