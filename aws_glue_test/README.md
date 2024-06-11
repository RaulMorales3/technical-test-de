# AWS Glue Test

I was requested to:

> Build a solution within AWS services that allows for the uploading of a flat file with a predefined structure to a specific path in an S3 bucket. From an event, populate a DynamoDB table with this information using a Glue job within the same infrastructure.

The terraform code deploy the following resources:

- aws S3 bucket.
- dynamoDB table.
- glue job which is script is in a bucket.
- AWS Lambda triggered by a S3 object creation
- policies for each resource in the data.tf file allowing resources to interact with each other.

I implemented another folder with terraform modules since the test requires implement more resources on other items 