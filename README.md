# Test Google Cloud SQL: Django app

[Deployment of a Django app on GKE](https://cloud.google.com/python/django/kubernetes-engine)

## Setup GCP

* Create a project
* Activate a billing account
* Enable the following APIs:

  - Compute Engine
  - Cloud SQL
  - Cloud SQL Admin

* Install gcloud

* Link your new project to gcloud

  ```
  # Creating custom config
  $ gcloud config configurations create testing-cloudsql

  # List configurations
  $ gcloud config configurations list

  # Setup the active configuration
  $ gcloud init

  # Check your current config project
  $ gcloud config get project
  Your active configuration is: [testing-cloudsql]
  testing-cloudsql-416715
  ```

## Set a Cloud SQL for PostgreSQL instance

* Create an instance:  
  Go to [Cloud SQL instances](https://console.cloud.google.com/sql/instances) > Create instance > PostgreSQL (will take about 10 minutes to create it)

  ```
  django-postgres
  ```

* Copy the connectionName

  ```
  testing-cloudsql-416715:europe-west1:django-postgres
  ```

  Or you can retrieve it from the command line:

  ```
  gcloud sql instances describe  testing-django-postgres --format "value(connectionName)"
  ```

* Create a database:  
  Databases > Create database

  ```
  django
  ```

* Create a database user:  
  Users > Add user account

  ```
  django-user
  ```

* Create a service account:  
  [IAM > Service account](https://console.cloud.google.com/iam-admin/serviceaccounts/) > create service account

  ID: cloud-sql
  Roles:
  - Cloud SQL > Cloud SQL Client
  - Cloud SQL > Cloud SQL Editor
  - Cloud SQL > Cloud SQL Admin

  ```
  cloud-sql@testing-cloudsql-416715.iam.gserviceaccount.com
  ```

  Keys > Add key > Create new key > JSON

* Go to [Monitoring > Metrics explorer](https://console.cloud.google.com/monitoring/metrics-explorer):  
  Metric: Cloud SQL Database - Number of rows processed

## Launch locally

* Update the path of the key used by the db containers in docker-compose.yaml

* Create the .env file  
  (set DEBUG to true to serve staticfiles)

  ```
  GOOGLE_CLOUD_PROJECT=testing-django-416622
  DATABASE_CONNECTION_NAME=testing-cloudsql-416715:europe-west1:django-postgres
  DATABASE_NAME=django
  DATABASE_USERNAME=django-user
  DATABASE_PASSWORD=django-user!
  SECRET_KEY=django-insecure-0aq^n@*#u-!)hs+fqlc+58lops38tct5!s1%9%(5pr1&0++31*
  DEBUG=True
  ```

* Launch

  ```
  docker-compose up
  ```

* Go to localhost:8000

## Utils

* Go inside the container

  ``` bash
  docker exec -it gcp-cloudsql-django-api-1 bash
  ```

* Create the migrations

  ``` bash
  python manage.py makemigrations
  python manage.py makemigrations polls
  ```

* Launch the migrations

  ``` bash
  python manage.py migrate
  ```

* Gather all the static content locally into one folder

  ``` bash
  python manage.py collectstatic
  ```

  Check you have access to it:  
  http://localhost:8000/static/admin/css/base.css

* Create a super admin

  ``` bash
  python manage.py createsuperuser
  ```

  Check you can log in:  
  http://localhost:8000/admin

