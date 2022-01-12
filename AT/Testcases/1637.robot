*** Settings ***
Default Tags    PrepareData
Library         SeleniumLibrary
Resource        ../Resources/resources_import.robot
Resource        ../Resources/TMP/PortalWebsite_RoleAuthority_resource.robot
Resource        ../Resources/CMP/CMP_resources_import.robot
Variables       ../TestData/CMP/CMP_testdata.py
Variables       ../TestData/CMP/CMP_testdata.py
Variables       ../TestData/PortalWebsite_PrepareData_100User_testdata.py
Resource        ../Resources/TMP/Usage_PrepareData.robot
Resource        ../Resources/TMP/Activity_PrepareData.robot
Resource        ../Resources/TMP/AlertMenu_PrepareData.robot
Library         DateTime

*** Test Cases ***
Prepare Data PC Status
    [Documentation]              Prepare Data PC Status For 100 User
    [Tags]                       PrepareData                                             PC
    [Setup]                      Open my browser
    Go to CMP site
    Login successful             ${CMP_User}                                             ${CMP_Pass}
    Run and retry                       Open Function                ManagerUserAccount
    FOR                          ${i}                                                    IN RANGE       7100           10001
    ${num}                       Format String                                           {0:04d}        ${i}
    ${UserID}=                   Get User ID by exactly LoginID "dun${num}@sitv2test"
    Delete PC status of          ${UserID}                                               ${UserID}-d
    Insert PC status for User    1                                                       ${UserID}      ${UserID}-d    0        0    2020/03/15 15:00:00+09:00
    END
    [Teardown]                   Close all browsers

Prepare Data Activity
    [Documentation]                             Prepare Data Activity For 100 User
    [Tags]                                      PrepareData                                             Activity
    [Setup]                                     Open my browser
    Go to CMP site
    Login successful                            ${CMP_User}                                             ${CMP_Pass}
    ${groupName}=                               Set Variable                                            ${EMPTY}
    ${GroupID}=                                 Set Variable                                            ${EMPTY}
    FOR                                         ${i}                                                    IN RANGE                    1                      10001
    Continue For Loop If                        ${i%100}==0
    ${groupName}                                ${GroupID}                                              Get Group Info From User    ${i}                   ${groupName}    ${GroupID}
    ${status}=                                  Run Keyword And Return Status                           Page Should Contain         Manage User Account
    Run Keyword If                              ${status}==False                                        Open Function               ManagerUserAccount
    ${num}                                      Format String                                           {0:04d}                     ${i}
    ${UserID}=                                  Get User ID by exactly LoginID "dun${num}@sitv2test"
    Clear Activity All Data DeviceId Of User    ${UserID}
    Delete Activity Data of User                ${UserID}
    Insert Activity DeviceId Data for           ${UserID}                                               ${UserID}-d                 dun-${num}             dun-${num}

    Insert Activity Data in "dump_data" for "${UserID}" with "${UserID}-d" to "${GroupID}"
    END
    [Teardown]                                                                                Close all browsers

Prepare Data Usage
    [Documentation]              Prepare Data Activity For 100 User
    [Tags]                       PrepareData                                             Activity
    [Setup]                      Open my browser
    Go to CMP site
    Login successful             ${CMP_User}                                             ${CMP_Pass}
    ${groupName}=                Set Variable                                            ${EMPTY}
    ${GroupID}=                  Set Variable                                            ${EMPTY}
    FOR                          ${i}                                                    IN RANGE                       4800                     10001
    Continue For Loop If         ${i%100}==0
    ${logout}=                   Run Keyword And Return Status                           Page Should Contain Element    //span[@id='spnUser']
    Run Keyword If               ${logout}==False                                        Login successful               ${CMP_User}              ${CMP_Pass}
    ${groupName}                 ${GroupID}                                              Get Group Info From User       ${i}                     ${groupName}    ${GroupID}
    ${status}=                   Run Keyword And Return Status                           Page Should Contain            Manage User Account
    Run Keyword If               ${status}==False                                        Open Function                  ManagerUserAccount
    ${num}                       Format String                                           {0:04d}                        ${i}
    ${UserID}=                   Get User ID by exactly LoginID "dun${num}@sitv2test"
    Delete Usage Data of User    ${UserID}

    Insert Usage Data in "dump_data" for "${UserID}" with "${UserID}-d" to "${GroupID}"
    END
    [Teardown]                                                                             Close all browsers

*** Keywords ***
Get Group Info From User
    [Arguments]               ${index}                         ${old_name}                      ${old_id}
    ${group_num}=             Evaluate                         (${index}-${index%100})/100+1
    ${new_name}=              Format String                    GroupV2 {0:.0f}.1                ${group_num}
    Return From Keyword If    '${new_name}'=='${old_name}'     ${old_name}                      ${old_id}
    ${new_id}=                Get group id of "${new_name}"
    [Return]                  ${new_name}                      ${new_id}
