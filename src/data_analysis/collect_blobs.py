import os, sys
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient, __version__
from os import listdir
import azure

def save_blob(local_path,file_name,file_content):
    # Get full path to the file
    download_file_path = os.path.join(LOCAL_BLOB_PATH, file_name)
 
    # for nested blobs, create local path as well!
    os.makedirs(os.path.dirname(download_file_path), exist_ok=True)
 
    with open(download_file_path, "wb") as file:
      file.write(file_content)

try:
    # init variables
    # connect_str = os.getenv('AZURE_STORAGE_ CONNECTION_STRING')
    connect_str = "DefaultEndpointsProtocol=https;AccountName=krishangsmetrics;AccountKey=YhioXARcAYLN2/NQl4Rd4vzqhnWOICqoGxXdHl/RmfLCoDQZtm7+7TY8SmBUmwoBQTbSqT9d/UXhQNKlQG5LIA==;EndpointSuffix=core.windows.net"

    # Create the BlobServiceClient object which will be used to create a container client
    blob_service_client = BlobServiceClient.from_connection_string(connect_str)
    containers = blob_service_client.list_containers()
    
    for c in containers:
        container = blob_service_client.get_container_client(c.name)
        blobs = container.list_blobs()
        print(c.name)
        split_names = (c.name).split("-")
        if split_names[0] not in ["pineapple", "watermelon", "orange"]:
            parent_diretory = f"./collected_data/{split_names[0]}"
            if not os.path.isdir(parent_diretory):
                os.mkdir(parent_diretory, 0o777)


            api_path        = os.path.join(parent_diretory, "api")
            container_path  = os.path.join(api_path, split_names[1])
            blob_path = os.path.join(container_path, split_names[2])

            if not os.path.isdir(api_path):
                os.mkdir(api_path, 0o777)
            if not os.path.isdir(container_path):
                os.mkdir(container_path, 0o777)
            if not os.path.isdir(blob_path):
                os.mkdir(blob_path, 0o777)
            
            
            for blob in blobs:
                print(blob_path)
                bytes = container.get_blob_client(blob).download_blob().readall()
                with open(f"{blob_path}/{blob.name}", 'wb') as f: 
                    f.write(bytes)

except Exception as ex:
    print('Exception:')
    print(ex)


