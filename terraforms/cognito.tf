
# Create Cognito User Pool
resource "aws_cognito_user_pool" "my_user_pool" {
  name = "my-user-pool"

  schema {
    name = "Email"
    attribute_data_type = "String"
    mutable = true
    developer_only_attribute = false
  }

  # Define user pool policies and attributes
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }
  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  
  }

  auto_verified_attributes = ["email"]
  username_configuration {
    case_sensitive = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  username_attributes = ["email"]
}

# Create Cognito User Pool Client
resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name                   = "my-user-pool-client"
  supported_identity_providers = [ "COGNITO" ]
  user_pool_id           = aws_cognito_user_pool.my_user_pool.id
  //explicit_auth_flows = [ "ALLOW_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD" ]
  generate_secret        = false
  prevent_user_existence_errors = "LEGACY"
  refresh_token_validity = 1
  access_token_validity  = 1
  id_token_validity      = 1
  token_validity_units {
    access_token = "hours"
    id_token = "hours"
    refresh_token = "hours"
  }
}

resource "aws_cognito_identity_pool" "my_identity_pool" {
  identity_pool_name = "my-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.my_user_pool_client.id
    provider_name           = aws_cognito_user_pool.my_user_pool.endpoint
    server_side_token_check = false
  }
}

# Output Cognito User Pool and User Pool Client IDs
# output "user_pool_id" {
#   value = aws_cognito_user_pool.my_user_pool.id
# }

# output "user_pool_client_id" {
#   value = aws_cognito_user_pool_client.my_user_pool_client.id
# }

output "cognito_parameters" {
  value = {
    aws_cognito_identity_pool_id = aws_cognito_identity_pool.my_identity_pool.id
    aws_user_pools_id            = aws_cognito_user_pool.my_user_pool.id
    aws_user_pools_web_client_id = aws_cognito_user_pool_client.my_user_pool_client.id
  }
}


resource "null_resource" "write_aws_cognito_identity_pool_id" {
  provisioner "local-exec" {
    command = "echo '${aws_cognito_identity_pool.my_identity_pool.id}' | tr -d '\n' > aws_cognito_identity_pool_id.txt"
  }
}

resource "null_resource" "write_aws_user_pools_id" {
  provisioner "local-exec" {
    command = "echo '${aws_cognito_user_pool.my_user_pool.id}' | tr -d '\n' > aws_user_pools_id.txt"
  }
}

resource "null_resource" "write_aws_user_pools_web_client_id" {
  provisioner "local-exec" {
    command = "echo '${aws_cognito_user_pool_client.my_user_pool_client.id}' | tr -d '\n' > aws_user_pools_web_client_id.txt"
  }
}


# # Create Cognito User Pool
# resource "aws_cognito_user_pool" "my_user_pool" {
#   name = "my-user-pool"

#   # Define user pool policies and attributes
#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = true
#     require_uppercase = true
#   }

#   username_attributes = ["email"]
# }

# # Create Cognito User Pool Client
# resource "aws_cognito_user_pool_client" "my_user_pool_client" {
#   name                   = "my-user-pool-client"
#   user_pool_id           = aws_cognito_user_pool.my_user_pool.id
#   generate_secret        = true
#   refresh_token_validity = 30
#   access_token_validity  = 5
#   id_token_validity      = 5
# }

# # Output Cognito User Pool and User Pool Client IDs
# output "user_pool_id" {
#   value = aws_cognito_user_pool.my_user_pool.id
# }

# output "user_pool_client_id" {
#   value = aws_cognito_user_pool_client.my_user_pool_client.id
# }
