resource "aws_api_gateway_rest_api" "ams_apis_tf" {
  name        = "ams_apis_tf"
  description = "API Gateway for AMS"
   binary_media_types = [
    "image/jpeg",
    "image/png"
  ]
    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# # Create resources and methods
resource "aws_api_gateway_resource" "bucket_resource" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  parent_id   = aws_api_gateway_rest_api.ams_apis_tf.root_resource_id
  path_part   = "{bucket}"
}

resource "aws_api_gateway_resource" "filename_resource" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  parent_id   = aws_api_gateway_resource.bucket_resource.id
  path_part   = "{filename}"
}

resource "aws_api_gateway_method" "put_method" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.filename_resource.id
  http_method = "PUT"
  authorization = "NONE" 

   request_parameters = {
    "method.request.path.bucket" = true
    "method.request.path.filename" = true
  }
}

# Integration with S3
resource "aws_api_gateway_integration" "s3_integration" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.filename_resource.id
  http_method = aws_api_gateway_method.put_method.http_method
  integration_http_method = "PUT"
  type = "AWS"
  uri = "arn:aws:apigateway:us-east-1:s3:path/{bucket}/{filename}"
  

   request_parameters = {
    "integration.request.path.bucket"   = "method.request.path.bucket"
    "integration.request.path.filename" = "method.request.path.filename"
  }
#    request_templates = {
#     "application/json" = jsonencode({
#       bucket   = "$input.params('bucket')"
#       filename = "$input.params('filename')"
#     })
#   }
  credentials = aws_iam_role.role_for_api_gateway_registration.arn
}

# Method Response
resource "aws_api_gateway_method_response" "api_gateway_1_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.filename_resource.id
  http_method = aws_api_gateway_method.put_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
   response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  
}


# Options Method for {bucket}
resource "aws_api_gateway_method" "options_bucket_method" {
  rest_api_id   = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id   = aws_api_gateway_resource.bucket_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE" 
}

# Integration for Options Method for {bucket}
resource "aws_api_gateway_integration" "options_bucket_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id             = aws_api_gateway_resource.bucket_resource.id
  http_method             = aws_api_gateway_method.options_bucket_method.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method Response for Options Method for {bucket}
resource "aws_api_gateway_method_response" "options_bucket_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.bucket_resource.id
  http_method = aws_api_gateway_method.options_bucket_method.http_method
  status_code = "200"

    response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Integration Response for Options Method for {bucket}
resource "aws_api_gateway_integration_response" "options_bucket_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.bucket_resource.id
  http_method = aws_api_gateway_method.options_bucket_method.http_method
  status_code = aws_api_gateway_method_response.options_bucket_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}



# Integration Response
resource "aws_api_gateway_integration_response" "response_200_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.filename_resource.id
  http_method = aws_api_gateway_method.put_method.http_method
#   status_code = "200"
  status_code = aws_api_gateway_method_response.api_gateway_1_method_response.status_code

    response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
   response_templates = {
    "application/json" = ""
  }
}


# For filename Options :

resource "aws_api_gateway_method" "options_filename_method" {
  rest_api_id   = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id   = aws_api_gateway_resource.filename_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE" 
}

# Integration for Options Method for {filename}
resource "aws_api_gateway_integration" "options_filename_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id             = aws_api_gateway_resource.filename_resource.id
  http_method             = aws_api_gateway_method.options_filename_method.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"

   request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method Response for Options Method for {filename}
resource "aws_api_gateway_method_response" "options_filename_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.filename_resource.id
  http_method = aws_api_gateway_method.options_filename_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Integration Response for Options Method for {filename}
resource "aws_api_gateway_integration_response" "options_filename_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.filename_resource.id
  http_method = aws_api_gateway_method.options_filename_method.http_method
  status_code = aws_api_gateway_method_response.options_filename_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}


#-------------------Second API /class/{bucket}/{filename}--------


resource "aws_api_gateway_resource" "api2_class_resource" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  parent_id   = aws_api_gateway_rest_api.ams_apis_tf.root_resource_id
  path_part   = "class"
}

resource "aws_api_gateway_resource" "ap2_bucket_resource" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  parent_id   = aws_api_gateway_resource.api2_class_resource.id
  path_part   = "{bucket}"
}

resource "aws_api_gateway_resource" "ap2_filename_resource" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  parent_id   = aws_api_gateway_resource.ap2_bucket_resource.id
  path_part   = "{filename}"
}

resource "aws_api_gateway_method" "api2_put_method" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_filename_resource.id
  http_method = "PUT"
  authorization = "NONE" 

   request_parameters = {
    "method.request.path.bucket" = true
    "method.request.path.filename" = true
  }
}

# Integration with S3
resource "aws_api_gateway_integration" "api2_s3_integration" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_filename_resource.id
  http_method = aws_api_gateway_method.api2_put_method.http_method
  integration_http_method = "PUT"
  type = "AWS"
  uri = "arn:aws:apigateway:us-east-1:s3:path/{bucket}/{filename}"
  

   request_parameters = {
    "integration.request.path.bucket"   = "method.request.path.bucket"
    "integration.request.path.filename" = "method.request.path.filename"
  }

   credentials = aws_iam_role.role_for_api_gateway_authentication.arn
}

# Method Response
resource "aws_api_gateway_method_response" "api_gateway_2_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_filename_resource.id
  http_method = aws_api_gateway_method.api2_put_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
   response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
  
}

# Options Method for /class
resource "aws_api_gateway_method" "api2_options_class_method" {
  rest_api_id   = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id   = aws_api_gateway_resource.api2_class_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE" 
}

# Integration for Options Method for /class
resource "aws_api_gateway_integration" "api2_options_class_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id             = aws_api_gateway_resource.api2_class_resource.id
  http_method             = aws_api_gateway_method.api2_options_class_method.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method Response for Options Method for /class
resource "aws_api_gateway_method_response" "api2_options_class_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.api2_class_resource.id
  http_method = aws_api_gateway_method.api2_options_class_method.http_method
  status_code = "200"

    response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Integration Response for Options Method for {bucket}
resource "aws_api_gateway_integration_response" "api2_options_class_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.api2_class_resource.id
  http_method = aws_api_gateway_method.api2_options_class_method.http_method
  status_code = aws_api_gateway_method_response.api2_options_class_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}



# Options Method for {bucket}
resource "aws_api_gateway_method" "api2_options_bucket_method" {
  rest_api_id   = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id   = aws_api_gateway_resource.ap2_bucket_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE" 
}

# Integration for Options Method for {bucket}
resource "aws_api_gateway_integration" "api2_options_bucket_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id             = aws_api_gateway_resource.ap2_bucket_resource.id
  http_method             = aws_api_gateway_method.api2_options_bucket_method.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method Response for Options Method for {bucket}
resource "aws_api_gateway_method_response" "api2_options_bucket_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_bucket_resource.id
  http_method = aws_api_gateway_method.api2_options_bucket_method.http_method
  status_code = "200"

    response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# Integration Response for Options Method for {bucket}
resource "aws_api_gateway_integration_response" "api2_options_bucket_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_bucket_resource.id  
  http_method = aws_api_gateway_method.api2_options_bucket_method.http_method
  status_code = aws_api_gateway_method_response.api2_options_bucket_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

#for filename
# Integration Response
resource "aws_api_gateway_integration_response" "api2_response_200_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_filename_resource.id
  http_method = aws_api_gateway_method.api2_put_method.http_method
#   status_code = "200"
  status_code = aws_api_gateway_method_response.api_gateway_2_method_response.status_code

    response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
   response_templates = {
    "application/json" = ""
  }
}

# For filename Options :

resource "aws_api_gateway_method" "api2_options_filename_method" {
  rest_api_id   = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id   = aws_api_gateway_resource.ap2_filename_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE" 
}

# Integration for Options Method for {filename}
resource "aws_api_gateway_integration" "api2_options_filename_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id             = aws_api_gateway_resource.ap2_filename_resource.id
  http_method             = aws_api_gateway_method.api2_options_filename_method.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"

   request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Method Response for Options Method for {filename}
resource "aws_api_gateway_method_response" "api2_options_filename_method_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_filename_resource.id
  http_method = aws_api_gateway_method.api2_options_filename_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}


# Integration Response for Options Method for {filename}
resource "aws_api_gateway_integration_response" "api2_options_filename_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ams_apis_tf.id
  resource_id = aws_api_gateway_resource.ap2_filename_resource.id
  http_method = aws_api_gateway_method.api2_options_filename_method.http_method
  status_code = aws_api_gateway_method_response.api2_options_filename_method_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,PUT'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}
