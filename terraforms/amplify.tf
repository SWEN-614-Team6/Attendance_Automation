resource "aws_amplify_app" "my_app" {
  name       = "Attendance_Automation"
  repository = "https://github.com/SWEN-614-Team6/Attendance_Automation"
  access_token = var.token
  environment_variables = {
    variable_name = "REACT_APP_API_URL"
    value         = aws_api_gateway_deployment.deployment.invoke_url
  }
  # Configure the branch that Amplify will use
  build_spec = <<-EOT
      version: 1
      frontend:
        phases:
          preBuild:
            commands:
                - cd homepage
                - npm install
          build:
            commands:
                - npm run build
                - ls
        artifacts:
            baseDirectory: homepage/build   
            files:
            - '**/*'
        cache:
          paths: 
            - node_modules/**/*
    EOT

  
 
}
resource "aws_amplify_branch" "amplify_branch" {
  app_id      = aws_amplify_app.my_app.id
  branch_name = "dev"
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
