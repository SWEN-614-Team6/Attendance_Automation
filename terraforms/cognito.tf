resource "aws_cognito_identity_pool" "my_identity_pool" {
  identity_pool_name               = "MyIdentityPool"
  allow_unauthenticated_identities = false  # Set to true if you want to allow unauthenticated access
}

# Create Cognito User Pool
resource "aws_cognito_user_pool" "my_user_pool" {
  name = "my-user-pool"

  # Define user pool policies and attributes
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  username_attributes = ["email"]
}

# Create Cognito User Pool Client
resource "aws_cognito_user_pool_client" "my_user_pool_client" {
  name                   = "my-user-pool-client"
  user_pool_id           = aws_cognito_user_pool.my_user_pool.id
  generate_secret        = true
  refresh_token_validity = 30
  access_token_validity  = 5
  id_token_validity      = 5
}

# Output Cognito User Pool and User Pool Client IDs
output "user_pool_id" {
  value = aws_cognito_user_pool.my_user_pool.id
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.my_user_pool_client.id
}