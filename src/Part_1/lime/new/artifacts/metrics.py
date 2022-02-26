import datetime, os, sys
from azure.mgmt.monitor import MonitorManagementClient
from azure.identity import AzureCliCredential
from azure.identity import DefaultAzureCredential

from azure.identity import UsernamePasswordCredential

def get_metric(resource_id, client, name):
    metrics = []

    today = datetime.datetime.now()
    past_hour = today - datetime.timedelta(hours=2)

    metrics_data = client.metrics.list(
        resource_id,
        timespan="{}/{}".format(past_hour, today),
        interval='PT1M',
        metricnames = name,
        aggregation='Average'
    )

    for item in metrics_data.value:
        # azure.mgmt.monitor.models.Metric
        # print("{} ({})".format(item.name.localized_value, item.unit.name))
        for timeserie in item.timeseries:
            for data in timeserie.data:
                # azure.mgmt.monitor.models.MetricData
                metrics.append("{}: {}".format(data.time_stamp, data.average))

    return metrics
    
def get_resource(vm_name, metric_name):

    subscription_id     = "6a1c9c00-ef6b-4bbf-a3f1-ca2c019f31e9"
    resource_group_name = "krishangs_resource"

    resource_id = (
        "subscriptions/{}/"                                     
        "resourceGroups/{}/"
        "providers/Microsoft.Compute/virtualmachineScaleSets/{}"
    ).format(subscription_id, resource_group_name, vm_name)

    # Retrieve the information necessary for the credentials, which are assumed to
    # be in environment variables for the purpose of this example.
    credentials = AzureCliCredential()
    # credentials = DefaultAzureCredential()
    # create client   
    client = MonitorManagementClient(
        credentials,
        subscription_id
    )

    metrics = get_metric(resource_id, client,f"{metric_name}")

    return metrics

machine_name = sys.argv[1]
unit_name    = sys.argv[2]
metric_name  = sys.argv[3]
metrics = get_resource(vm_name = f"{unit_name}", metric_name = f"{metric_name}")
# for ease of use will print it all back 
for m in metrics: 
    print(m)