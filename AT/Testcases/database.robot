*** Settings ***
Variables    ../TestData/${environment}_TestData.py
Library      DatabaseLibrary
Library      ../Libs/PrepareSQLData.py                 tcp:${DBHost}        ${DBTable}         ${DBUser}    ${DBPass}
Library      ../Libs/PrepareSAData.py                  ${DBStorageTable}    ${DBStorageKey}

*** Variables ***
${environment}    CI

*** Test Cases ***
Insert Alert Demo
    ${b}    Read Json            Alert    ../TestData/Json/AlertData.json
    Log     ${b[1].to_list()}

    Clear All Data In Table         AlertData    abc    def
    Insert Alert Data Into Table    ${b}         abc    def    xyz

    ${a}=    Get Alert Data From Table    xyz    2020-12-11
    FOR      ${row}                       IN     @{a}
    Log      ${row.Date.day}
    Log      ${row.Date.month}
    Log      ${row.Date.year}
    Log      ${row.UserId}
    Log      ${row.DeviceId}
    Log      ${row.GroupId}
    END

Insert AppLog Demo
    ${b}    Read Json            AppLog    ../TestData/Json/AppLog.json
    Log     ${b[0].to_list()}

    Clear All Data In Table          ApplicationLog    abc    def
    Insert AppLog Data Into Table    ${b}              abc    def    xyz

Insert SystemInfo Demo
    ${b}    Read Json         SystemInfo    ../TestData/Json/SystemInfo.json
    Log     ${b.to_list()}

    Clear All Data In Table              SystemInfo    abc    def
    Insert SystemInfo Data Into Table    ${b}          abc    def

Insert WorkLog Demo
    ${b}    Read Json            WorkLog    ../TestData/Json/WorkLog.json
    Log     ${b[0].to_list()}

    Clear All Data In Table           WorkingLog    abc    def
    Insert WorkLog Data Into Table    ${b}          abc    def    xyz

Get Location List
    ${a}    Get All Locations
    FOR     ${row}                      IN    @{a}
    Log     ${row.LocationName}
    Log     ${row.Latitude}
    Log     ${row.Longitude}
    Log     ${row.Range}
    Log     ${row.CreatedDate.day}
    Log     ${row.CreatedDate.month}
    Log     ${row.CreatedDate.year}
    END

test_2
    #${a}    Get Current Presence    abc
    #Delete Current Presence    abc
    #Insert Current Presence    abc    abcd    2020/11/26 08:00:00+09:00    1
    #Insert Current Presence    abc    abcde    2020/11/26 08:00:00+09:00    1    10.0000    10.0000
    #Update Current Presence    abc    abcd    presence=3
    #${a}    Get Current Presence    abc
    ${a}     Get device id data            f36adf81-e031-4dd8-c890-08d82d1ea7cb
    FOR      ${b}                          IN                                      @{a}
    Log      ${b.__dict__}
    Log      ${b.ToWorkingLogDate.year}
    END
    #delete device id data    TinTT8    TinTT8    TinTT8
    #insert device id data    TinTT8    TinTT8    TinTT8    TinTT8
    ${a}=    Get Current Presence          000388e5-dc2c-4d9e-6561-08d8595084ad    24b58a05-6129-4d70-b1c6-676a74d7df4b
    Log      ${a[0].LastActivity}
    ${b}     Convert Date                  ${a[0].LastActivity}                    result_format=%m/%d/%Y %H:%M

*** Keywords ***
