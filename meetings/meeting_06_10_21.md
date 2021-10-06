### Meeting Notes - 06/10/21
- Talk about different deployment patterns and this how the microservices would be uploaded and tested. - Send the resource itself. [https://www.nginx.com/blog/deploying-microservices/https://www.nginx.com/blog/deploying-microservices/](https://www.nginx.com/blog/deploying-microservices/)
- Looking into Jaeger - This would be a metric to explore - framework
- Opensource projects - Not the objective to explore each of them - Need to pick up 3/4 that can be used for testing, of different natures for example 50 microservices or 3/5 microservices - and the hypothesis would be to see which is the best method of deploying a microservice on the cloud.
- Many of the opensource projects might not be well maintained or documented, with another issue of no available datasets being available to run simulations of the microservice. Hence need to **look for projects which can have a good datasets** which let me deploy it and give it a realistic workload for benchmarking it.
- Deployment -
- Infrastructure Set-up
    - AWS or Azure
    - Linux VMs - School can give you a VM
    - Openstack - Ehhhh wasn't the best looking option tbh
    - School VM specs - Vanilla Linux - High Spec'd
        - It needs to be sliced up, into different visualisation environments using docker or kubes
        - Or do I want something already sliced like what AWS can provide x
- I blabber about server distances and network hops that there could be but it really doesn't matter as much for testing.
- Automation
    - How to deploy an application
    - Deploy over the different patterns
        - All on one VM
        - Split into different VMs
        - Each on a separate VM
        
        Does this mean each microservice on a different VM or each application on a different VM? 
        
    - A programmatic way of deployment
        - kubes?
        - Terraform?
    - This would help figure out what the infrastructure set-up would be like.
- Scripting
    - Use python, easier than bash
    - Allows to push code and then collect data aswell
    - Suggestion : the automation part - use terraform or kubes
    - Terraform allows you to create different vms, and then lets you create security groups aswell, a docker container can then be deployed onto it
- Plan for this week
    - Timeline the different tasks
    - Check if I can add Yehia onto this.