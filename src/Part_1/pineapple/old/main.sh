# inputs -> subscription id - 1, list of machines, iterations to run, subscripo 

machine_arrays=$(<./machine_name.txt);

# workflow 
# What doesnt work 
    # Creating VM - the vm broke lol?
    # Getting metrics 
for machine in ${machine_arrays}
do 
    for i in {1..5}
    do 
        echo "Running setup for ${machine}"
        source secrets.sh ${1} #loads susbscripton  id for scripts 

        source set_machine.sh $machine 
        # Creating a machine 
        source run.sh

        sleep 5m 
        # Runnning load 
        # Run a load generator requires python and loctus 
        ip_address=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ./output/application_ip.txt)
        cd ./temp_load
        mkdir -p "$machine"
        cd "./${machine}"
        mkdir -p "$i"
        cd "./${i}"
        locust --host "http://${ip_address[0]}" --csv "${machine}_load" --headless -u 1000 -r 10 -t 30m
        locust --host "www.google.com" --csv "loca_load" --headless -u 1000 -r 10 -t 30s </dev/null &>/dev/null &

        cd ".."
        cd ".."
        cd ".."

        sleep 5m

        source get_metrics.sh krishangs_resource pineapplication-1-site $machine $i
        
        source kill.sh
    done
    sleep 2
done

# Completed runs - Standard_A1_v2
# Runs not supported - Standard_A2, Basic_A3


