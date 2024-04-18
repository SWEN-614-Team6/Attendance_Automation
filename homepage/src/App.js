import React, { useEffect } from 'react';
import './App.css';
import { Auth, Storage, Amplify } from 'aws-amplify';
import { Authenticator, withAuthenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import Home from './Home';
import CryptoJS from 'crypto-js';

// Define AWS Amplify configuration directly
const awsConfig = {
  aws_project_region: process.env.REACT_APP_AWS_REGION,
  aws_cognito_identity_pool_id: process.env.REACT_APP_IDENTITY_POOL_ID,
  aws_cognito_region: process.env.REACT_APP_AWS_REGION,
  aws_user_pools_id: process.env.REACT_APP_USER_POOLS_ID,
  aws_user_pools_web_client_id: process.env.REACT_APP_USER_POOLS_CLIENT_ID
};

// Configure Amplify with awsConfig
Amplify.configure(awsConfig);

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
              {/* Home Component */}
              <Home />
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
