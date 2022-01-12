*** Settings ***
Library      SeleniumLibrary
Library      String
Resource     ../../Locators/locators_import.robot
Variables    ../../TestData/WhiteScreen_Machine_TestData.py

*** Keywords ***
Verify UI of Machine page
    Wait Until Element Is Visible    ${Machine_CreateWC_Btn}             30s
    ${Page_Title}=                   Get Text                            ${Machine_PageTitle_Lbl}
    Should Be Equal                  ${Page_Title}                       ${Machine_PageTitle_EN}                
    Wait Until Element Is Visible    ${Machine_DataTable}                30s
    Page Should Contain Element      ${Machine_CreateWC_Btn}
    ${create_WC_btn}=                Get Text                            ${Machine_CreateWC_Btn}
    Should Be Equal                  ${create_WC_btn}                    ${Machine_CreateForm_Title_EN}
    Page Should Contain Element      ${Machine_Header_Plant}
    ${header_plant}=                 Get Text                            ${Machine_Header_Plant}
    Should Be Equal                  ${header_plant}                     ${Machine_Header_Plant_EN}
    Page Should Contain Element      ${Machine_Header_Segment}
    ${header_segment}=               Get Text                            ${Machine_Header_Segment}
    Should Be Equal                  ${header_segment}                   ${Machine_Header_Segment_EN}
    Page Should Contain Element      ${Machine_Header_Technology}
    ${header_technology}=            Get Text                            ${Machine_Header_Technology}
    Should Be Equal                  ${header_technology}                ${Machine_Header_Technonogy_EN}
    Page Should Contain Element      ${Machine_Header_WorkCenterID}
    ${header_workcenterId}=          Get Text                            ${Machine_Header_WorkCenterID}
    Should Be Equal                  ${header_workcenterId}              ${Machine_Header_WorkCenterID_EN}
    Page Should Contain Element      ${Machine_Header_WorkCenterName}
    ${header_workcenterName}=        Get Text                            ${Machine_Header_WorkCenterName}
    Should Be Equal                  ${header_workcenterName}            ${Machine_Header_WorkCenterName_EN}
    Page Should Contain Element      ${Machine_Download_Btn}

Click on Create WC button
    Wait Until Element Is Visible    ${Machine_CreateWC_Btn}    10s
    Click Element                    ${Machine_CreateWC_Btn}

Verify the UI of Work Center creation form
    Wait Until Element Is Visible    ${Machine_CreateWC_Popup}           10s
    ${Form_Title}=                   Get Text                            ${Machine_CreateForm_Title}
    Should Be Equal                  ${Machine_CreateForm_Title_EN}      ${Form_Title}                     
    Page Should Contain Element      ${Machine_CreateForm_Txt}
    ${plant}=                        Get Element Attribute               (${Machine_CreateForm_Txt})[1]    formcontrolname
    Should Be Equal                  ${Machine_Plant_Txt_EN}             ${plant}
    Page Should Contain Element      ${Machine_CreateForm_Txt}
    ${segment}=                      Get Element Attribute               (${Machine_CreateForm_Txt})[2]    formcontrolname
    Should Be Equal                  ${Machine_Segment_Txt_EN}           ${segment}
    Page Should Contain Element      ${Machine_CreateForm_Txt}
    ${technology}=                   Get Element Attribute               (${Machine_CreateForm_Txt})[3]    formcontrolname
    Should Be Equal                  ${Machine_Technology_Txt_EN}        ${technology}
    Page Should Contain Element      ${Machine_CreateForm_Txt}
    ${workcenterId}=                 Get Element Attribute               (${Machine_CreateForm_Txt})[4]    formcontrolname
    Should Be Equal                  ${Machine_WorkcenterID_Txt_EN}      ${workcenterId}
    Page Should Contain Element      ${Machine_CreateForm_Txt}
    ${workcenterName}=               Get Element Attribute               (${Machine_CreateForm_Txt})[5]    formcontrolname
    Should Be Equal                  ${Machine_WorkcenterName_Txt_EN}    ${workcenterName}

Input "${field}" with "${value}" on WC form
    Wait Until Element Is Visible    ${Machine_CreateForm_${field}_Txt}    30s
    Input Text                       ${Machine_CreateForm_${field}_Txt}    ${value}

Click on Submit button on WC form
    Wait Until Element Is Visible    ${Machine_CreateForm_Submit_Btn}    30s
    Click Element                    ${Machine_CreateForm_Submit_Btn}

Fill out all information to create a Work Center
    Wait Until Element Is Visible    (${Machine_CreateForm_Txt})[1]              30s
    ${plant}                         Generate Random String                      4                0123456789
    Input Text                       ${Machine_CreateForm_Plant_Txt}             ${plant}
    ${segment}                       Generate Random String                      2                0123456789
    Input Text                       ${Machine_CreateForm_Segment_Txt}           ${segment}
    ${technology}                    Generate Random String                      32               abcdefghiklmnopqrstuvwyz
    Input Text                       ${Machine_CreateForm_Technology_Txt}        ${technology}
    ${WC_ID}                         Generate Random String                      30               ABCDEFGHIKLMNOPQRSTUVWYZ
    Input Text                       ${Machine_CreateForm_WorkCenterID_Txt}      ${WC_ID}
    ${WC_Name}                       Generate Random String                      50               abcdefghiklmnopqrstuvwyz
    Input Text                       ${Machine_CreateForm_WorkCenterName_Txt}    ${WC_Name}

Click on Edit Work Center button
    Wait Until Element Is Visible    ${Machine_Edit_Button}    30s
    Click Element                    ${Machine_Edit_Button}

Update "${field}" with "${value}" on WC form
    Wait Until Element Is Visible    ${Machine_CreateForm_Submit_Btn}      30s
    Press Keys                       ${Machine_CreateForm_${field}_Txt}    CTRL+a      DEL
    Input Text                       ${Machine_CreateForm_${field}_Txt}    ${value}

Click on the Expand Icon to open Machine List page
    Wait Until Element Is Visible    ${Machine_Expand_MachineList_Btn}    30s
    Click Element                    ${Machine_Expand_MachineList_Btn}

Click on Create Machine button
    Wait Until Element Is Visible    ${MachineList_CreateMachine_Btn}    10s
    Click Element                    ${MachineList_CreateMachine_Btn}

Verify the UI of Machine creation form
    Wait Until Element Is Visible    ${MachineList_CreateMachine_Btn}    30s
    




