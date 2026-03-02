## 

## 

## Introduction

In this lab we will spin up a Hadoop cluster on Amazon Elastic MapReduce
(EMR) running one master node and two data nodes. For deployment, we
will leverage Amazon Web Services (AWS) CloudFormation, a cloud
Infrastructure as Code (IAC) platform. Additionally, for automating
deployment and other configuration tasks you will use a Cloud9
development environment and the AWS command line interface.

Once infrastructure deployment is complete, we will connect to a public
S3 bucket hosting an AWS Open Data dataset (NOAA surface readings) and
bring that into our Data Lake using Python. Next, you will explore the
differences between the Hadoop Distributed File System (HDFS) running on
EMR and the EMR file system (EMRFS) backed by AWS S3. In this lab, we
are using AWS S3 for data lake storage and Apache Spark on EMR for our
data lake compute.

## Pre-requisites

As a prerequisite to this lab you should have access to our class AWS
environment via <https://awsacademy.instructure.com>.

Here is an overview of our lab environment:

![](./media/image1.emf){width="7.5in" height="4.374305555555556in"}

[\]{.underline}

## **[Section 1: Initialize and upload lab files to your Cloud9 Environment]{.underline}**

1.  Make sure you are signed into the AWS Console and using our
    classroom environment found here:
    <https://awsacademy.instructure.com/login/canvas>.

2.  Navigate to your Cloud9 environment via the AWS Console. If you
    deleted your previous Cloud9 environment, you may need to create a
    new one: <https://console.aws.amazon.com/cloud9>.

    a.  **In network connection settings, select 'SSH'. All other cloud9
        settings can remain default.**

    b.  Name your cloud9 instance whatever you would like, e.g.
        'cloud9-datalakeengineering'.

3.  Once your Cloud9 environment is up and running, open it and upload
    lab files:

![Graphical user interface, application Description automatically
generated](./media/image2.png){width="6.683333333333334in"
height="4.281944444444444in"}

4.  Open lab-commands.sh within the Cloud9 text editor.

![A screenshot of a computer Description automatically generated with
medium confidence](./media/image3.png){width="5.833333333333333in"
height="2.095138888888889in"}

5.  Navigate to <https://checkip.amazonaws.com> and replace the
    \'CLIENT_IP\' value in the script with the IP address on your web
    page. Note that this is the only value you will need to change
    within the script.

> ![](./media/image4.png){width="2.5208333333333335in"
> height="0.6777777777777778in"}**Note:** If you normally have issues
> identifying your client IP address or connecting to services from your
> machine, feel free to enter \"0.0.0.0\" as your client IP. This will
> allow all inbound traffic to the box over ports specified for the
> duration of the lab. While this does pose a security risk it is a
> suitable workaround if you run into issues connecting.

**Check IP:**

**Modify CLIENT_IP variable assignment in script:**

![](./media/image5.png){width="4.697916666666667in" height="1.96875in"}

6.  

## Section 2: Create a Hadoop cluster using Amazon Elastic MapReduce (EMR), CloudFormation, and the AWS CLI

**Note:** when executing commands from lab-commands.sh do so line by
line. Be sure to observe the output on your Cloud9 terminal.

1.  In this section of the lab we will be creating our Hadoop cluster
    using Amazon EMR. First, copy/paste the first few lines to
    initialize some environment variables used through the script.

- **CLIENT_IP is the IP address of your local machine for use in
  firewall rules**

- **LAB_ENV_NAME is the base name used for the AWS resources we create**

- **LAB_STACK_NAME is the name of our CloudFormation stack specified in
  template.json**

- **LAB_KEY_NAME is the name of the private key we will use to SSH to
  the instance**

- **LAB_KEY_FILE is the file name of the private key associated with the
  key name above**

- **CLOUD9_PRIVATE_IP is the IP address or the EC2 instance for your
  Cloud9 environment for use in firewall rules (we will SSH from our
  Cloud9 environment to the Hadoop master node). Note the script uses
  command substitution to dynamically retrieve the host name.**

> ![Graphical user interface, text Description automatically
> generated](./media/image6.png){width="7.5in"
> height="2.1173611111111112in"}

2.  Execute the next section of the script to create the lab
    infrastructure. We configure the AWS command line interface, append
    the appropriate CIDR suffix to the client IP address for use in
    firewall rules, create our AWS EC2 keypair for connecting to the
    cluster over SSH, and deploy the infrastructure defined in
    template.json. Note that there are multiple parameters that we pass
    in from the command line.

> **Note:** If the AWS CLI returns an error here you may ignore it. An
> AWS CLI bug causes the command to timeout early. Note that this
> command can take some time (10 minutes or longer) as there are a lot
> of AWS resources being created by CloudFormation.

![Text Description automatically
generated](./media/image7.png){width="5.45in"
height="5.963612204724409in"}

## Section 3: Take a look at the new infrastructure then transfer files and connect to the Hadoop master node

1.  Navigate to the EC2 instances page. You should have four EC2
    instances either starting or running. Note that these were created
    when we deployed our CloudFormation template above. Specifying
    infrastructure in formats like AWS CloudFormation is known as
    infrastructure as code (IAC). This helps keep infrastructure under
    version control and in synch between environments. It also makes it
    easy to destroy and recreate infrastructure.

> EC2 instances at <https://console.aws.amazon.com/ec2>:

- A t2.micro instance used by our Cloud9 environments (your terminal
  window)

- A single Hadoop master node

- Two Hadoop data nodes

> ![](./media/image8.png){width="7.5in" height="2.4027777777777777in"}

2.  The following commands first leverage the AWS CLI to identify the ID
    for our running Hadoop cluster, pause execution until the cluster is
    running, and query the public host (DNS) name of the master node.
    Then, we use the private key we created earlier to connect to the
    EMR master node.

![Text Description automatically
generated](./media/image9.png){width="6.666666666666667in"
height="0.9444444444444444in"}

![Graphical user interface, text Description automatically
generated](./media/image10.png){width="4.460442913385827in"
height="2.725in"}

## Section 4: Bringing data into the data lake

In this section, connect to the NOAA Global Surface Summary dataset
hosted on AWS Open Data and S3 (an external S3 bucket). You will write
this data both to HDFS and to S3. You may find details on this dataset
here: <https://registry.opendata.aws/noaa-gsod/>.

1.  Open pyspark in your shell session. This will enable spark
    development in an interactive read, execute, print, loop (REPL). We
    will cover spark in more detail in later lectures. For now, read the
    dataset into a spark DataFrame from the external S3 bucket using
    EMRFS (note the s3:// scheme used in the code) and coalesce to
    reduce the number of files written in the next step:

![Text Description automatically
generated](./media/image11.png){width="5.520833333333333in"
height="2.3125in"}

2.  ![Text Description automatically generated with medium
    confidence](./media/image12.png){width="7.5in"
    height="0.9645833333333333in"}![Graphical user interface, text,
    application Description automatically
    generated](./media/image13.png){width="7.5in"
    height="1.3430555555555554in"}Next, write the data to your external
    S3 bucket. Note that you will need to replace bucket_name with your
    S3 bucket ID. This can be found here:
    <https://s3.console.aws.amazon.com/s3/buckets?region=us-east-1>.

3.  Now we'll write the weather data to our HDFS instance:

![](./media/image14.png){width="4.135416666666667in" height="0.78125in"}

4.  Let's explore the data and execute some operations in Spark. Show 10
    records on the console, print the count of records, and execute some
    SQL to aggregate the high temperature. We'll write the average high
    temperature to HDFS and exit the pyspark console:

![](./media/image15.png){width="4.510416666666667in"
height="2.2083333333333335in"}

## Section 5: Review output in HDFS and S3

1.  Leveraging the HDFS command line interface, list files in the
    noaa_surface_summary output directory.

> ![](./media/image16.png){width="6.447916666666667in"
> height="1.0729166666666667in"}

2.  From the AWS management console, find your S3 bucket and browse
    files. You may traverse the object namespace, download objects,
    delete objects, and more from the AWS console:
    <https://s3.console.aws.amazon.com/s3/buckets?region=us-east-1>

## Section 6: Destroying your Amazon EMR Cluster and inspecting lab files

1.  In a normal production environment you would leave your big data
    environment up and running or leave the data stored on S3 for when
    you turn your cluster back on. However, since we are on a student
    lab budget we will destroy our environment at the end of each lab.

The AWS CLI has commands that make deleting an entire CloudFormation
stack easy:

aws cloudformation delete-stack \--stack-name \"lab-emr-cluster-stack\"

2.  Finally, reflect on the lab and inspect the template.json file and
    CloudFormation commands used to automate cluster deployment.

## Conclusion

You have now used a running EMR cluster and Spark to bring data into our
data lake from a remote source. Additionally, you have connected to both
cloud storage (S3) and the HDFS instance running on EMR. Finally, you
have taken small steps to explore and process data within a data lake
environment. Reflect on the differences between cloud storage and HDFS
that we covered during lecture.
