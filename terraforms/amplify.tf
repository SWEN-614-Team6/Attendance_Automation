data "local_file" "api_invoke_url" {
  filename = "api_invoke_url.txt"

  depends_on = [ null_resource.write_output_to_file ]
}

# data "local_file" "aws_exports" {
#   filename = "aws-exports.js"

#   depends_on = [ null_resource.generate_amplify_config ]
# }


resource "aws_amplify_app" "my_app" {
  name       = "Attendance_Automation"
  repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
  access_token = var.token

  # Configure the branch that Amplify will use
  build_spec = <<-EOT
  version: 1
  frontend:
    phases:
      preBuild:
        commands:
          - cd homepage
          - npm install
          - npm install -g aws-amplify @aws-amplify/ui-react
      build:
        commands:
          - echo "REACT_APP_API_ENDPOINT=${data.local_file.api_invoke_url.content}" >> .env.production
          - echo "REACT_APP_AWS_REGION=${var.aws_region}" >> .env.production
          - echo "REACT_APP_IDENTITY_POOL_ID=${aws_cognito_identity_pool.my_identity_pool.id}" >> .env.production
          - echo "REACT_APP_USER_POOLS_ID=${aws_cognito_user_pool.my_user_pool.id}" >> .env.production
          - echo "REACT_APP_USER_POOLS_CLIENT_ID=${aws_cognito_user_pool_client.my_user_pool_client.id}" >> .env.production
          - npm run build
    artifacts:
      baseDirectory: homepage/build   
      files:
        - '**/*'
    cache:
      paths: 
        - node_modules/**/*
EOT
 
  depends_on = [ data.local_file.api_invoke_url ]  
}

resource "aws_amplify_branch" "amplify_branch" {
  app_id      = aws_amplify_app.my_app.id
  branch_name = "acdev"
}

# resource "aws_amplify_domain_association" "domain_association" {
#   app_id      = aws_amplify_app.my_app.id
#   domain_name = "awsamplifyapp.com"
#   wait_for_verification = false

#   sub_domain {
#     branch_name = aws_amplify_branch.amplify_branch.branch_name
#     prefix      = "dev"
#   }
# }
