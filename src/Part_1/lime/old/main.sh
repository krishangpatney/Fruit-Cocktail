# inputs -> subscription id - 1, iterations to run

machine_arrays=$(<./machine_name.txt);


for machine in ${machine_arrays}
do 
    for i in {1..5}
    do 
        echo "Running setup for ${machine}"
        source secrets.sh ${1} #loads susbscripton  id for scripts 

        source set_machine.sh $machine 
        start=`date +%s`
        # Creating a machine 
        source run.sh
        end=`date +%s`
        sleep 5m 
        # Runnning load 

        # Run a load generator requires python and loctus 
        ip_address=$(grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' ./output/application_ip.txt)
        cd ./temp_load
        mkdir -p "$machine"
        cd "./${machine}"
        mkdir -p "$i"
        cd "./${i}"
        locust --host "http://${ip_address[0]}" --csv "${machine}_load" --html "${machine}.html" --headless -u 10000 -r 10 -t 30m
        cd ".."
        cd ".."
        cd ".."

        sleep 5m

        source get_metrics.sh krishangs_resource robotshop-vmss $machine $i
        
        source kill.sh

        # output a log of what has gone through
        runtime=$((end-start))

        # machine_name - run - run_time 
        "${machine}-${i}-${runtime}">>"./output/lime.txt" 
    done
    sleep 2
done

# Completed runs - Standard_A1_v2 Standard_A2_v2 Standard_A4m_v2

# Runs not supported - Standard_A2, Basic_A3


