*** Settings ***
Library      SeleniumLibrary
Resource     ../../Locators/locators_import.robot
Variables    ../../TestData/WhiteScreen_PasswordLogin_TestData.py
Variables    ../../TestData/${environment}_TestData.py

*** Variables ***
${environment}    Development

*** Keywords ***
Go to White Screen
    Go to    ${WhiteScreen}

Go to Dark Screen
    Go to    ${DarkScreen}

Select Password Login option
    Wait Until Element Is Visible    ${WhiteScreen_Password_Login}    30s
    Click Element                    ${WhiteScreen_Password_Login}

Input "${Username}" and "${Password}" then login
    Input Text                       ${WhiteScreen_Password_Login_Username}     ${Username}    
    Input Password                   ${WhiteScreen_Password_Login_Password}     ${Password}
    Wait Until Element Is Visible    ${WhiteScreen_Password_Login_Login_Btn}    10s
    Click Element                    ${WhiteScreen_Password_Login_Login_Btn}

Verify the message when login to White Screen successful
    Wait Until Element Is Visible    ${WhiteScreen_Password_Login_Success_Msg}    30s
    ${Msg}=                          Get Text                                     ${WhiteScreen_Password_Login_Success_Msg}    
    Should Be Equal                  ${Msg}                                       ${WSLogin_Successful_Msg_EN}

Login by Password Login successful
    Select Password Login option
    Input "${Username1}" and "${Password1}" then login
    Verify the message when login to White Screen successful



