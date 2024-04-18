import React from 'react';
import './App.css';
import Amplify from 'aws-amplify';
import { Authenticator, withAuthenticator } from '@aws-amplify/ui-react';
import '@aws-amplify/ui-react/styles.css';
import Home from './Home';

// Define AWS Amplify configuration directly
const awsConfig = {
  aws_project_region: process.env.AWS_REGION,
  aws_cognito_identity_pool_id: process.env.IDENTITY_POOL_ID,
  aws_cognito_region: process.env.AWS_REGION,
  aws_user_pools_id: process.env.USER_POOLS_ID,
  aws_user_pools_web_client_id: process.env.USER_POOLS_CLIENT_ID
};

// Configure Amplify with awsConfig
Amplify.configure(awsConfig);

function App() {
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
