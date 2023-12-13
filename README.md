# Microservices home management system

## Background

This project was completed as part of my training at Northcoders and creates a set of managed microservices for a home management system (e.g. heating, lighting), deployable in AWS, using Terraform for Infrastructure as Code (IaC) approach. The main features are:

1. **Scalability**: auto-scaling for each service allows for elastic, horizontal scaling on demand.
   
2. **Stateless servers**: AWS DynamoDB is used for data storage, manipulation and retreival.

3. **Resilience**: Load balancer for each service will allow automatic balancing and improve performance, reliability, availability and fault tolerance.

4. **Security**: AWS IAM user and credentials used for app authorisation. Easily configurable for remote state to allow for extra security and safe collaboration. 

5. **Redundancy**: used "design for failure" approach to avoid single points of failure and employ redundancy strategies via auto-scaling.

## ToC

- [Microservices home management system](#microservices-home-management-system)
  - [Background](#background)
  - [ToC](#toc)
  - [Architecture](#architecture)
    - [Networking Module](#networking-module)
    - [Security Module](#security-module)
    - [Server Module](#server-module)
    - [Database Module](#database-module)
    - [Loadbalancer Module](#loadbalancer-module)
    - [Autoscaling Module](#autoscaling-module)
  - [Setup](#setup)
    - [External dependencies](#external-dependencies)
    - [Terraform and AWS setup](#terraform-and-aws-setup)
  - [Building the infrastructure](#building-the-infrastructure)
    - [Build networking, security, database, server and loadbalancer modules](#build-networking-security-database-server-and-loadbalancer-modules)
      - [Setting up instances](#setting-up-instances)
    - [Build autoscaling module](#build-autoscaling-module)
  - [Remote state](#remote-state)
  - [Testing](#testing)
    - [Native Terraform testing](#native-terraform-testing)
    - [Terratest](#terratest)
      - [External dependencies](#external-dependencies-1)
      - [Setup](#setup-1)
      - [Running tests](#running-tests)
    - [End-point testing](#end-point-testing)
  - [Troubleshooting and debugging](#troubleshooting-and-debugging)
  - [Further development](#further-development)
  - [Contact](#contact)

## Architecture

The project uses a module-based approach following [terraform best practices](https://www.terraform-best-practices.com/examples/terraform) for module design and file naming. 

Note that for looping and creation of resources which require one resource per service, the user-input variable of `services` is used as a baseline. 

A brief outline of the structure, module for module, below:

### Networking Module

Creates vpc, subnets, public routing table, internet gateway and routing table associations.

The module **outputs** the following (ignoring outputs for testing):

`vpc_id`: id of the main project vpc

`pub_sub_ids`: list of the public subnets

`asg_pub_sub_ids`: list of the public subnets for auto-scaling groups (hard-coded as the second and third subnets)

### Security Module

Creates security groups and associated rules. Note that the following security groups are created:

1. allow http ingress on ports 80 and 3000
2. allow https ingress on port 3000
3. allow ssh ingress on port 22 (limited to local IP-address, auto-acquired via data block)
4. allow egress via all protocols

The module **outputs** the following: 

`security_group_ids`: list of the ids of all security groups

`lb_security_group_ids`: list of the ids of security groups for use with load-balancer

`security_groups`: list of the security group objects

### Server Module

Creates ec2 instances, one per service, using ami data lookup block. Hard-coded to Ubuntu 20.4.

The module **outputs** the following:

`ec2s`: a list of objects with selected required information for each instance created - **NOTE: also output at root level**

`ec2_ids`: a list of the ids of the ec2 instances created

Also contained in the server module is a bash script for use in server set-up (see below) and an example file for environment variables.

### Database Module

Creates tables in DynamoDB, one per non-status service

The module **outputs** the following:

`table_names`: a list of the names of the tables created

### Loadbalancer Module

Creates target groups for each service, target group attachments, loadbalancer, loadbalancer listener and rules.

The module **outputs** the following:

`lb_public_dns`: the public DNS of the loadbalancer **NOTE: also output at root level**

`target_arns`: a list of the ARN values for the target groups

### Autoscaling Module

Creates the AMI images for each of the instances created in the server module. Also creates the launch templaces, auto-scaling groups and auto-scaling to target group attachments.

Module has no **outputs**

## Setup

### External dependencies

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   
2. [Terraform](https://developer.hashicorp.com/terraform/install)
   
### Terraform and AWS setup

1. Clone this repo to your local machine.
   
2. You will need an account with AWS. Once completed, authenticate with your credentials on your local machine. Note that this build relies on local authentication via credential export from the command line. 
   
3. The apps use DynamoDB for stateless server deployment. For security the relevant credentials required for database access should be created in the AWS console, not programmatically within the terraform code:
   
   a. create a new IAM user for database access

   b. assign the user with the correct IAM policy (use AWS managed policy or create your own with appropriate DynamoDB access)

   c. give user CLI access and create access key for use with environment variables later

4. Access to the instances require an SSH key-pair. Create this key pair in the AWS console or do the following via the command line:

    a. navigate to your ssh key directory on your local machine
    
    b. run the following in the command line 
    
    ```bash    
    aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > MyKeyPair.pem
    ```
    c. check that the key has been created in the directory

    d. if connecting from linux machine, run `chmod 400 MyKeyPair.pem`

    e. use the name of your key-pair as variable
   
## Building the infrastructure

The infrastructure should be built in two parts to allow for automatic scaling via autoscaling module.

Note that **three** `.tfvars` files are provided:

1. `test.tfvars` for use only with Terratest testing files
   
2. `dev.tfvars` for development use (only creates one service and status server)
   
3. `prod.tfvars` for production use (creates two services and status server as standard)

On running terraform commands, relevant `tfvars` file must be selected using `terraform apply -var-file="[filename].tfvars"`

### Build networking, security, database, server and loadbalancer modules

In the root `main.tf` file, comment out the module call for autoscaling.

1. Run `terraform init` to initialise the modules
   
2. Run `terraform plan` to see what will be created in AWS
   
3. Run `terraform apply` to build

#### Setting up instances

Test servers are available for the infrastructure.

In order to set up and test the servers, please use the following approach:

1. Ensure that instances have been correctly created (one per service) in AWS console. Outputs from the root level will include the required information. For easier reference run `terraform output > outputs.txt`

2. SSH into your first ec2 instance (suggest `lighting`):

    a. `cd` to dir where you SSH key is saved

    b. run 

    ```bash    
    ssh -i "name-of-key.pem" ubuntu@ip-or-pub-dns-address`
    ```

3. Once connected to your instance, use the bash script in the server module to set-up the instance. Do this in stages:

    - clone the repo
    
    Once cloned, create a .env.local file and ensure that local environment variables are saved in accordance with the sample file in the server module
    
    - install nvm
    - install npm
    - install all dev dependencies
    - install pm2
    - run pm2 with run script
    - set pm2 action at startup
    - save pm2 state for automatic pm2 run at start up

4. At this point it is advisable to test the instance using the health endpoint `/api/[service-name]/health` and also via a GET request to the service itself `/api/[service-name]`

5. Repeat these steps for the other servers

### Build autoscaling module

Once the servers have been correctly set up, build the autoscaling groups via the autoscaling module. AMIs will be created for each instance which will automatically run the server once spun up.

## Remote state

There is provision for using remote state files on Terraform Cloud. Simply comment in the code in the `cloud.tf` file and ensure that 

## Testing

Some **very basic** tests have been included in the codebase to demonstrate how unit and integration testing may be used to test the infrastructure. These should be expanded on and developed further if they are to be relied upon in production environment. 

End-point testing and auto-scaling testing have also been carried out with appropriate tools.

### Native Terraform testing

In the `test-tf` folder there is a file showing two tests writtin in Terraform's native testing framework.

### Terratest

In the `tests` folder there is one set of tests for the network module, written in Go, and adapted from the [Terratest](https://terratest.gruntwork.io/) library. 

In order to use these tests:

#### External dependencies

Go must be installed on your system - follow the instructions [here](https://go.dev/doc/install)

If using VSCode, ensure that the relevant extension is installed, and allow VSCode to fix any missing modules or dependencies. 

#### Setup

1. Ensure that Go is installed and the `PATH` local environment variable is correctly set up by running `go version` in your repo directory

2. Run `go mod init "<MODULE NAME>"` where `MODULE NAME` is the address to your git repo, for example `github.com/<YOUR_USERNAME>/<YOUR_REPO_NAME>`.

3. Run `go mod tidy` to fetch required imports

#### Running tests

Run `go test -v <test-file-name>`. The `-v` flag will give detailed output in the terminal.

### End-point testing

Detailed endpoint testing was carried out using [Insomnia](https://insomnia.rest/download)

## Troubleshooting and debugging

During the build, the majority of the issues were encountered on connecting the apps with the DynamoDB tables. 

Suggested troubleshooting steps:

1. Check that correct authorisation credentials have been provided in the environment variables for each of the servers. 

## Further development

- [ ] Build out the testing framework to include detailed integration tests in Terratest framework for entire infrastructure

- [ ] Change the model.js in the heating server to take user-defined table names

- [ ] Add autoscaling policies based on CloudWatch metrics and testing
  
- [ ] Rewrite infrastructure in Typescript in Pulumi

## Contact

If you would like any further information, discussion or want to collaborate, please reach out to me via GitHub or LinkedIn - address in my profile page.