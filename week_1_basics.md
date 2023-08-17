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


---
[Github](https://www.github.com)
``` Python
def func():
  pass
```
