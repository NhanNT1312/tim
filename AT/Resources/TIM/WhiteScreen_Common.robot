*** Settings ***
Library      SeleniumLibrary
Resource     ../../Locators/locators_import.robot
Variables    ../../TestData/${environment}_TestData.py

*** Variables ***
${environment}    Development

*** Keywords ***
Get "${style}" style in "${locator}"
    Log                  ${locator}
    ${web_element}       Get WebElement       ${locator}
    ${value_of_style}    Call Method          ${web_element}    value_of_css_property    ${style}
    [Return]             ${value_of_style}

Style value should be
    [Arguments]           ${locator}                              ${style}       ${expected}
    ${value_of_style}=    Get "${style}" style in "${locator}"
    Should Be Equal       ${value_of_style}                       ${expected}





