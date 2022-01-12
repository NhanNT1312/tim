*** Settings ***
Library           SeleniumLibrary
Resource          ../../Resources/CMP/CMP_resources_import.robot
Variables         ../../TestData/CMP/CMP_testdata.py

*** Variables ***
${GroupName}      00002
${NewGroupName}    xxxx2
${ParentGroupName}    alo
${ManagerLoginId}    common
${userLoginId01}    fpt_user08
${userLoginId02}    fpt_user03
${userLoginId03}    FPT_User1
${userLoginId04}    new
${userLoginId05}    ark_manager01
${userLoginId06}    f-LIFEBOOK
${userLoginId07}    fpt_manager05
${userLoginId08}    n-VERSAPRO
${DeleteGroupName}    abc123

*** Test Cases ***
TC1
    [Documentation]    Edit Group Information
    [Setup]    Open my browser
    Go to CMP
    Login successful
    #Open "Manage User Groups" Page and search group by "Group Name"
    Run and retry                       Open Function    ManageUserGroups
    Search Group    ${GroupName}
    #Open "Edit Group Information" Page and
    #Edit Group Information
    Open Edit Group Information Page    ${GroupName}
    Input Group Name    ${NewGroupName}
    Change Manager    common
    Change Parent Group    alo
    Save User Group Information
    #[Teardown]    Close all browsers

TC2
    [Documentation]    Add User has reference authority
    [Setup]    Open my browser
    Go to CMP
    Login successful
    #Open "Manage User Groups" Page and search group by "Group Name"
    Open Function    ManageUserGroups
    Search Group    ${NewGroupName}
    #Open "Edit Group Information" Page and
    #Edit Group Information
    Open Edit Reference Authority Page    ${NewGroupName}
    Add User Reference Authority    ${userLoginId07}${DomainName}
    Add User Reference Authority    ${userLoginId08}${DomainName}
    Remove User Reference Authority    ${userLoginId08}${DomainName}
    Remove User Reference Authority    ${userLoginId05}${DomainName}
    Back To Manage User Groups Page
    #[Teardown]    Close all browsers

TC3
    [Documentation]    Add user member
    [Setup]    Open my browser
    Go to CMP
    Login successful
    #Open "Manage User Groups" Page and search group by "Group Name"
    Run and retry                       Open Function    ManageUserGroups
    Search Group    ${NewGroupName}
    #Open "Edit Group Information" Page and
    #Edit Group Information
    Open Edit Group Members Page    ${NewGroupName}
    Add Group Member    ${userLoginId01}${DomainName}
    Add Group Member    ${userLoginId02}${DomainName}
    Add Group Member    ${userLoginId03}${DomainName}
    Add Group Member    ${userLoginId04}${DomainName}
    Add Group Member    ${userLoginId05}${DomainName}
    Add Group Member    ${userLoginId06}${DomainName}
    Remove Group Member    ${userLoginId03}${DomainName}
    Remove Group Member    ${userLoginId03}${DomainName}
    Back To Manage User Groups Page
    #[Teardown]    Close all browsers

TC4
    [Documentation]    Delete Group
    [Setup]    Open my browser
    Go to CMP
    Login successful
    #Open "Manage User Groups" Page and search group by "Group Name"
    Run and retry                       Open Function    ManageUserGroups
    Search Group    ${DeleteGroupName}
    #Open "Edit Group Information" Page and
    #Edit Group Information
    Delete Group    ${DeleteGroupName}
    #[Teardown]    Close all browsers
