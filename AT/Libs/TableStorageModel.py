from datetime import datetime
from hashlib import sha256
from azure.data.tables import EdmType

class CurrentPresence:
    def __init__(self, data):
        self.PartitionKey = data.get("PartitionKey", None)
        self.RowKey = data.get("RowKey", None)
        self.UserId = data.get("PartitionKey", None)
        self.DeviceId = data.get("RowKey", None)
        self.LastActivity = datetime.strptime(data.get("LastActivity", "1601/01/01 00:00:00+00:00"), '%Y/%m/%d %H:%M:%S%z')
        self.Presence = data.get("Presence", None)
        self.Latitude = data.get("Latitude", None)
        self.Longitude = data.get("Longitude", None)
        print(self.__dict__)

class DeviceIdData:
    def __init__(self, data):
        self.ProductNumber = data.get("ProductNumber", None)
        self.PartNumber = data.get("PartNumber", None)
        self.SerialNumber = data.get("SerialNumber", None)
        self.VenderName = data.get("VenderName", None)
        self.PartitionKey = self.__hash_partition_key(self.ProductNumber, self.SerialNumber)
        self.RowKey = data.get("RowKey", None)
        self.UserId = data.get("RowKey", None)
        self.ConnectionString = data.get("ConnectionString", None)
        self.DeviceId = data.get("DeviceId", None)
        self.ToWorkingLogDate = datetime.strptime(data.get("ToWorkingLogDate", "1601-01-01T00:00:00.000Z"), '%Y-%m-%dT%H:%M:%S.%f%z')
        self.ClientAppVersion = data.get("ClientAppVersion", None)
        self.UpdateStatus = data.get("UpdateStatus", None)
        print(self.__dict__)
    
    def __hash_partition_key(self, product_number, serial_number):
        data_string = f"{product_number}{serial_number}"
        hash_value = sha256(data_string.encode('UTF-8')).hexdigest()
        return hash_value