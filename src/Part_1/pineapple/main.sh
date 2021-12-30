# inputs -> subscription id - 1, list of machines, iterations to run, subscripo 

machine_arrays=$(<./machine_name.txt);

# workflow 
# What doesnt work 
    # Creating VM - the vm broke lol?
    # Getting metrics 
for machine in ${machine_arrays}
do 
    echo $machine 
    source secrets.sh ${1} #loads susbscripton  id for scripts 

    source set_machine.sh $machine 

    source run.sh

    sleep 5m 

    source get_metrics.sh krishangs_resource pineapple-1-site
    
    sleep 5m
    
    source kill.sh
done


# DONE take in sub id and create files with subscription id 

# DONE run run.sh 
# sleep this script for 50 minutes 

# run get metrics. 

# run kill.sh 



