import sys

from azure.storage.blob import BlobServiceClient, ContentSettings


def upload_file_to_blob(storage_account_name, storage_account_key, container_name, file_path, blob_name):
    try:
        # Create the BlobServiceClient object which will be used to create a container client
        connection_string = f"DefaultEndpointsProtocol=https;AccountName={storage_account_name};AccountKey={storage_account_key};EndpointSuffix=core.windows.net"
        blob_service_client = BlobServiceClient.from_connection_string(connection_string)

        # Create the ContainerClient object which will be used to create a blob client
        container_client = blob_service_client.get_container_client(container_name)

        # Create a blob client using the local file name as the name for the blob
        blob_client = container_client.get_blob_client(blob_name)

        cnt_settings = ContentSettings(content_type="text/html")

        print(f"Uploading file to blob: {blob_name}")
        with open(file_path, "rb") as f:
            blob_client.upload_blob(f, content_settings=cnt_settings, overwrite=True)

        print("Upload completed successfully")

    except Exception as e:
        print(f"Error uploading file to blob: {e}")


if __name__ == "__main__":

    try:
        if len(sys.argv) != 6:
            print(
                "Usage: python azure_blob_uploader.py <storage_account_name> <storage_account_key> <container_name> <local_file_path> <blob_name>")
            sys.exit(1)

        storage_account_name = sys.argv[1]
        storage_account_key = sys.argv[2]
        container_name = sys.argv[3]
        local_file_path = sys.argv[4]
        blob_name = sys.argv[5]

        print(f"Uploading file to blob: {blob_name}")
        print(f"Storage account name: {storage_account_name}")
        print(f"Container name: {container_name}")
        print(f"Local file path: {local_file_path}")
        print(f"Blob name: {blob_name}")

        upload_file_to_blob(storage_account_name, storage_account_key, container_name, local_file_path, blob_name)

        sys.exit(0)

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
