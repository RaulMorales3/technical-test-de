# technical test AWS serverless

I was requested to:

> It is required to simulate the consumption of a Rest API through the AWS API Gateway service. Based on the following diagram, build a template in Terraform implementing the following architecture.

> User --> API Gateway --> AWS LAMBDA --> DynamoDB Table

I deloyed each service using the terraform infrastructure that can be found inside this folder this is the api gateway url: <https://oqhfojxjvb.execute-api.us-east-1.amazonaws.com/dev/employees>

I put some items on the table for the test, when requested the api returns: 

````
[
  {
    "Salary": "2500000",
    "Id": "3",
    "Sex": "F",
    "LastName": "PEREZ",
    "Name": "LAURA",
    "BirthDate": "1991-09-10"
  },
  {
    "Salary": "5500000",
    "Id": "2",
    "Sex": "M",
    "LastName": "GARCIA",
    "Name": "ANDRES",
    "BirthDate": "1975-05-22"
  },
  {
    "Salary": "3800000",
    "Id": "4",
    "Sex": "M",
    "LastName": "MARTINEZ",
    "Name": "PEPE",
    "BirthDate": "1987-12-01"
  },
  {
    "Salary": "3500000",
    "Id": "1",
    "Sex": "M",
    "LastName": "PELAEZ",
    "Name": "JUAN",
    "BirthDate": "1985-01-29"
  },
  {
    "Salary": "4500000",
    "Id": "5",
    "Sex": "F",
    "LastName": "CORRALES",
    "Name": "MARGARITA",
    "BirthDate": "1990-07-02"
  }
]
````

Or for a single Item with an id as a path parameter <https://oqhfojxjvb.execute-api.us-east-1.amazonaws.com/dev/employees/1> :

````
[
  {
    "Salary": "3500000",
    "Id": "1",
    "Sex": "M",
    "LastName": "PELAEZ",
    "Name": "JUAN",
    "BirthDate": "1985-01-29"
  }
]
````

Using the aws-cli `test-invoke-method` command:

input:
```
aws apigateway test-invoke-method --rest-api-id oqhfojxjvb --resource-id 74670d --http-method GET
```

output:
```
{
    "status": 200,
    "body": "[{\"Salary\": \"2500000\", \"Id\": \"3\", \"Sex\": \"F\", \"LastName\": \"PEREZ\", \"Name\": \"LAURA\", \"BirthDate\": \"1991-09-10\"}, {\"Salary\": \"5500000\", \"Id\": \"2\", \"Sex\": \"M\", \"LastName\": \"GARCIA\", \"Name\": \"ANDRES\", \"BirthDate\": \"1975-05-22\"}, {\"Salary\": \"3800000\", \"Id\": \"4\", \"Sex\": \"M\", \"LastName\": \"MARTINEZ\", \"Name\": \"PEPE\", \"BirthDate\": \"1987-12-01\"}, {\"Salary\": \"3500000\", \"Id\": \"1\", \"Sex\": \"M\", \"LastName\": \"PELAEZ\", \"Name\": \"JUAN\", \"BirthDate\": \"1985-01-29\"}, {\"Salary\": \"4500000\", \"Id\": \"5\", \"Sex\": \"F\", \"LastName\": \"CORRALES\", \"Name\": \"MARGARITA\", \"BirthDate\": \"1990-07-02\"}]",
    "headers": {
        "X-Amzn-Trace-Id": "Root=1-6667c4be-9f1a8f06e05396ad46af454b;Parent=1b744838f4c84657;Sampled=0;lineage=16d45e5b:0"
    },
    "multiValueHeaders": {
        "X-Amzn-Trace-Id": [
            "Root=1-6667c4be-9f1a8f06e05396ad46af454b;Parent=1b744838f4c84657;Sampled=0;lineage=16d45e5b:0"
        ]
    },
    "log": "Execution log for request 542762a3-b458-4c03-bf58-55f008af79a2\nTue Jun 11 03:30:06 UTC 2024 : Starting execution for request: 542762a3-b458-4c03-bf58-55f008af79a2\nTue Jun 11 03:30:06 UTC 2024 : HTTP Method: GET, Resource Path: /employees\nTue Jun 11 03:30:06 UTC 2024 : Method request path: {}\nTue Jun 11 03:30:06 UTC 2024 : Method request query string: {}\nTue Jun 11 03:30:06 UTC 2024 : Method request headers: {}\nTue Jun 11 03:30:06 UTC 2024 : Method request body before transformations: \nTue Jun 11 03:30:06 UTC 2024 : Endpoint request URI: https://lambda.us-east-1.amazonaws.com/2015-03-31/functions/arn:aws:lambda:us-east-1:640156597816:function:test-de-development-get-employees/invocations\nTue Jun 11 03:30:06 UTC 2024 : Endpoint request headers: {X-Amz-Date=20240611T033006Z, x-amzn-apigateway-api-id=oqhfojxjvb, Accept=application/json, User-Agent=AmazonAPIGateway_oqhfojxjvb, Host=lambda.us-east-1.amazonaws.com, X-Amz-Content-Sha256=5c629718ddefde8291c41d92cc9cc54a7fd9108274853ba390826628b27c96a9, X-Amzn-Trace-Id=Root=1-6667c4be-9f1a8f06e05396ad46af454b, x-amzn-lambda-integration-tag=542762a3-b458-4c03-bf58-55f008af79a2, Authorization=*********************************************************************************************************************************************************************************************************************************************************************************************************************************************d063b3, X-Amz-Source-Arn=arn:aws:execute-api:us-east-1:640156597816:oqhfojxjvb/test-invoke-stage/GET/employees, X-Amz-Security-Token=IQoJb3JpZ2luX2VjELv//////////wEaCXVzLWVhc3QtMSJGMEQCICUuZI2Dn6dZkqKqAg3tUu3Rq+kpKqpXpFScFht/ArOsAiBrcjQHKBEixUgIjxg5+Uq3mrvT485+Ua3NWY12 [TRUNCATED]\nTue Jun 11 03:30:06 UTC 2024 : Endpoint request body after transformations: {\"resource\":\"/employees\",\"path\":\"/employees\",\"httpMethod\":\"GET\",\"headers\":null,\"multiValueHeaders\":null,\"queryStringParameters\":null,\"multiValueQueryStringParameters\":null,\"pathParameters\":null,\"stageVariables\":null,\"requestContext\":{\"resourceId\":\"74670d\",\"resourcePath\":\"/employees\",\"httpMethod\":\"GET\",\"extendedRequestId\":\"ZLut1EfyIAMFkgQ=\",\"requestTime\":\"11/Jun/2024:03:30:06 +0000\",\"path\":\"/employees\",\"accountId\":\"640156597816\",\"protocol\":\"HTTP/1.1\",\"stage\":\"test-invoke-stage\",\"domainPrefix\":\"testPrefix\",\"requestTimeEpoch\":1718076606684,\"requestId\":\"542762a3-b458-4c03-bf58-55f008af79a2\",\"identity\":{\"cognitoIdentityPoolId\":null,\"cognitoIdentityId\":null,\"apiKey\":\"test-invoke-api-key\",\"principalOrgId\":null,\"cognitoAuthenticationType\":null,\"userArn\":\"arn:aws:sts::640156597816:assumed-role/MOAdmins/botocore-session-1718076490\",\"apiKeyId\":\"test-invoke-api-key-id\",\"userAgent\":\"aws-cli/2.15.51 md/awscrt#0.19.19 ua/2.0 os/macos#23.5.0 md/arch#arm64 lang/python#3.11.9 md/pyi [TRUNCATED]\nTue Jun 11 03:30:06 UTC 2024 : Sending request to https://lambda.us-east-1.amazonaws.com/2015-03-31/functions/arn:aws:lambda:us-east-1:640156597816:function:test-de-development-get-employees/invocations\nTue Jun 11 03:30:08 UTC 2024 : Received response. Status: 200, Integration latency: 1702 ms\nTue Jun 11 03:30:08 UTC 2024 : Endpoint response headers: {Date=Tue, 11 Jun 2024 03:30:08 GMT, Content-Type=application/json, Content-Length=717, Connection=keep-alive, x-amzn-RequestId=d585be4a-4ff2-4636-b69a-2fc6f2689fa6, x-amzn-Remapped-Content-Length=0, X-Amz-Executed-Version=$LATEST, X-Amzn-Trace-Id=root=1-6667c4be-9f1a8f06e05396ad46af454b;parent=1b744838f4c84657;sampled=0;lineage=16d45e5b:0}\nTue Jun 11 03:30:08 UTC 2024 : Endpoint response body before transformations: {\"statusCode\": 200, \"body\": \"[{\\\"Salary\\\": \\\"2500000\\\", \\\"Id\\\": \\\"3\\\", \\\"Sex\\\": \\\"F\\\", \\\"LastName\\\": \\\"PEREZ\\\", \\\"Name\\\": \\\"LAURA\\\", \\\"BirthDate\\\": \\\"1991-09-10\\\"}, {\\\"Salary\\\": \\\"5500000\\\", \\\"Id\\\": \\\"2\\\", \\\"Sex\\\": \\\"M\\\", \\\"LastName\\\": \\\"GARCIA\\\", \\\"Name\\\": \\\"ANDRES\\\", \\\"BirthDate\\\": \\\"1975-05-22\\\"}, {\\\"Salary\\\": \\\"3800000\\\", \\\"Id\\\": \\\"4\\\", \\\"Sex\\\": \\\"M\\\", \\\"LastName\\\": \\\"MARTINEZ\\\", \\\"Name\\\": \\\"PEPE\\\", \\\"BirthDate\\\": \\\"1987-12-01\\\"}, {\\\"Salary\\\": \\\"3500000\\\", \\\"Id\\\": \\\"1\\\", \\\"Sex\\\": \\\"M\\\", \\\"LastName\\\": \\\"PELAEZ\\\", \\\"Name\\\": \\\"JUAN\\\", \\\"BirthDate\\\": \\\"1985-01-29\\\"}, {\\\"Salary\\\": \\\"4500000\\\", \\\"Id\\\": \\\"5\\\", \\\"Sex\\\": \\\"F\\\", \\\"LastName\\\": \\\"CORRALES\\\", \\\"Name\\\": \\\"MARGARITA\\\", \\\"BirthDate\\\": \\\"1990-07-02\\\"}]\"}\nTue Jun 11 03:30:08 UTC 2024 : Method response body after transformations: [{\"Salary\": \"2500000\", \"Id\": \"3\", \"Sex\": \"F\", \"LastName\": \"PEREZ\", \"Name\": \"LAURA\", \"BirthDate\": \"1991-09-10\"}, {\"Salary\": \"5500000\", \"Id\": \"2\", \"Sex\": \"M\", \"LastName\": \"GARCIA\", \"Name\": \"ANDRES\", \"BirthDate\": \"1975-05-22\"}, {\"Salary\": \"3800000\", \"Id\": \"4\", \"Sex\": \"M\", \"LastName\": \"MARTINEZ\", \"Name\": \"PEPE\", \"BirthDate\": \"1987-12-01\"}, {\"Salary\": \"3500000\", \"Id\": \"1\", \"Sex\": \"M\", \"LastName\": \"PELAEZ\", \"Name\": \"JUAN\", \"BirthDate\": \"1985-01-29\"}, {\"Salary\": \"4500000\", \"Id\": \"5\", \"Sex\": \"F\", \"LastName\": \"CORRALES\", \"Name\": \"MARGARITA\", \"BirthDate\": \"1990-07-02\"}]\nTue Jun 11 03:30:08 UTC 2024 : Method response headers: {X-Amzn-Trace-Id=Root=1-6667c4be-9f1a8f06e05396ad46af454b;Parent=1b744838f4c84657;Sampled=0;lineage=16d45e5b:0}\nTue Jun 11 03:30:08 UTC 2024 : Successfully completed execution\nTue Jun 11 03:30:08 UTC 2024 : Method completed with status: 200\n",
    "latency": 1708
}

```