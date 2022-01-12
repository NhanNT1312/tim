*** Settings ***
Default Tags    White Screen Login
Library         SeleniumLibrary
Resource        ../Resources/resources_import.robot

*** Test Cases ***
TC_001
    [Documentation]                                             Verify can login to White Screen by Password Login option
    [Tags]                                                      White Screen Login
    [Setup]                                                     Open my browser
    Go to White Screen
    Select Password Login option
    Input "${Username1}" and "${Password1}" then login
    Verify the message when login to White Screen successful
    [Teardown]                                                  Close all browsers
