def BRANCH = scm.branches[0].name
pipeline 
{
	agent any
	environment 
	{ 			
		SECRET_KEY = credentials('secretKey')
	}
	stages 
	{
		stage('Setup') 
		{
      		steps 
			{
        		script 
				{
					if(env.BRANCH_NAME == null)
					{
						BRANCH = scm.branches[0].name
						
					}
          			switch(BRANCH) 
					{
            			case 'develop':
							mule_env = 'dev'
							cloudhub_env = 'DEV'
							env_suffix = '-dev'
							platform_credentials = 'Cloudhub_Dev'
							break
						case 'qa':
							mule_env = 'qa'
							cloudhub_env = 'DEV'
							env_suffix = '-qa'
							platform_credentials = 'Cloudhub_qa'
							break
						case 'prod':
							mule_env = 'prod'
							cloudhub_env = 'DEV'
							env_suffix = '-prod'
							platform_credentials = 'Cloudhub_Prod'
							break
							
          			}
        		}
      		}
    	}
		stage('Build Application') 
		{
		
			steps 
			{
				echo "Branch name : ${BRANCH}"
				echo "environment ${mule_env}"
				echo "cloudhub env ${cloudhub_env}"
				echo "suffix ${env_suffix}"
				bat 'mvn clean install -DskipTests'
			
			}
		
		}
		
		stage('Test') 
		{
			steps 
			{
				echo 'Application in Testing Phase… '
				echo "Branch name : ${BRANCH}"
				echo "environment ${mule_env}"
				echo "cloudhub env ${cloudhub_env}"
				echo "suffix ${env_suffix}"
				bat "mvn test -Dmule.env=${mule_env} -Dmule.encryptionKey=${SECRET_KEY_PSW} -Dapp.coverage=60"
			
			}
		
		}
		
		stage('Deploy CloudHub') 
		{
		
			environment 
			{ 
				ANYPOINT_CREDENTIALS = credentials('anypointPlatforms')
				ENV_CREDENTIALS = credentials("${platform_credentials}")
			}
		
			steps 
			{
			
				echo 'Deploying mule project due to the latest code commit…'
				echo "Environment credentials USER ->  ${ENV_CREDENTIALS_USR}  and password ->  ${ENV_CREDENTIALS_PSW}" 
				echo "Deploying to the configured environment….  ${mule_env}"
				
				bat "mvn package deploy -DmuleDeploy -DskipTests -Dmule.env=${mule_env} -Dmule.encryptionKey=${SECRET_KEY_PSW} -Dapp.coverage=60 -Denv.name=${cloudhub_env} -Danypoint.uri=https://anypoint.mulesoft.com -Dmule.version=4.4.0 -Dcloudhub.user=${ANYPOINT_CREDENTIALS_USR} -Dcloudhub.password=${ANYPOINT_CREDENTIALS_PSW} -Dcloudhub.workerType=MICRO -Dcloudhub.workerCount=1 -Dcloudhub.region=us-east-2 -Danypoint.monitoring=false -Denv.suffix=${env_suffix}"
				
			}
		
		}
	
	}

}

