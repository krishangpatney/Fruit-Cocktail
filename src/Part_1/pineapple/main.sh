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

    Run a load generator requires python and loctus 
    ip_address=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ./output/application_ip.txt)
    cd ./temp_load
    locust --host "http://${ip_address[0]}" --csv "${machine}_load" --headless -u 1000 -r 10 -t 5m
    cd ..
    sleep 6m

    source get_metrics.sh krishangs_resource pineapplication-1-site $machine
    
    
    source kill.sh
done




