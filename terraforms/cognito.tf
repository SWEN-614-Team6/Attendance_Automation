
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


// main.tf 

resource "aws_cognito_user_pool" "userpool" {
  name = "my-userpool"

  schema {
    name = "Email"
    attribute_data_type = "String"
    mutable = true 
    developer_only_attribute = false
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  auto_verified_attributes = ["email"]

  password_policy {
    minimum_length = 6
    require_lowercase = true 
    require_numbers = true 
    require_symbols = true 
    require_uppercase = true 
  }

  username_attributes = ["email"]
  username_configuration {
    case_sensitive = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }
}


resource "aws_cognito_user_pool_client" "userpool_client" {
  name = "my-client"
  user_pool_id = aws_cognito_user_pool.userpool.id
  supported_identity_providers = ["COGNITO"]
  explicit_auth_flows = ["ALLOW_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH","ALLOW_USER_PASSWORD_AUTH"]
  generate_secret = false
  prevent_user_existence_errors = "LEGACY"
  refresh_token_validity = 1 
  access_token_validity = 1 
  id_token_validity = 1 
  token_validity_units {
    access_token = "hours"
    id_token = "hours"
    refresh_token = "hours"
  }
}