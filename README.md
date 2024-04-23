# Attendance_Automation

## Facial Recognition-based Attendance Automation System

The Facial Recognition-based Attendance Automation System is designed to streamline the process of taking attendance in classrooms or other educational settings using facial recognition technology. This system automates the traditional manual attendance process by capturing images of the classroom, detecting and recognizing faces, and marking students as present or absent based on comparison with a predefined dataset of enrolled students.

## Steps to run the project

1. Clone the git repository
   `git clone https://github.com/SWEN-614-Team6/Attendance_Automation.git`

2. To run the terraform script navigate to 'terraforms' directory

- type `cd terraforms`
- Run `terraform init` to initialize Terraform.
- Run `terraform plan` to see the execution plan.
- Run `terraform apply` to apply the changes and provision the infrastructure.

3. To run the frontend url navigate to 'homepage' directory.

- Open AWS Amplify
- Run Build & wait for the build and deploy
- Once it is deployed, Using the link navigate to the website
- Signup / Login
- Once logged in Admin can add students and mark attendace of the students just by uploading images

# Running on the local host

- To run the frontend url navigate to 'homepage' directory.
- w.r.t root directory type `cd homepage`
- Run `npm install` to install dependencies
- Run `npm start` to start the development server

4. Once the UI is loaded you can perform following functionalities :

- Add new student by mentioning firstname, lastname and uploading an image.
- Update Attendance by uploading class image and date of attendance.

5. To tear down or destroy infrastructure navigate to 'terraforms' directory and

- Run `terraform destroy`
