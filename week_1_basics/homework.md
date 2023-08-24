## Part docker-sql
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
SELECT count(*) from green_taxi_trips where TO_CHAR(lpep_pickup_datetime, 'MM-DD')='01-15' and 
TO_CHAR(lpep_dropoff_datetime, 'MM-DD')='01-15' limit 10;
```
  * How many taxi trips were totally made on January 15? 20530

### Question 4. Largest trip for each day
### Question 5. The number of passengers
### Question 6. Largest tip


