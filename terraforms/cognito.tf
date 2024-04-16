
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

# Output Cognito User Pool and User Pool Client IDs
output "user_pool_id" {
  value = aws_cognito_user_pool.my_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.my_user_pool_client.id
}
