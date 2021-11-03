import requests
from bs4 import BeautifulSoup
import pandas
import numpy as np
import sys

def get_html(region: str = "uksouth", currency: str = "GBP") -> str:
    url = "https://azureprice.net/"
    params = {
        "sortField": "name",
        "sortOrder": True,
        "region": region,
        "currency": currency
    }
    return requests.get(url, params=params).text

def soup_it(life_time: int = 50,  number_of_options: int = 20, iterations: int = 5):
    # Turn into an HTML soup and extract every row.
    soup = BeautifulSoup(get_html(), "html.parser")
    table = soup.findAll("table")[1]
    rows = table.findAll("tr")[::-1][:-1] # We flip them around as it receives them the wrong way.

    result = []
    for row in rows:
        value = [elem.text for elem in row.findAll("td")]
        # Slicing out the last few columns.
        value = value[0:4]
        vm_name = value[0]
        v_CPUS = int(value[1])
        linux_cost = float(value[3])
        live_time = life_time / 60 #minutes
        live_time_cost = linux_cost * float(live_time)
        total_cost_iterations = live_time_cost * (iterations)
        vals = [vm_name, v_CPUS, value[2], linux_cost ,live_time, live_time_cost, iterations,total_cost_iterations]
        if linux_cost < 5.0:
            result.append(vals)

    df = pandas.DataFrame.from_records(result, columns=["VM Name", "vCPUs", "Memory (GiB)", "Linux Cost", "Apporx Live Time (Hrs)" , "Live Time Cost" ,"Iterations", "Total Cost"])

    interval = len(df) // number_of_options
    pandas.set_option("max_rows", None)
    df = df.sort_values(by=['vCPUs', "Memory (GiB)"])
    print(df[::])
    print(np.sum(df[::]["Total Cost"]))


# Get system arguments 
# Variables -> live_time, iterations, number of options 
soup_it(life_time = int(sys.argv[1]),  number_of_options = int(sys.argv[2]), iterations = int(sys.argv[3]))
