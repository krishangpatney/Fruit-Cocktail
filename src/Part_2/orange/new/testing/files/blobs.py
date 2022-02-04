import os, sys
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, __version__
from os import listdir


def find_files( path_to_dir, suffix=".csv"):
    filenames = listdir(path_to_dir)
    return [ filename for filename in filenames if filename.endswith( suffix ) ]

try:
    # init variables
    # connect_str = os.getenv('AZURE_STORAGE_CONNECTION_STRING')
    connect_str = "DefaultEndpointsProtocol=https;AccountName=krishangsmetrics;AccountKey=VdN1SY40ie95cfQAY8wTr70fOz8oEZaM8pj50KPgbW/P1gWODMF3u7F/z4+B93bwc4fhU/SedaJktWzi7SYRAQ==;EndpointSuffix=core.windows.net"
    cocktail_mix = "pineapple"
    unit = str(sys.argv[1])
    machine_name = str(sys.argv[2]).replace("_", "")
    # Quick start code goes here
    # Create the BlobServiceClient object which will be used to create a container client
    blob_service_client = BlobServiceClient.from_connection_string(connect_str)
    # Create a unique name for the container
    container_name = f"{cocktail_mix}-{machine_name}-{unit}".lower()

    # Cate the container
    container_client = blob_service_client.create_container(container_name)

    for n in find_files("./", '.txt'):
        # Create a blob client using the local file name as the name for the blob
        blob_client = blob_service_client.get_blob_client(container=container_name, blob=f"{n}")
        with open(f"./{n}", "rb") as data:
            blob_client.upload_blob(data)

    # for n in find_files("./", ".json"):
    #     # Create a blob client using the local file name as the name for the blob
    #     blob_client = blob_service_client.get_blob_client(container=container_name, blob=f"{n}")
    #     with open(f"./{n}", "rb") as data:
    #         blob_client.upload_blob(data)
            
    print("confirmed")
except Exception as ex:
    print('Exception:')
    print(ex)