import datetime
from azure.mgmt.monitor import MonitorManagementClient
from azure.identity import AzureCliCredential
from azure.identity import DefaultAzureCredential

from azure.identity import UsernamePasswordCredential

subscription_id     = "6a1c9c00-ef6b-4bbf-a3f1-ca2c019f31e9"
resource_group_name = "krishangs_resource"
vm_name             = "pineapplication-b-site"


resource_id = (
    "subscriptions/{}/"                                     
    "resourceGroups/{}/"
    "providers/Microsoft.Compute/virtualMachines/{}"
).format(subscription_id, resource_group_name, vm_name)

# resource_id = "/subscriptions/6a1c9c00-ef6b-4bbf-a3f1-ca2c019f31e9/
# resourceGroups/krishangs_resource/providers/Microsoft.Compute/virtualMachines/pineapplication-a-site
# /providers/Microsoft.Insights/metrics/Percentage CPU"

# Retrieve the information necessary for the credentials, which are assumed to
# be in environment variables for the purpose of this example.
credentials = AzureCliCredential()
# credentials = DefaultAzureCredential()
# create client   
client = MonitorManagementClient(
    credentials,
    subscription_id
)

# # You can get the available metrics of this specific resource
# for metric in client.metric_definitions.list(resource_id):
#     # azure.monitor.models.MetricDefinition
#     print("{}: id={}, unit={}".format(
#         metric.name.localized_value,
#         metric.name.value,
#         metric.unit
#     ))

# Example of result for a VM:
# Percentage CPU: id=Percentage CPU, unit=Unit.percent
# Network In: id=Network In, unit=Unit.bytes
# Network Out: id=Network Out, unit=Unit.bytes
# Disk Read Bytes: id=Disk Read Bytes, unit=Unit.bytes
# Disk Write Bytes: id=Disk Write Bytes, unit=Unit.bytes
# Disk Read Operations/Sec: id=Disk Read Operations/Sec, unit=Unit.count_per_second
# Disk Write Operations/Sec: id=Disk Write Operations/Sec, unit=Unit.count_per_second
# Available Memory Bytes
# Get CPU total of yesterday for this VM, by hour

today = datetime.datetime.now()
yesterday = today - datetime.timedelta(hours=1)

metrics_data = client.metrics.list(
    resource_id,
    timespan="{}/{}".format(yesterday, today),
    interval='PT5M',
    metricnames='Percentage CPU',
    aggregation='Total'
)

print(metrics_data)

for item in metrics_data.value:
    # azure.mgmt.monitor.models.Metric
    print("{} ({})".format(item.name.localized_value, item.unit))
    for timeserie in item.timeseries:
        for data in timeserie.data:
            # azure.mgmt.monitor.models.MetricData
            print("{}: {}".format(data.time_stamp, data))

# Example of result:
# Percentage CPU (percent)
# 2016-11-16 00:00:00+00:00: 72.0
# 2016-11-16 01:00:00+00:00: 90.59
# 2016-11-16 02:00:00+00:00: 60.58
# 2016-11-16 03:00:00+00:00: 65.78
# 2016-11-16 04:00:00+00:00: 43.96
# 2016-11-16 05:00:00+00:00: 43.96
# 2016-11-16 06:00:00+00:00: 114.9
# 2016-11-16 07:00:00+00:00: 45.4