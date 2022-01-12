import csv
import pyodbc
import json
import os
from functools import partial
from datetime import date, timedelta, datetime
import re
from DatabaseModel import *
from RawDataModel import RawAlertData, RawAppLog, RawSystemInfo, RawWorkLog, RawOperationLog

batch_size = 1000


class PrepareSQLData:
    def __init__(self, server, database, username, password):
        self.server = server
        self.database = database
        self.username = username
        self.password = password
        self.connection = pyodbc.connect(
            'DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+password)
        self.cursor = self.connection.cursor()

    def clear_all_data_in_table(self, table, user_id=None, device_id=None):
        sql_query = f"DELETE FROM {table}"
        if (user_id != None):
            sql_query += f" WHERE UserId = N'{user_id}'"
            if (device_id != None):
                sql_query += f" AND DeviceId = N'{device_id}'"
        try:
            self.cursor.execute(sql_query)
            self.cursor.commit()
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
            self.cursor.commit()

    def get_all_locations(self):
        try:
            self.cursor.execute(
                f"SELECT {LocationData.get_sql_column()} FROM LocationData")
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(
                f"SELECT {LocationData.get_sql_column()} FROM LocationData")

        location_list = []
        for row in self.cursor.fetchall():
            row[LocationData.get_column_index("CreatedDate")] = datetime.strptime(
                row[LocationData.get_column_index("CreatedDate")], '%Y-%m-%d %H:%M:%S.0000000 %z').isoformat()
            location_list.append(LocationData(row))
        return location_list

    def insert_alert_data_into_table(self, rawdata, user_id, device_id, group_id):
        sql_query = f"INSERT INTO AlertData ({AlertData.get_sql_column()}) VALUES "
        data = [AlertData([user_id, device_id, group_id] + x.to_list())
                for x in rawdata]
        sql_query += ', '.join(f"({x.to_sql_query()})" for x in data)
        try:
            self.cursor.execute(sql_query)
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)

        sql_query = f"DELETE FROM AlertNotification WHERE GroupId = '{group_id}' AND "
        group_conditions = ' OR '.join(
            [f"Date = '{x.Date.isoformat()}'" for x in rawdata])
        sql_query += f"({group_conditions})"
        try:
            self.cursor.execute(sql_query)
            self.cursor.commit()
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
            self.cursor.commit()

    def get_alert_data_from_table(self, group_id, date):
        sql_query = f"SELECT {AlertData.get_sql_column()} FROM AlertData WHERE GroupId = '{group_id}' AND Date = '{date}T00:00:00+09:00'"
        try:
            self.cursor.execute(sql_query)
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
        response = []
        for row in self.cursor.fetchall():
            row[AlertData.get_column_index("Date")] = datetime.strptime(
                row[AlertData.get_column_index("Date")], '%Y-%m-%d %H:%M:%S.0000000 %z').isoformat()
            response.append(AlertData(row))
        return response

    def reset_alert_notification(self, group_id, date, user_id=None):
        sql_query = f"DELETE FROM AlertNotification WHERE GroupId = N'{group_id}' AND Date = '{date}'"
        if user_id != None:
            sql_query += f" AND UserId = N'{user_id}'"
        try:
            self.cursor.execute(sql_query)
            self.cursor.commit()
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
            self.cursor.commit()

    def seen_alert_notification(self, user_id, group_id, date):
        sql_query = f"INSERT INTO AlertNotification (UserId, GroupId, Date) VALUES (N'{user_id}', N'{group_id}', '{date}')"
        try:
            self.cursor.execute(sql_query)
            self.cursor.commit()
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
            self.cursor.commit()

    def insert_applog_data_into_table(self, rawdata, user_id, device_id, group_id1, group_id2='', group_id3='', group_id4=''):
        applog_data = []
        for x in rawdata:
            temp = [user_id, device_id]
            temp += x.to_list()
            temp += [x.get_hash_key(user_id, device_id), "0",
                     group_id1, group_id2, group_id3, group_id4]
            applog_data.append(ApplicationLog(temp))

        for i in range(0, len(applog_data), batch_size):
            batch = applog_data[i:i+batch_size]
            sql_query = f"INSERT INTO ApplicationLog ({ApplicationLog.get_sql_column()}) VALUES "
            sql_query += ', '.join(f"({x.to_sql_query()})" for x in batch)
            try:
                self.cursor.execute(sql_query)
                self.cursor.commit()
            except:
                self.connection = pyodbc.connect(
                    'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
                self.cursor = self.connection.cursor()
                self.cursor.execute(sql_query)
                self.cursor.commit()

    def insert_systeminfo_data_into_table(self, rawdata, user_id, device_id):
        data = SystemInfo([user_id, device_id] + rawdata.to_list())

        sql_query = f"INSERT INTO SystemInfo ({SystemInfo.get_sql_column()}) VALUES "
        sql_query += f"({data.to_sql_query()})"
        try:
            self.cursor.execute(sql_query)
            self.cursor.commit()
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
            self.cursor.commit()

    def insert_worklog_data_into_table(self, rawdata, user_id, device_id, group_id1, group_id2='', group_id3='', group_id4=''):
        worklog_data = []
        for x in rawdata:
            temp = [user_id, device_id]
            temp += x.to_list()
            temp += ["0", group_id1, group_id2, group_id3, group_id4]
            worklog_data.append(WorkingLog(temp))

        for i in range(0, len(worklog_data), batch_size):
            batch = worklog_data[i:i+batch_size]
            sql_query = f"INSERT INTO WorkingLog ({WorkingLog.get_sql_column()}) VALUES "
            sql_query += ', '.join(f"({x.to_sql_query()})" for x in batch)
            try:
                self.cursor.execute(sql_query)
                self.cursor.commit()
            except:
                self.connection = pyodbc.connect(
                    'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
                self.cursor = self.connection.cursor()
                self.cursor.execute(sql_query)
                self.cursor.commit()

    def insert_operationlog_data_into_table(self, rawdata, id, user_id, acting_action):
        data = OperationLog([id, user_id, acting_action] + rawdata.to_list())

        sql_query = f"INSERT INTO OperationLog ({OperationLog.get_sql_column()}) VALUES "
        sql_query += f"({data.to_sql_query()})"
        try:
            self.cursor.execute(sql_query)
            self.cursor.commit()
        except:
            self.connection = pyodbc.connect(
                'DRIVER={SQL Server};SERVER='+self.server+';DATABASE='+self.database+';UID='+self.username+';PWD='+self.password)
            self.cursor = self.connection.cursor()
            self.cursor.execute(sql_query)
            self.cursor.commit()

    def __parse_alertdata_file(self, data, increasement=0, date_format="%Y-%m-%d"):
        current_date = (
            date.today() + timedelta(days=increasement)).strftime(date_format)
        for record in data:
            record["Date"] = re.sub(
                r'^xxxx-xx-xx', current_date, record["Date"])

        rawdata = [RawAlertData(record) for record in data]
        return rawdata

    def __parse_applicationlog_file(self, data, increasement=0, date_format="%Y-%m-%d"):
        current_date = (
            date.today() + timedelta(days=increasement)).strftime(date_format)
        for record in data:
            record["Date"] = re.sub(
                r'^xxxx-xx-xx', current_date, record["Date"])

        rawdata = [RawAppLog(record) for record in data]
        return rawdata

    def __parse_systeminfo_file(self, data):
        rawdata = RawSystemInfo(data)
        return rawdata

    def __parse_workinglog_file(self, data, increasement=0, date_format="%Y-%m-%d"):
        current_date = (
            date.today() + timedelta(days=increasement)).strftime(date_format)
        for record in data:
            record["Date"] = re.sub(
                r'^xxxx-xx-xx', current_date, record["Date"])

        rawdata = [RawWorkLog(record) for record in data]
        return rawdata

    def __parse_operationlog_file(self, data):
        rawdata = RawOperationLog(data)
        return rawdata

    def read_json(self, message_type, path, increasement=0, date_format="%Y-%m-%d"):
        dirname = os.path.dirname(__file__)
        filepath = os.path.join(dirname, path)
        with open(filepath, encoding='utf-8') as json_file:
            data = json.load(json_file)
            if (message_type == "Alert"):
                return self.__parse_alertdata_file(data, increasement=increasement, date_format=date_format)
            elif (message_type == "AppLog"):
                return self.__parse_applicationlog_file(data, increasement=increasement, date_format=date_format)
            elif (message_type == "SystemInfo"):
                return self.__parse_systeminfo_file(data)
            elif (message_type == "WorkLog"):
                return self.__parse_workinglog_file(data, increasement=increasement, date_format=date_format)
            elif (message_type == "OperationLog"):
                return self.__parse_operationlog_file(data)
            else:
                return None

class ReadCSV:

    def read_usage_csv_file(self, filename):
      file = open(filename, 'r')
      csvfile = csv.reader(file)
      file.close
      return [row for row in csvfile]