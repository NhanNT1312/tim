from datetime import datetime
import string
import random


class AlertData:
    sql_column = ['UserId', 'DeviceId', 'GroupId', 'Date', 'WorkStartViolationNo', 'WorkEndViolationNo',
                  'WorkIntervalViolationNo', 'ContinuousWorkViolationNo', 'ContinuousNonWorkViolationNo']
    sql_type = ['nvarchar', 'nvarchar', 'nvarchar',
                'date', 'int', 'int', 'int', 'int', 'int']

    def __init__(self, data):
        self.UserId = data[self.sql_column.index('UserId')]
        self.DeviceId = data[self.sql_column.index('DeviceId')]
        self.GroupId = data[self.sql_column.index('GroupId')]
        self.Date = datetime.strptime(
            data[self.sql_column.index('Date')], '%Y-%m-%dT%H:%M:%S%z')
        self.WorkStartViolationNo = data[self.sql_column.index(
            'WorkStartViolationNo')]
        self.WorkEndViolationNo = data[self.sql_column.index(
            'WorkEndViolationNo')]
        self.WorkIntervalViolationNo = data[self.sql_column.index(
            'WorkIntervalViolationNo')]
        self.ContinuousWorkViolationNo = data[self.sql_column.index(
            'ContinuousWorkViolationNo')]
        self.ContinuousNonWorkViolationNo = data[self.sql_column.index(
            'ContinuousNonWorkViolationNo')]
        print(self.__dict__)

    @staticmethod
    def get_column_index(column):
        return AlertData.sql_column.index(column)

    @staticmethod
    def get_sql_column():
        return ', '.join(AlertData.sql_column)

    def to_sql_query(self):
        query_string = ''
        for i in range(len(self.sql_column)):
            if self.sql_type[i] == 'nvarchar':
                query_string += f"N'{self.__dict__[self.sql_column[i]]}', "
            elif self.sql_type[i] == 'int':
                query_string += f"{self.__dict__[self.sql_column[i]]}, "
            else:
                query_string += f"'{self.__dict__[self.sql_column[i]]}', "
        return query_string[:-2]


class ApplicationLog:
    sql_column = ['UserId', 'DeviceId', 'Date', 'AppName', 'AppTitle', 'Duration',
                  'HashKey', 'MessageNumber', 'Group_1', 'Group_2', 'Group_3', 'Group_4']
    sql_type = ['nvarchar', 'nvarchar', 'date', 'nvarchar', 'nvarchar', 'int',
                'nvarchar', 'int', 'nvarchar', 'nvarchar', 'nvarchar', 'nvarchar']

    def __init__(self, data):
        self.UserId = data[self.sql_column.index('UserId')]
        self.DeviceId = data[self.sql_column.index('DeviceId')]
        self.Date = datetime.strptime(
            data[self.sql_column.index('Date')], '%Y-%m-%dT%H:%M:%S%z')
        self.AppName = data[self.sql_column.index('AppName')].replace("'", "''")
        self.AppTitle = data[self.sql_column.index('AppTitle')].replace("'", "''")
        self.HashKey = data[self.sql_column.index('HashKey')]
        self.MessageNumber = data[self.sql_column.index('MessageNumber')]
        self.Duration = data[self.sql_column.index('Duration')]
        self.Group_1 = data[self.sql_column.index('Group_1')]
        self.Group_2 = data[self.sql_column.index('Group_2')]
        self.Group_3 = data[self.sql_column.index('Group_3')]
        self.Group_4 = data[self.sql_column.index('Group_4')]
        print(self.__dict__)

    @staticmethod
    def get_column_index(column):
        return ApplicationLog.sql_column.index(column)

    @staticmethod
    def get_sql_column():
        return ', '.join(ApplicationLog.sql_column)

    def to_sql_query(self):
        query_string = ''
        for i in range(len(self.sql_column)):
            if self.sql_type[i] == 'nvarchar':
                query_string += f"N'{self.__dict__[self.sql_column[i]]}', "
            elif self.sql_type[i] == 'int':
                query_string += f"{self.__dict__[self.sql_column[i]]}, "
            else:
                query_string += f"'{self.__dict__[self.sql_column[i]]}', "
        return query_string[:-2]


class LocationData:
    sql_column = ['LocationId', 'LocationName',
                  'Latitude', 'Longitude', 'Range', 'CreatedDate']
    sql_type = ['int', 'nvarchar', 'int', 'int', 'int', 'Date']

    def __init__(self, data):
        self.LocationId = data[self.sql_column.index('LocationId')]
        self.LocationName = data[self.sql_column.index('LocationName')]
        self.Latitude = data[self.sql_column.index('Latitude')]
        self.Longitude = data[self.sql_column.index('Longitude')]
        self.Range = data[self.sql_column.index('Range')]
        self.CreatedDate = datetime.strptime(
            data[self.sql_column.index('CreatedDate')], '%Y-%m-%dT%H:%M:%S%z')
        print(self.__dict__)

    @staticmethod
    def get_column_index(column):
        return LocationData.sql_column.index(column)

    @staticmethod
    def get_sql_column():
        return ', '.join(LocationData.sql_column)


class SystemInfo:
    sql_column = ['UserId', 'DeviceId', 'WinLoginName', 'ComputerName',
                  'OsVersion', 'BiosVersion', 'EcKbcVersion', 'CpuInfo', 'MemoryInfo']
    sql_type = ['nvarchar', 'nvarchar', 'nvarchar', 'nvarchar',
                'nvarchar', 'nvarchar', 'nvarchar', 'nvarchar', 'nvarchar']

    def __init__(self, data):
        self.UserId = data[self.sql_column.index('UserId')]
        self.DeviceId = data[self.sql_column.index('DeviceId')]
        self.WinLoginName = data[self.sql_column.index('WinLoginName')]
        self.ComputerName = data[self.sql_column.index('ComputerName')]
        self.OsVersion = data[self.sql_column.index('OsVersion')]
        self.BiosVersion = data[self.sql_column.index('BiosVersion')]
        self.EcKbcVersion = data[self.sql_column.index('EcKbcVersion')]
        self.CpuInfo = data[self.sql_column.index('CpuInfo')]
        self.MemoryInfo = data[self.sql_column.index('MemoryInfo')]
        print(self.__dict__)

    @staticmethod
    def get_column_index(column):
        return SystemInfo.sql_column.index(column)

    @staticmethod
    def get_sql_column():
        return ', '.join(SystemInfo.sql_column)

    def to_sql_query(self):
        query_string = ''
        for i in range(len(self.sql_column)):
            if self.sql_type[i] == 'nvarchar':
                query_string += f"N'{self.__dict__[self.sql_column[i]]}', "
            elif self.sql_type[i] == 'int':
                query_string += f"{self.__dict__[self.sql_column[i]]}, "
            else:
                query_string += f"'{self.__dict__[self.sql_column[i]]}', "
        return query_string[:-2]


class WorkingLog:
    sql_column = ['UserId', 'DeviceId', 'Date', 'Presence',
                  'MessageNumber', 'Group_1', 'Group_2', 'Group_3', 'Group_4']
    sql_type = ['nvarchar', 'nvarchar', 'date', 'int', 'int',
                'nvarchar', 'nvarchar', 'nvarchar', 'nvarchar']

    def __init__(self, data):
        self.UserId = data[self.sql_column.index('UserId')]
        self.DeviceId = data[self.sql_column.index('DeviceId')]
        self.Date = data[self.sql_column.index('Date')]
        self.Presence = data[self.sql_column.index('Presence')]
        self.MessageNumber = data[self.sql_column.index('MessageNumber')]
        self.Group_1 = data[self.sql_column.index('Group_1')]
        self.Group_2 = data[self.sql_column.index('Group_2')]
        self.Group_3 = data[self.sql_column.index('Group_3')]
        self.Group_4 = data[self.sql_column.index('Group_4')]
        print(self.__dict__)

    @staticmethod
    def get_column_index(column):
        return WorkingLog.sql_column.index(column)

    @staticmethod
    def get_sql_column():
        return ', '.join(WorkingLog.sql_column)

    def to_sql_query(self):
        query_string = ''
        for i in range(len(self.sql_column)):
            if self.sql_type[i] == 'nvarchar':
                query_string += f"N'{self.__dict__[self.sql_column[i]]}', "
            elif self.sql_type[i] == 'int':
                query_string += f"{self.__dict__[self.sql_column[i]]}, "
            else:
                query_string += f"'{self.__dict__[self.sql_column[i]]}', "
        return query_string[:-2]

class OperationLog:
    sql_column = ['Id', 'UserId', 'LoginId', 'EventTime',
                  'ActingAction', 'DetailJson']
    sql_type = ['int', 'nvarchar', 'nvarchar', 'datetimeoffset',
                'int', 'nvarchar']

    def __init__(self, data):
        self.Id = data[self.sql_column.index('Id')]
        self.UserId = data[self.sql_column.index('UserId')]
        self.LoginId = data[self.sql_column.index('LoginId')]
        self.EventTime = data[self.sql_column.index('EventTime')]
        self.ActingAction = data[self.sql_column.index('ActingAction')]
        self.DetailJson = data[self.sql_column.index('DetailJson')]
        print(self.__dict__)

    @staticmethod
    def get_column_index(column):
        return OperationLog.sql_column.index(column)

    @staticmethod
    def get_sql_column():
        return ', '.join(OperationLog.sql_column)

    def to_sql_query(self):
        query_string = ''
        for i in range(len(self.sql_column)):
            if self.sql_type[i] == 'nvarchar':
                query_string += f"N'{self.__dict__[self.sql_column[i]]}', "
            elif self.sql_type[i] == 'int':
                query_string += f"{self.__dict__[self.sql_column[i]]}, "
            else:
                query_string += f"'{self.__dict__[self.sql_column[i]]}', "
        return query_string[:-2]