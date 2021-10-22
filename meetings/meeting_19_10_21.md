Questions to ask 

- **For the metrics, they exist, but do I use automated tools, such as prometheus?**
    - A friend of mine working at the industry shared how their company uses metrics
    - Exposed endpoints get sent to promethius, and then to grafana.
    - The metrics are dependent on the application, however http codes, latency, call rate
- **cronjobs for starting and stopping microservices through scripts ?**
- **Applications that don't run locally - might on bambi? Not a 100% sure.**
- **Show the graph I made**

App Metrics (Based on Endpoints) 

- HTTP codes
- Latency
- Call rates

VM metrics 

- CPU Usage
- Network Usage
- Disk Read Latency
- Disk Read Speeds
- Disk Read I/0
- Disk Write Latency, Speeds & I/O

So I can use a spidy crawler - This then goes through all the endpoints that exist on the website, which can be put into a metrics measurement tool 

**The plan for setting up the infrastructure (Each bit can be split into a task on the timeline?)**

![8F66D723-2BC3-477F-846B-3EE1D7BDE487.jpeg](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/bce10b13-6441-4097-8472-3bce13c5c727/8F66D723-2BC3-477F-846B-3EE1D7BDE487.jpeg)

Sample Script (Firefox CPU Usage with Youtube on) 

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/533b1c81-4185-43dc-8ee0-a9dde2f2e64e/Untitled.png)

Textfile output 

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/4d505022-e2d3-4674-8715-cba06b7e67a8/Untitled.png)

pidstat 40 -ru -p <pid>

Meeting Notes 

- Talked about cronjobs - set-up can run on intervals
- Talked about infrastructure - now outdated (?).
- Talk about CPU & MEM metrics
- Metrics between each microservice (Out of Scope)
- What you want to do is to try different configurations of deploying the micro services on the servers. You know backing them all in one server or spreading them evenly or whatever, and then calculating the key performance indicators of services - which are mainly you know response rates completion time and so on. The machine traffic isn't really I wouldn't say it's a primary objective.
- How do I split microservices on different servers, from a codebase I am not familiar to.
    - Could use a py script to split applications by parsing the source code and then deploy on different VMs
    - Need to also honor the endpoints with each microservice
    - Does this increase inter-server latencies?
- I could look into Apache AB - [https://httpd.apache.org/docs/2.4/programs/ab.html](https://httpd.apache.org/docs/2.4/programs/ab.html)
- Another server @uni was talked about here.
- Talk about robot shop and so on.