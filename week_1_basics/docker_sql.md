## Why should we care about docker?
- Local experiments
- Integration tests (CI/CD)
- Reproducibility
- Running pipelines on the cloud (AWS Batch, Kubernetes jobs)
- Spark
- Serverless (AWS Lambda, Google functions)
- search: github actions docker

## Introduction to Docker
* Run by command line:
* Run by Dockerfile:
  * Dockerfile
    ```Dockerfile
    FROM python:3.9
  
    RUN pip install pandas
  
    WORKDIR /app
    COPY pipeline.py pipeline.py
  
    ENTRYPOINT [ "python", "pipeline.py" ]
    ```
  * Build the image: ```docker build -t test:pandas .```
  * Data Pipeline
    ```Python
    import sys
    import pandas as pd
    
    print(sys.argv)
    day = sys.argv[1]
    
    # some fancy stuff with pandas
    print(f'Hello World for day : {day}')
    ```
* Run container:
  ```docker run -it test:pandas 2023-08-16```

## PGCLI for Postgres
* Install pgcli: 
  * pip install pgcli
* Build and Run container Postgres:
  ```
  docker run -it  `
  -e POSTGRES_USER="root" `
  -e POSTGRES_PASSWORD="root" `
  -e POSTGRES_DB="ny_taxi"    `
  -v $pwd/ny_taxi_postgres_data:/var/lib/postgresql/data `
  -p 5432:5432    `
  postgres:13
  ```
* Connecting to Postgres:
  ```pgcli -h localhost -p 5432 -u root -d ny_taxi```

## Data Pipeline
* Description:
  * Python 3.9
  * Pandas
  * Postgres connection library: sqlalchemy

* Exploring data
  * yellow_tripdata_2021-01.csv
  * taxi+_zone_lookup.csv

* Creating connection
  ```Python
  from sqlalchemy import create_engine
  engine = create_engine('postgres+psycopg2://root:root@localhost:5432/ny_taxi')
  engine.connect()

  # get schema (ddl) and into prosgres database for table named yellow_taxi_data
  print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))
  ```

* Read csv file:
  ```Python
  df_iter = pd.read_csv('yellow_tripdata_2021-01.csv', iterator=True, chunksize=100000)
  while True:
    df = next(df_iter)
  
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
  
    df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')
  ```

## Connecting pgAdmin and Postgres
* Install pgAdmin
  * ```docker pull dpage/pgadmin4```

* Create docker network: ```docker network create pg-network```

* Build and run container Postgres and pgAdmin on the same network 'pg-network'
  * Postgres
  ```
  docker run -it  `
  -e POSTGRES_USER="root" `
  -e POSTGRES_PASSWORD="root" `
  -e POSTGRES_DB="ny_taxi"    `
  -v $pwd/ny_taxi_postgres_data:/var/lib/postgresql/data `
  -p 5432:5432  `
  --network=pg-network    `
  --name pg-database `
  postgres:13
  ```

  * pgAdmin
  ```
  docker run -it  `
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" `
  -e PGADMIN_DEFAULT_PASSWORD="root" `
  -p 8080:80 `
  --network=pg-network    `
  --name pgadmin  `
  dpage/pgadmin4
  ```

* Data pipeline: ingest_data.py
  * Using argparse for pass arguments
  * Coding
    ```Python
    #!/usr/bin/env python
    # coding: utf-8
    
    
    import os
    from sqlalchemy import create_engine
    from time import time
    import pandas as pd
    import argparse
    
    def main(params):
        user = params.user
        password = params.password
        host = params.host
        port = params.port
        db = params.db
        table_name = params.table_name
        url = params.url
        csv_name = 'output.csv'
    
        # download the csv
        os.system(f"wget {url} -O {csv_name}")
        #os.system(f"tar -xf {yellow_tripdata_*.csv.gz} -O {csv_name}")
    
        engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
        
        engine.connect()
    
        df = pd.read_csv(csv_name, nrows=100)
        df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
        df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    
        # create table name 'yellow_taxi_data' with ddl into postgres database
        #df.head(n=0).to_sql(name=table_name, con=engine, if_exists='replace')
        
        # read file into smaller batches (chunks)
        df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000)
    
        # get schema (ddl) and into prosgres database for table named yellow_taxi_data
        #print(pd.io.sql.get_schema(df, name=table_name, con=engine))
    
        while True:
            t_start = time()
            df = next(df_iter)
    
            df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
            df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
            
            df.to_sql(name=table_name, con=engine, if_exists='append')
            t_end = time()
    
            print('inserted another chunk, took %0.3f seconds' % (t_end - t_start))
    
    
    
    if __name__ == '__main__':
    
        parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')
    
        parser.add_argument('--user', help='user name for postgres')
        parser.add_argument('--password', help='password for postgres')
        parser.add_argument('--host', help='host for postgres')
        parser.add_argument('--port', help='port for postgres')
        parser.add_argument('--db', help='database name for postgres')
        parser.add_argument('--table_name', help='name of the table where we will write the results to')
        parser.add_argument('--url', help='url of the csv file')
    
        args = parser.parse_args()
    
        main(args)
    ```

  * Dockerfile: build image taxi_ingest for ingest_data.py
    ```
    FROM python:3.9.1
    
    RUN apt-get install wget
    RUN pip install pandas sqlalchemy psycopg2
    
    WORKDIR /app
    COPY ingest_data.py ingest_data.py
    
    ENTRYPOINT [ "python", "ingest_data.py" ]
    ```

  * Build and run Container ingest_data.py with Dockerfile on network=pg-network and host name connect to Postgres db=pg-database
    ```
    docker build -t taxt_ingest:v001 .

    $URL='http://192.168.1.108:8000/yellow_tripdata_2021-01.csv'
    docker run -it  `
        --network=pg-network    `
        taxt_ingest:v001 `
        --user=root `
        --password=root `
        --host=pg-database `
        --port=5432 `
        --db=ny_taxi `
        --table_name=yellow_taxi_trips  `
        --url=$URL
    ```
* Docker-compose for Postgres and pgAdmin: docker-compose.yml\
  ```
  services:
    pg-database:
        image: postgres:13
        ports: 
            - "5432:5432"
        volumes: 
            - "./data/ny_taxi_postgres_data:/var/lib/postgresql/data"
        environment: 
            POSTGRES_USER=root
            POSTGRES_PASSWORD=root
            POSTGRES_DB=ny_taxi
        networks:
            - pg-network

    pgadmin:
        image: dpage/pgadmin4
        ports:
            - "8080:80"
        environment: 
            PGADMIN_DEFAULT_EMAIL=admin@admin.com
            PGADMIN_DEFAULT_PASSWORD=root
        networks:
            - pg-network
    networks:
      pg-network:
          external: true
  ```

* SQL Refesher
  * Adding the Zones table
    ```upload-data.ipython
    !wget https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv
    df_zones = pd.read_csv('taxi+_zone_lookup.csv')
    df_zones.to_sql(name='zones', con=engine, if_exists='replace')
    ```
    
  * Inner joins
    ```SQL
    SELECT
     	tpep_pickup_datetime,
     	tpep_dropoff_datetime,
     	total_amount,
     	CONCAT(zpu."Borough" , ' / ', zpu."Zone") AS "pickup_loc",
     	CONCAT(zdo."Borough" , ' / ', zdo."Zone") AS "dropoff_loc"
     FROM 
     	yellow_taxi_trips t JOIN zones zpu
     		ON t."PULocationID" = zpu."LocationID"
     	JOIN zones zdo
     		ON t."DOLocationID" = zdo."LocationID"
     LIMIT 100;
     ```

  * Basic data quality checks (Check LocationID is not in the Zones table)
    ```SQL
    SELECT
     tpep_pickup_datetime,
     tpep_dropoff_datetime,
     total_amount,
     "PULocationID",
     "DOLocationID"
    FROM 
     yellow_taxi_trips t
    WHERE
     "PULocationID" NOT IN (SELECT "LocationID" FROM zones)
    LIMIT 100;
    ```

  * Left, Right and Outer joins
    ```SQL
    SELECT
    	tpep_pickup_datetime,
    	tpep_dropoff_datetime,
    	total_amount,
    	CONCAT(zpu."Borough" , ' / ', zpu."Zone") AS "pickup_loc",
    	CONCAT(zdo."Borough" , ' / ', zdo."Zone") AS "dropoff_loc"
    FROM 
    	yellow_taxi_trips t LEFT JOIN zones zpu
    		ON t."PULocationID" = zpu."LocationID"
    	LEFT JOIN zones zdo
    		ON t."DOLocationID" = zdo."LocationID"
    LIMIT 100;
    ```

    ```FROM DATE_TRUNC('DAY', tpep_pickup_datetime),```
  * Group by (Calculate number of trips per day)
    ```SQL
    SELECT
    	CAST(tpep_pickup_datetime AS DATE) as "day",
    	COUNT(1)
    FROM 
    	yellow_taxi_trips t
    GROUP BY
    	CAST(tpep_pickup_datetime AS DATE);
    ```
  * Order by
    ```SQL
    SELECT
    	CAST(tpep_dropoff_datetime AS DATE) as "day",
    	COUNT(1)
    FROM 
    	yellow_taxi_trips t
    GROUP BY
    	CAST(tpep_dropoff_datetime AS DATE)
    ORDER BY "day" ASC;
    ```

    ```SQL
    SELECT
    	CAST(tpep_dropoff_datetime AS DATE) as "day",
    	"DOLocationID",
    	COUNT(1) AS "count",
    	MAX(total_amount),
    	MAX(passenger_count)
    FROM 
    	yellow_taxi_trips t
    GROUP BY
    	1, 2
    ORDER BY 
    	"day" ASC, 
    	"DOLocationID" ASC;
    ```
---
[Github](https://www.github.com)
# Convert .ipynb to .py
```
pip install nbconvert
jupyter nbconvert --to script upload-data.ipynb

#### connect current local directory can access with address localhost:8000
python -m http.server

