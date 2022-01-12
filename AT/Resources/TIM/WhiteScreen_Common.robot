*** Settings ***
Library      SeleniumLibrary
Resource     ../../Locators/locators_import.robot
Variables    ../../TestData/${environment}_TestData.py

*** Keywords ***
Go to White Screen
    Go to    ${WhiteScreen}

Go to Dark Screen
    Go to    ${DarkScreen}

Get "${style}" style in "${locator}"
    Log                  ${locator}
    ${web_element}       Get WebElement       ${locator}
    ${value_of_style}    Call Method          ${web_element}    value_of_css_property    ${style}
    [Return]             ${value_of_style}

Style value should be
    [Arguments]           ${locator}                              ${style}       ${expected}
    ${value_of_style}=    Get "${style}" style in "${locator}"
    Should Be Equal       ${value_of_style}                       ${expected}

Verify style of each item on left sidebar
    Wait Until Element Is Visible    ${Common_Toogle_Sidebar_TopLeft}    5s
    Click Element                    ${Common_Toogle_Sidebar_TopLeft}
    Wait Until Element Is Visible    ${Common_Expand_Icon}               5s
    # Click Element                    ${Common_Expand_Icon}
    # ${items}=                        Get WebElement                      ${Common_Item_LeftSidebar}
    # FOR                              ${item}                             IN                            ${items}
    Style value should be            ${Common_Item_LeftSidebar}          height                        50px
    # END



