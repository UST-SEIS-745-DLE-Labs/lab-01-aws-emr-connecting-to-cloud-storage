############################################
# INSTALL MISC DEPENDENCIES                #
############################################
sudo apt update && sudo apt install -y uuid-runtime

############################################
# CONFIGURE AWS CLI                        #
############################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws configure
