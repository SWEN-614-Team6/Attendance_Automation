import React from 'react';
import './App.css';
import {Amplify} from 'aws-amplify';
import { Auth } from 'aws-amplify';
import { Authenticator, withAuthenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import Home from './Home';

// Define AWS Amplify configuration directly

const awsmobile = {
  "aws_project_region": process.env.REACT_APP_AWS_REGION,
  "aws_cognito_identity_pool_id": process.env.REACT_APP_IDENTITY_POOL_ID,
  "aws_cognito_region": process.env.REACT_APP_AWS_REGION,
  "aws_user_pools_id": process.env.REACT_APP_USER_POOLS_ID,
  "aws_user_pools_web_client_id": process.env.REACT_APP_USER_POOLS_CLIENT_ID,
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

// Configure Amplify with awsConfig
Amplify.configure(awsmobile);


function App() {
  useEffect(() => {
    // Function to calculate SECRET_HASH
    const calculateSecretHash = (clientId, clientSecret, username) => {
      const secret = `${clientId}${username}`;
      return CryptoJS.HmacSHA256(secret, clientSecret).toString(CryptoJS.enc.Base64);
    };

    // Get user's username
    const username = 'user@example.com';

    // Calculate SECRET_HASH
    const clientId = process.env.REACT_APP_USER_POOLS_CLIENT_ID;
    const clientSecret = process.env.REACT_APP_USER_POOLS_CLIENT_SECRET;
    const secretHash = calculateSecretHash(clientId, clientSecret, username);

    // Override Auth.signIn to include SECRET_HASH
    const signIn = Auth.signIn.bind(Auth);
    Auth.signIn = (username, password) => {
      return signIn(username, password, secretHash);
    };
  }, []);

  return (
    <div className="App">
      <Authenticator>
        {({ signOut }) => (
          <main>
            <header className='App-header'>
              {/* Quiz Component */}
              { <Home /> }
              {/* Sign Out Button */}
              <button 
                onClick={signOut} 
                style={{ 
                  margin: '20px', 
                  fontSize: '0.8rem', 
                  padding: '5px 10px', 
                  marginTop: '20px'
                }}
              >
                Sign Out
              </button>
            </header>
          </main>
        )}
      </Authenticator>
    </div>
  );
}

export default withAuthenticator(App);