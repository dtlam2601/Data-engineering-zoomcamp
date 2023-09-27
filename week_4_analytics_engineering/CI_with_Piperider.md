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

# Links:
  - [Repo](https://github.com/InfuseAI/taxi_rides_ny_duckdb)
  - [InfuseAI blog](https://blog.infuseai.io/)
  - [Discord community](https://discord.com/invite/328QcXnkKD)
  - [Email enquiries](product@piperider.io)
  - [CI article](https://docs.piperider.io/ci/introduction)
  - [Github actions projects](https://github.com/DataTalksClub/project-of-the-week/blob/main/2023-01-11-github_actions-1.md)
  - [Article](https://medium.com/geekculture/high-performance-data-teams-dont-care-about-data-quality-52baa4141fe8)
