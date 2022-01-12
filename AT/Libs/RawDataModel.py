from datetime import datetime
from hashlib import sha256


class RawAlertData:
    sql_column = ['Date', 'WorkStartViolationNo', 'WorkEndViolationNo',
                  'WorkIntervalViolationNo', 'ContinuousWorkViolationNo', 'ContinuousNonWorkViolationNo']

    def __init__(self, data):
        self.Date = datetime.strptime(
            data.get("Date", "0001-01-01T00:00:00+00:00"), '%Y-%m-%dT%H:%M:%S%z')
        self.WorkStartViolationNo = data.get("WorkStartViolationNo", 0)
        self.WorkEndViolationNo = data.get("WorkEndViolationNo", 0)
        self.WorkIntervalViolationNo = data.get("WorkIntervalViolationNo", 0)
        self.ContinuousWorkViolationNo = data.get(
            "ContinuousWorkViolationNo", 0)
        self.ContinuousNonWorkViolationNo = data.get(
            "ContinuousNonWorkViolationNo", 0)
        print(self.__dict__)

    def to_list(self):
        return [self.__dict__["Date"].isoformat()] + [self.__dict__[x] for x in self.sql_column[1:]]


class RawAppLog:
    sql_column = ['Date', 'AppName', 'AppTitle', 'Duration']

    def __init__(self, data):
        self.Date = datetime.strptime(
            data.get("Date", "0001-01-01T00:00:00+00:00"), '%Y-%m-%dT%H:%M:%S%z')
        self.AppName = data.get("AppName", "")
        self.AppTitle = data.get("AppTitle", "")
        self.Duration = data.get("Duration", 0)
        print(self.__dict__)

    def to_list(self):
        return [self.__dict__["Date"].isoformat()] + [self.__dict__[x] for x in self.sql_column[1:]]

    def get_hash_key(self, user_id, device_id):
        data = [user_id, device_id, self.Date.strftime(
            "%Y-%m-%d"), self.AppName, self.AppTitle]
        data_string = '|'.join(data)
        a = sha256(data_string.encode('UTF-8')).hexdigest()
        return a


class RawSystemInfo:
    sql_column = ['WinLoginName', 'ComputerName', 'OsVersion',
                  'BiosVersion', 'EcKbcVersion', 'CpuInfo', 'MemoryInfo']

    def __init__(self, data):
        self.WinLoginName = data.get("WinLoginName", "")
        self.ComputerName = data.get("ComputerName", "")
        self.OsVersion = data.get("OsVersion", "")
        self.BiosVersion = data.get("BiosVersion", "")
        self.EcKbcVersion = data.get("EcKbcVersion", "")
        self.CpuInfo = data.get("CpuInfo", "")
        self.MemoryInfo = data.get("MemoryInfo", "")
        print(self.__dict__)

    def to_list(self):
        return [self.__dict__[x] for x in self.sql_column]

class RawOperationLog:
    sql_column = ['fileName', 'startTime', 'endTime']

    def __init__(self, data):
        self.fileName = data.get("fileName", "")
        self.startTime = data.get("startTime", "")
        self.endTime = data.get("endTime", "")
        print(self.__dict__)

    def to_list(self):
        return [self.__dict__[x] for x in self.sql_column]


class RawWorkLog:
    sql_column = ['Date', 'Presence']

    def __init__(self, data):
        self.Date = datetime.strptime(
            data.get("Date", "0001-01-01T00:00:00+00:00"), '%Y-%m-%dT%H:%M:%S%z')
        self.Presence = data.get("Presence", 0)
        print(self.__dict__)

    def to_list(self):
        return [self.__dict__["Date"].isoformat()] + [self.__dict__[x] for x in self.sql_column[1:]]
