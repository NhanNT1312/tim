import os
import urllib
from datetime import datetime, timezone
from hashlib import sha256
from TableStorageModel import CurrentPresence, DeviceIdData
from azure.data.tables import TableServiceClient, UpdateMode, EdmType
from azure.core.exceptions import ResourceExistsError, ResourceNotFoundError
import logging

proxies = urllib.request.getproxies()
os.environ["HTTP_PROXY"] = proxies['http']
logging.basicConfig()
logging.getLogger().setLevel(logging.WARNING)


class PrepareSAData:
    def __init__(self, name, key):
        self.connect_str = f"DefaultEndpointsProtocol=https;AccountName={name};AccountKey={key};EndpointSuffix=core.windows.net"
        self.table_service_client = TableServiceClient.from_connection_string(
            conn_str=self.connect_str)

    def get_current_presence(self, user_id, device_id=None):
        table_client = self.table_service_client.get_table_client(
            "CurrentPresence")
        query_string = f"PartitionKey eq '{user_id}'"
        if device_id != None:
            query_string += f" and RowKey eq '{device_id}'"
        queried_entities = table_client.query_entities(filter=query_string)
        current_presence_list = []
        for entity_chosen in queried_entities:
            current_presence_list.append(CurrentPresence(entity_chosen))
        return current_presence_list

    def insert_current_presence(self, user_id, device_id, last_activity, presence: int, latitude: float = None, longitude: float = None):
        datetime.strptime(last_activity, '%Y/%m/%d %H:%M:%S%z')
        entity = {
            'PartitionKey': user_id,
            'RowKey': device_id,
            'LastActivity': last_activity,
            'Presence': presence,
            'Latitude': latitude if latitude == None else "{:.7f}".format(latitude),
            'Longitude': longitude if longitude == None else "{:.7f}".format(longitude)
        }
        table_client = self.table_service_client.get_table_client(
            "CurrentPresence")
        try:
            entity = table_client.create_entity(entity=entity)
        except ResourceExistsError:
            raise ResourceExistsError("CurrentPresence already exists!")

    def delete_current_presence(self, user_id, device_id=None):
        table_client = self.table_service_client.get_table_client(
            "CurrentPresence")
        try:
            if device_id != None:
                table_client.delete_entity(
                    partition_key=user_id,
                    row_key=device_id
                )
            else:
                queried_entities = table_client.query_entities(
                    filter=f"PartitionKey eq '{user_id}'")
                for entity_chosen in queried_entities:
                    table_client.delete_entity(
                        partition_key=entity_chosen.get("PartitionKey", None),
                        row_key=entity_chosen.get("RowKey", None)
                    )
        except ResourceNotFoundError:
            logging.warning("CurrentPresence does not exists!")

    def update_current_presence(self, user_id, device_id, last_activity=None, presence: int = None, latitude: float = None, longitude: float = None):
        table_client = self.table_service_client.get_table_client(
            "CurrentPresence")
        entity = {
            'PartitionKey': user_id,
            'RowKey': device_id,
            'LastActivity': last_activity,
            'Presence': presence,
            'Latitude': latitude if latitude == None else "{:.7f}".format(latitude),
            'Longitude': longitude if longitude == None else "{:.7f}".format(longitude)
        }
        try:
            table_client.get_entity(partition_key=user_id, row_key=device_id)
            table_client.upsert_entity(mode=UpdateMode.MERGE, entity=entity)
        except ResourceNotFoundError:
            raise ResourceNotFoundError("CurrentPresence does not exists!")

    def get_device_id_data(self, user_id, device_id=None):
        table_client = self.table_service_client.get_table_client(
            "DeviceIdData")
        query_string = f"RowKey eq '{user_id}'"
        if device_id != None:
            query_string += f" and DeviceId eq '{device_id}'"
        queried_entities = table_client.query_entities(filter=query_string)
        device_id_data_list = []
        for entity_chosen in queried_entities:
            device_id_data_list.append(DeviceIdData(entity_chosen))
        return device_id_data_list

    def insert_device_id_data(self, user_id, device_id, product_number, serial_number):
        entity = {
            'ProductNumber': product_number,
            'PartNumber': 'UI_AT',
            'SerialNumber': serial_number,
            'VenderName': 'UI_AT',
            'PartitionKey': self.__hash_partition_key(product_number, serial_number),
            'RowKey': user_id,
            'ConnectionString': 'UI_AT',
            'DeviceId': device_id,
            'ToWorkingLogDate': datetime(1601, 1, 1, 0, 0, tzinfo=timezone.utc),
            'ClientAppVersion': '0.0.0.0',
            'UpdateStatus': 0
        }
        table_client = self.table_service_client.get_table_client(
            "DeviceIdData")
        try:
            entity = table_client.create_entity(entity=entity)
        except ResourceExistsError:
            raise ResourceExistsError("DeviceIdData already exists!")

    def delete_device_id_data(self, user_id, product_number=None, serial_number=None):
        table_client = self.table_service_client.get_table_client(
            "DeviceIdData")
        try:
            if product_number == None or serial_number == None:
                queried_entities = table_client.query_entities(
                    filter=f"RowKey eq '{user_id}'")
                for entity_chosen in queried_entities:
                    table_client.delete_entity(
                        partition_key=entity_chosen.get("PartitionKey", None),
                        row_key=entity_chosen.get("RowKey", None)
                    )
            else:
                table_client.delete_entity(
                    partition_key=self.__hash_partition_key(
                        product_number, serial_number),
                    row_key=user_id
                )
        except ResourceNotFoundError:
            logging.warning("DeviceIdData does not exists!")

    def __hash_partition_key(self, product_number, serial_number):
        data_string = f"{product_number}{serial_number}"
        hash_value = sha256(data_string.encode('UTF-8')).hexdigest()
        return hash_value
