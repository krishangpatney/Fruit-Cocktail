# Input - filename (.json), option (Memory, CPU)
# Output - Graph(Memory, CPU)
import matplotlib.pyplot as plt
import json
import numpy as np 

def create_graph(x,y, time_interval, name_of_graph):
    # def clean_plot(data, metric):
    fig = plt.figure()
    ax = fig.add_subplot(1, 1, 1)
    
    ax.plot(x, y)  

    # l = ax.fill_between(x, y)
    # l.set_facecolors([[.5,.5,.8,.3]])
    # l.set_edgecolors([[0, 0, .5, .3]])

    ax.grid(which='both')
    plt.title(f'{name_of_graph} over Time')
    # X
    plt.xlabel('Time')
    start, end = ax.get_xlim()
    ax.xaxis.set_ticks(np.arange(start, end, 1))   
    plt.xticks(rotation=45)
    # Y  
    start, end = ax.get_ylim()
    ax.yaxis.set_ticks(np.arange(start, end, 2))   
    plt.ylabel(f'{name_of_graph} Usage')

    ax.margins(0)
    plt.tight_layout()   
    plt.savefig(f'{name_of_graph}.png')

def convert_to_json(filename):
    # Opening JSON file
    f = open(filename)
    
    # returns JSON object as
    # a dictionary
    data = json.load(f)

    # Closing file
    f.close()
    return data

# returns 2 lists for average values, and timestamp
def get_list(timeseries):
    y = [val['average'] for val in timeseries]
    x = [val['timeStamp'] for val in timeseries]
    return x,y


def main(filename):
    data = convert_to_json(filename)
    timespan = data['timespan']
    time_interval = data['interval']
    value = data['value'][0]
    name_of_graph = value['name']['value']
    timeseries = value['timeseries'][0]['data']
    x, y = get_list(timeseries)
    create_graph(x,y, time_interval, name_of_graph)



main('../../Part_1/pineapple/output/raw_metrics/percentageCPU.json')