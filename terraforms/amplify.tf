data "local_file" "api_invoke_url" {
  filename = "api_invoke_url.txt"

  depends_on = [ null_resource.write_output_to_file ]
}

data "local_file" "aws_export" {
  filename = "aws_export.js"

  depends_on = [ null_resource.generate_amplify_config ]
}


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
                - npm install aws-amplify
          build:
            commands:
                - echo "REACT_APP_API_ENDPOINT= ${data.local_file.api_invoke_url.content}" >> .env.production
                - cp aws-exports.js src/
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
