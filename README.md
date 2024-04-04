# Test Google Cloud SQL: Django app

[Deployment of a Django app on GKE](https://cloud.google.com/python/django/kubernetes-engine)

## Setup GCP

* Create a project
* Activate a billing account
* Enable the following APIs:

  - Compute Engine
  - Cloud SQL
  - Cloud SQL Admin
  - Identity and Access Management (IAM) — for service accounts
  - Cloud Resource Manager — for IAM member roles

## Create a Cloud SQL instance (PostgreSQL)

### Manually

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

### Using terraform

* Create the infra

  ``` bash
  cd infra
  terraform init
  terraform apply
  ```

* Retrieve the environment variables and credentials

  ``` bash
  terraform output postgres_connection_name
  terraform output postgres_database_name
  terraform output postgres_database_user
  terraform output postgres_database_password

  terraform output -raw postgres_connection_json_key | base64 -d > ../creds.json
  ```

---

## Launch

* Update if necessary the path of the JSON key used by the db containers in docker-compose.yaml

* Create the .env file  
  (set DEBUG to true to serve staticfiles)

  ```
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

* Create a super admin

  ``` bash
  python manage.py createsuperuser
  ```

  Check you can now log in:  
  http://localhost:8000/admin

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
