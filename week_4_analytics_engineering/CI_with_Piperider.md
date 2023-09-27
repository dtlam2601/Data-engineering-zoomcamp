## Continuous Integration

# Why CI with data projects?
  * Automate tasks on a software project
    - Building, Testing, Linting
  * Ensures quality (no more merging buggy code)
  * Data projects are now full 'soft projects'
  * Data projects should take advantage of the automation CI brings

# High-performing data team
  > High-performing data team should try 'increase data quality', and should try to increase the speed and the quality of their work at the same time.
  > [Article](https://medium.com/geekculture/high-performance-data-teams-dont-care-about-data-quality-52baa4141fe8)

  > - increase data quality
  > - increase data uptime
  > - be faster
  > - Ensure data is recent

# Use CI to
  1. Test your incoming data regularly (production env)
  2. Test your changes before deploying (pre-commit checks)
     - A/B deployments: production and PR schema

# GitHub workflows with dbt and bigquery
  - https://docs.github.com/en/actions/using-workflows/about-workflows

# Add environment variables
  - https://medium.com/inthepipeline/how-to-run-dbt-with-bigquery-in-github-actions-97ccb1761f4b
  - https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/dotenv
    - [direnv](https://github.com/direnv/direnv)
    - [zsh-autoenv](https://github.com/Tarrasch/zsh-autoenv)
  - https://www.freecodecamp.org/news/how-to-set-an-environment-variable-in-linux/

## Homework
  - [More details](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2023/workshops/piperider.md)
The following questions follow on from the original Week 4 homework, and so use the same data as required by those questions:

https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2023/week_4_analytics_engineering/homework.md

Yellow taxi data - Years 2019 and 2020
Green taxi data - Years 2019 and 2020
fhv data - Year 2019.

### Question 1:

What is the distribution between vendor id filtering by years 2019 and 2020 data?

You will need to run PipeRider and check the report

* 70.1/29.6/0.5
* 60.1/39.5/0.4
* 90.2/9.5/0.3
* 80.1/19.7/0.2

### Question 2:

What is the composition of total amount (positive/zero/negative) filtering by years 2019 and 2020 data?

You will need to run PipeRider and check the report


* 51.4M/15K/48.6K
* 21.4M/5K/248.6K
* 61.4M/25K/148.6K
* 81.4M/35K/14.6K

### Question 3:

What is the numeric statistics (average/standard deviation/min/max/sum) of trip distances filtering by years 2019 and 2020 data?

You will need to run PipeRider and check the report


* 1.95/35.43/0/16.3K/151.5M
* 3.95/25.43/23.88/267.3K/281.5M
* 5.95/75.43/-63.88/67.3K/81.5M
* 2.95/35.43/-23.88/167.3K/181.5M




## Solution
Video: https://www.youtube.com/watch?v=inNrUys7W8U&list=PL3MmuxUbc_hJjEePXIdE-LVUx_1ZZjYGW

# Links:
  - [Repo](https://github.com/InfuseAI/taxi_rides_ny_duckdb)
  - [InfuseAI blog](https://blog.infuseai.io/)
  - [Discord community](https://discord.com/invite/328QcXnkKD)
  - [Email enquiries](product@piperider.io)
  - [CI article](https://docs.piperider.io/ci/introduction)
  - [Github actions projects](https://github.com/DataTalksClub/project-of-the-week/blob/main/2023-01-11-github_actions-1.md)
  - [Article](https://medium.com/geekculture/high-performance-data-teams-dont-care-about-data-quality-52baa4141fe8)
