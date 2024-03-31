resource "aws_dynamodb_table" "student_table" {
  name           = "class_student_tf"
  billing_mode   = "PAY_PER_REQUEST" // You can also use "PROVISIONED" if you want to specify provisioned capacity
  hash_key       = "rekognitionId" // The primary key attribute
  
 // The data type of the primary key attribute
  // range_key      = "range_key" // Uncomment if you want to specify a range key
  // range_key_type = "NUMBER" // Uncomment and specify the data type if using a range key

  attribute {
    name = "rekognitionId"
    type = "S" // String type for the primary key attribute
  }
}
