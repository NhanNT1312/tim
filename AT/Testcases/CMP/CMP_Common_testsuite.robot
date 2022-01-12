*** Settings ***
Library      SeleniumLibrary
Resource     ../../Resources/CMP/CMP_resources_import.robot
Variables    ../../TestData/CMP/CMP_testdata.py
Resource     ../../Resources/TMP/PortalWebsite_CommonPage_resource.robot
Resource     ../../Resources/TMP/PortalWebsite_RoleAuthority_resource.robot

*** Test Cases ***
001_Verify that Tenant Admin can view Location setting list
    [Setup]                                                      Open my browser
    Go to CMP site
    Login successful
    Set Account has Admin Role                                   Administrator           ${loginid1}    ${password}    3
    Open my browser
    Go to TMP site
    Login should be success with                                 ${loginid1}             ${password}
    ${language}=                                                 Get Current Language
    Select "Setting" On Header
    Select Item Number 1 In "Setting" Menu
    Check the Page Title of "DeviceManagement" in ${language}
    [Teardown]                                                   Close all browsers

002_Verify that Manager can not view Setting Page
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Set Account has Manager Role    Manager               ${loginid2}    ${password}    4
    Open my browser
    Go to TMP site
    Login should be success with             ${loginid2}           ${password}
    "Setting" Function Should Be Disabled
    [Teardown]                               Close all browsers

003_Verify that User has Reference Authority cannot view Setting Page
    [Setup]                                  Open my browser
    Go to CMP site
    Login successful
    Set Account has Reference Role           ${loginid5}           ${password}    4    00003
    Open my browser
    Go to TMP site
    Login should be success with             ${loginid5}           ${password}
    "Setting" Function Should Be Disabled
    [Teardown]                               Close all browsers

004_Get UserId By LoginID
    [Setup]                                 Open my browser
    Go to CMP site
    Login successful
    Get User ID by exactly LoginID "${loginid1}"
    [Teardown]                              Close all browsers

005_Verify that User can not view Alert by group
    [Setup]                                       Open my browser
    Go to CMP site                                
    Login successful
    Set Account has User Role                     ${loginid6}           ${password}    4    ADMIRE
    Open my browser
    Go to TMP site
    Login should be success with                  ${loginid6}           ${password}
    "Notification" Function Should Be Disabled
    [Teardown]                                    Close All browsers

006_Verify that User can not view Setting Page
    [Setup]                                         Open my browser
    Go to TMP site
    Login should be success with                    ${manager1}${DomainName}        ${password}
    Choose "Activity" Tab On Menu Navigation Tab
    Expand All Group To Check
   # [Teardown]    Close all browsers


