**What works** 

- Terraform works using a **pre-created resource group**
- Script to get **pricing** from [Azureprice.net](http://Azureprice.net) works
- Can use a standard storage option - this should not be a metric imo
- Set up a server **manually** to run robot-shop (single server single application)
- Terraform can create multiple servers - as I need
- I can provision a file to a single server currently

**What does not work** 

- I had a script which used apache - but that was dumb and should've used ngnix
- Provisioning a file to multiple (nodes) azure servers which are created using a terraform script

**Questions** 

- Where do I store server secrets? - Can just have them in a .gitignore formatio

```bash
node_location   = "UK South"
resource_prefix = "robot_shop"
Environment     = "Test"
node_count      = 1
vm_size         = "Standard_A2m_v2"
subscription_id = "XXX" #Secret x 
project_name    = "robot_shop"

admin_username  = "testuser" 
admin_password  = "pass@1234" #not so important secret IG 

===============================

# You can use this functionality in a subshell to set your secrets as environment variables and then call terraform apply:

# Read secrets from pass and set as environment variables
export TF_VAR_username=$(pass db_username)
export TF_VAR_password=$(pass db_password)
# When you run Terraform, it'll pick up the secrets automatically
terraform apply
```

ab 10000 requests to website - On size Standard A2m v2 (2 vcpus, 16 GiB memory)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/3d98a8e0-21a9-41ee-8a94-69957260f4b7/Untitled.png)

```bash
This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking catapp.uksouth.cloudapp.azure.com (be patient)

Server Software:        nginx/1.14.0
Server Hostname:        catapp.uksouth.cloudapp.azure.com
Server Port:            80

Document Path:          /
Document Length:        2586 bytes

Concurrency Level:      10
Time taken for tests:   218.877 seconds
Complete requests:      10000
Failed requests:        0
Total transferred:      27610000 bytes
HTML transferred:       25860000 bytes
Requests per second:    45.69 [#/sec] (mean)
Time per request:       218.877 [ms] (mean)
Time per request:       21.888 [ms] (mean, across all concurrent requests)
Transfer rate:          123.19 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:       37   87  73.0     72    1756
Processing:    53  131 122.8    108    3637
Waiting:       51  123  89.0    103    2496
Total:        105  218 160.2    183    4399

Percentage of the requests served within a certain time (ms)
  50%    183
  66%    206
  75%    223
  80%    236
  90%    287
  95%    397
  98%    608
  99%   1048
 100%   4399 (longest request)
```

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/8d3fb159-96ce-49d2-b262-aeffeb35c0d1/Untitled.png)

After a wee while it looks like this