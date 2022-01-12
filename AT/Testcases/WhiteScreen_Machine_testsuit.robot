*** Settings ***
Default Tags    Machine
Library         SeleniumLibrary
Library         String
Resource        ../Resources/resources_import.robot


*** Test Cases ***
TC_001
    [Documentation]                              Verify the UI of Work Center creation form
    [Tags]                                       Machine
    [Setup]                                      Open my browser 
    Go to White Screen
    Login by Password Login successful
    Select Machine on the left sidebar
    Verify UI of Machine page
    Click on Create WC button
    Verify the UI of Work Center creation form
    [Teardown]                                   Close browser

TC_002
    [Documentation]                              Verify can create a new Work Center
    [Tags]                                       Machine
    [Setup]                                      Open my browser 
    Go to White Screen
    Login by Password Login successful
    Select Machine on the left sidebar
    Click on Create WC button
    Fill out all information to create a Work Center
    Click on Submit button on WC form
    [Teardown]                                   Close browser

TC_003
    [Documentation]                              Verify can update a Work Center
    [Tags]                                       Machine
    [Setup]                                      Open my browser 
    Go to White Screen
    Login by Password Login successful
    Select Machine on the left sidebar
    Click on Create WC button
    Fill out all information to create a Work Center
    Click on Submit button on WC form
    Click on Edit Work Center button
    Update "Technology" with "China" on WC form
    Update "WorkCenterName" with "Auto_Update" on WC form
    Click on Submit button on WC form
    [Teardown]                                   Close browser

TC_004
    [Documentation]                              Verify can create a new Machine on Machine List page
    [Tags]                                       Machine
    [Setup]                                      Open my browser 
    Go to White Screen
    Login by Password Login successful
    Select Machine on the left sidebar
    Click on Create WC button
    Fill out all information to create a Work Center
    Click on Submit button on WC form
    Click on the Expand Icon to open Machine List page
    # [Teardown]                                   Close browser