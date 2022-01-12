*** Settings ***
Library      SeleniumLibrary
Resource     ../../Resources/CMP/CMP_resources_import.robot
Variables    ../../TestData/CMP/CMP_testdata.py
Resource     ../../Resources/CMP/CMP_resources_import.robot

*** Variables ***
${GroupName}       TestAT01
${GroupParent}      0001
${ManagerLoginId}    fpt_manager02
${DelteGroup}       TestAT01
${UserLoginId}      fpt_admin23
${UserLoginId01}    fpt_user08
${UserLoginId02}    fpt_user03
${UserPassword}     123456aA
${UserDivision}     2
${UserLastName}     FPT
${UserLastFuri}     ザゴースキー
${UserFirstName}     UserAT
${UserFirstFuri}     ワレン
${UserJopTitle}     Tester
${UserJopPrio}      100
${SelectAdmin}      True
${SelectManager}      True
*** Test Cases ***
Export all user info to CSV file 
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Get all user info to file csv and save to "CSV/All_User_AT.csv"
    # [Teardown]                               Close browser

Export new user info to CSV file
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Create a New User If Not Exist    ${SelectAdmin}    ${SelectManager}    ${UserLoginId}${DomainName}    ${UserPassword}     ${UserDivision}    ${UserLastName}    ${UserLastFuri}    ${UserFirstName}    ${UserFirstFuri}    ${UserJopTitle}    ${UserJopPrio}
    Get user "${UserLoginId}${DomainName}" info to file csv and save to "CSV/New_User_AT.csv"
    [Teardown]                               Close browser

Export new group info to CSV file
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Create user group  ${GroupName}     ${ManagerLoginId}${DomainName}  ${GroupParent} 
    Run and retry                       Open Function    ManageUserGroups
    Search Group    ${GroupName}
    Open Edit Reference Authority Page    ${GroupName}
    Add User Reference Authority    ${UserLoginId}${DomainName}
    Run and retry                       Open Function    ManageUserGroups
    Search Group    ${GroupName}
    Open Edit Group Members Page    ${GroupName}
    Add Group Member    ${UserLoginId01}${DomainName}
    Add Group Member    ${UserLoginId02}${DomainName}
    Get group "${GroupName}" info to file csv and save to "CSV/Group_AT.csv"
    # Delete user group with ${GroupName}
    [Teardown]                               Close browser

Test get group info
     [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Get group "00003" info to file csv and save to "CSV/Group_AT.csv"
    [Teardown]                               Close browser


Delete group
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Delete user group with ${GroupName}
    [Teardown]                               Close browser

Set role for user 
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Create a New User If Not Exist    ${SelectAdmin}    ${SelectManager}    ${ManagerLoginId}${DomainName}    ${UserPassword}     ${UserDivision}    ${UserLastName}    ${UserLastFuri}    ${UserFirstName}    ${UserFirstFuri}    ${UserJopTitle}    ${UserJopPrio}
    # [Teardown]                               Close browser

Test assign user from file
    [Documentation]  Format file CSV: groupName,userLoginId 
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Assign Users to group from CSV file "CSV/AssignUser_AT.csv"
    [Teardown]                               Close browser

Test assign Reference Authority from file
    [Documentation]  Format file CSV: groupName,userLoginId 
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Assign Reference Authority group from CSV file "CSV/AssignUser_AT.csv"
    [Teardown]                               Close browser

