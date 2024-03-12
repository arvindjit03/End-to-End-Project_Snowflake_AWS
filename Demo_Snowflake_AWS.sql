--Creating Demo database in Snowflake--

CREATE DATABASE DEMO;
CREATE SCHEMA PROJECT_DEMO_12032024;

--Creating integration to access aws_s3 bucket

CREATE OR REPLACE STORAGE INTEGRATION aws_s3_integration
type= external_stage
storage_provider='S3'
enabled=true
storage_aws_role_arn='Can be find in AWS Roles'
storage_allowed_locations=('s3://project-demo-12032024/');

SHOW INTEGRATIONS

DESC INTEGRATION aws_s3_integration

GRANT usage on INTEGRATION aws_s3_integration to role accountadmin;

create or replace file format project_demo_format
type= 'CSV'
field_delimiter=','
skip_header=1;

Create or Replace stage demo_aws_stage
storage_integration = aws_s3_integration
file_format = project_demo_format
url = 's3://project-demo-12032024/'

List @demo_aws_stage/customers.csv;
--remove @demo_aws_stage/customers.csv;


--creating temporary table for the current session

create or replace temporary table demo_customers(

 customer_id integer,
 first_name string,
 last_name string,
 phone string,
 email string,
 street string,
 city string,
 state string,
 zip_code string
);

SELECT * from demo_customers limit 10; 


--copying the data to this temporary table

COPY INTO demo_customers
from @demo_aws_stage/customers.csv
file_format=(format_name=project_demo_format);