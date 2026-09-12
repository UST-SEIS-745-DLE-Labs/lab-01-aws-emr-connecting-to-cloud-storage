############################################
# INITIALIZE LAB PARAMS AND AWS CLI        #
############################################
CLIENT_IP="10.10.10.10" # Change this line
LAB_ENV_NAME="lab-emr-cluster-tst"
LAB_STACK_NAME="${LAB_ENV_NAME}-stack"
LAB_KEY_NAME="${LAB_ENV_NAME}-keypair"
LAB_KEY_FILE="${LAB_KEY_NAME}.pem"
CLOUD9_PRIVATE_IP=`hostname -i`

aws configure set region us-east-1
export AWS_SHARED_CREDENTIALS_FILE=/home/ec2-user/.aws/credentials
