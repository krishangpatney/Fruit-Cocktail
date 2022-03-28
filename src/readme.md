# Readme

Put a brief description of your code here. This should at least describe the file structure.

There are 3 parts within this folder, each consists of two different directories, run a specific deployment pattern, 
The data_analysis direrctory has the collected data, aswell as the jupyter notebooks for each fruit, refer the dissertation for more details, these store graphic visualizations for the collected data. 


## Build instructions

**You must** include the instructions necessary to build and deploy this project successfully. If appropriate, also include 
instructions to run automated tests. 

### Requirements

* A valid Azure Cloud Subscription. 
* A Linux host machine with the Terraform and Azure CLI installed and configured. 
* A machine with Jupyter Notebooks installed. 

### Build steps
There is no need to build Terraform code, in some cases you may have to give permissions to the *.sh files. 

To run the code, you will have to go within .tfvar files and change subscription ID's and also tokens for files where cloud storage is required. 
You can simply run the bash file once the file's have been configured. 


