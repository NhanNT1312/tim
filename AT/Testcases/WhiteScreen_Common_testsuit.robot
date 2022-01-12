*** Settings ***
Default Tags    Activity
Library         SeleniumLibrary
Resource        ../Resources/resources_import.robot


*** Test Cases ***
TC_001
    [Documentation]                              Verify css style of TIM application
    [Tags]                                       Common
    [Setup]                                      Open my browser 
    Go to White Screen
    Style value should be                        ${Common_Logo_TopRight}                width               200px
    Style value should be                        ${Common_Top_NavigationBar}            height              60px
    Verify style of each item on left sidebar
    Style value should be                        ${Common_Background_Application}       background-color    rgba(221, 227, 230, 1)   #dde3e6
    # [Teardown]                                   Close browser