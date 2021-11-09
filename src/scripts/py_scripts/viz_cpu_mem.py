import matplotlib.pyplot as plt
import numpy as np 
import os
import datetime
import signal
import subprocess

# Creates a plot
def clean_plot(data, metric):
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)
    
    x, y = zip(*data)
    ax.plot(x, y)  

    l = ax.fill_between(x, y)
    l.set_facecolors([[.5,.5,.8,.3]])
    l.set_edgecolors([[0, 0, .5, .3]])

    ax.grid(which='both')
    plt.title(f'{metric} over Time')
    # X
    plt.xlabel('Time')
    start, end = ax.get_xlim()
    ax.xaxis.set_ticks(np.arange(start, end, 1))   
    plt.xticks(rotation=45)
    # Y  
    start, end = ax.get_ylim()
    ax.yaxis.set_ticks(np.arange(start, end, 2))   
    plt.ylabel(f'{metric} Usage')

    ax.margins(0)
    plt.tight_layout()   
    plt.savefig(f'{metric}.png')

# Collects process data 
def automate(p_id, minutes, filename):
    # runs every 40 seconds until told to stop. 
    # os.system("pidstat 40 -ru -p <pid>")

    # The os.setsid() is passed in the argument preexec_fn so
    # it's run after the fork() and before  exec() to run the shell.
    pro = subprocess.Popen([f'pidstat 20 -ru -p {p_id} >> {filename}'], stdout=subprocess.PIPE, 
                        shell=True, preexec_fn=os.setsid) 
    endTime = datetime.datetime.now() + datetime.timedelta(minutes=minutes)
    while True:
        if datetime.datetime.now() >= endTime:
            os.killpg(os.getpgid(pro.pid), signal.SIGTERM)  # Send the signal to all the process groups
            break

def read_data(filename):
    with open(filename, 'r') as f: 
        lines = f.read().splitlines() 
    return lines 

# Converts to a list of dictonaries. 
def convert_to_dict(lines):
    cpu_data = []
    mem_data = []
    for n in range(1, len(lines)-1, 2): 
        header = lines[n].split()
        header[0] = 'TIME'
        info = lines[n+1].split()
        if '%CPU' in header: 
            cpu_data.append(dict(zip(header, info)))
        else: 
            mem_data.append(dict(zip(header, info)))
    
    return cpu_data, mem_data

def main(filename, p_id, minutes):
    automate(p_id, minutes, filename)
    lines = read_data(filename)
    lines = list(filter(None, lines))
    
    cpu_data, mem_data = convert_to_dict(lines)

    cpu_usage = [[cpu_data[c]['TIME'], float(cpu_data[c]['%CPU'])] for c in range(0, len(mem_data))]
    mem_usage = [[mem_data[c]['TIME'], float(mem_data[c]['%MEM'])] for c in range(0, len(mem_data))]
    # TO-DO convert time to ms and start from 0
    clean_plot(cpu_usage, 'CPU')
    clean_plot(mem_usage, 'MEM')


main('data.txt', '2323', 15)
    