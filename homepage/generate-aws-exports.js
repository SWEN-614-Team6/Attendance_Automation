const fs = require('fs');

// Load environment variables from .env.production
require('dotenv').config({ path: '.env.production' });

const awsExports = {
    "aws_project_region": "us-east-1",
   
    // "aws_cognito_identity_pool_id": "us-east-1:34872535-0ab2-49f6-8938-7e29732adc08",
    "aws_cognito_identity_pool_id": process.env.REACT_aws_cognito_identity_pool_id,
    "aws_cognito_region": "us-east-1",
    // "aws_user_pools_id": "us-east-1_rhTV292X4",
    "aws_user_pools_id": process.env.REACT_aws_user_pools_id,
   
    // "aws_user_pools_web_client_id": "5rm5najpcjj97i9pcn9ns5vgf6",
    "aws_user_pools_web_client_id": process.env.REACT_aws_user_pools_web_client_id,
   
    "oauth": {},
    "aws_cognito_username_attributes": [
        "EMAIL"
    ],
    "aws_cognito_social_providers": [],
    "aws_cognito_signup_attributes": [
        "EMAIL"
    ],
    "aws_cognito_mfa_configuration": "OFF",
    "aws_cognito_mfa_types": [
        "SMS"
    ],
    "aws_cognito_password_protection_settings": {
        "passwordPolicyMinLength": 8,
        "passwordPolicyCharacters": []
    },
    "aws_cognito_verification_mechanisms": [
        "EMAIL"
    ]
};

// Write aws-exports.js
fs.writeFileSync('src/aws-exports.js', `const awsmobile = ${JSON.stringify(awsExports, null, 2)};\n\nexport default awsmobile;\n`);
