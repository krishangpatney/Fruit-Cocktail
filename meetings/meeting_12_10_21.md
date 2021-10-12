Questions 

1. Can I use all three together? 
    1. Terraform to automate the process, Kubernetes to orchestrate the docker containers, Docker to host the applications. 
        1. Can just use Kubernetes 
2. Infrastructure
    1. AWS would simply be too expensive from the looks of it.  
    2. Hence look at openstack or uni servers? (Are they the same thing?) 
    3. Looks like terraform works on openstack 

---

Questions : After the meeting 

1. Does docker allow you to set the RAM set up for an application?
2. Does terraform allow for that? 
3. Does terraform work on a local based server which is not on the provider list 
4. 

---

**Note : Wait for server access codes** 

**Server Infrastructure** 

- Talk about why AWS might not be feasible
    - Cost of a single server
- Use of linux servers provided from the university.
- What SoCS can provide
    - 16 cores, tons of ram and I can use it as I see fit.
        - Can create VMs within this
    - ARM Cluster
        - A large number of ARM based servers
        - Can be sliced up as I see fit
        - I will have to slice this myself
        - I am comfortable with learning and lo
        - oking into ([link](https://www.scylladb.com/2019/09/25/isolating-workloads-with-systemd-slices/))

**Docker / K8s** 

- Terraform - Infrastructure as code
- Don't think we can use the university servers
- This then proceeds to having me setting up local end points on the server.
- I can code the scripts that allow uploading code to uni servers
- Terraform is good for providers which have APIs.
- I could install openstack on top of terraform but that causes to create too many layers which doesn't really provide that many benifits

**Automation** 

- Showed an image of the automation thing
- Kubernetes has its own policies on deployment - but how much control do I have in terms of {deployment strategies}
- At what time do I have to stop automation and do it manually
- Will need to do my own code, and use kubernetes

**Selecting applications** 

- Looked into a few potential ones - within the timeline itself.

Arm Clusters - 64 cores in total split over 4 machines, can be treated as 4 vms 

In the meanwhile, work on the applications, look at the loads. 

**Docker Swarm ( can be looked into it)** 

- It has its own policies which allow for deployment