# encoding=utf16
# -*- coding: utf-16 -*-
*** Settings ***
Library      SeleniumLibrary
Variables    ../TestData/${environment}_TestData.py

*** Variables ***
${DefaultBrowser}    'Chrome'
# Chrome browser:    'Chrome'     
# IE 11 browser:     'IE'
# Edge Chromimum     'Edge'         (ver 86.0.622.63)
${environment}    Development 

*** Keywords ***
Open my browser
    [Arguments]    ${incognito}=False

    Run Keyword If    ${incognito}    Start Incognito Browser
    ...               ELSE            Start Browser

Start Browser
    Run Keyword If    ${DefaultBrowser} == 'Edge'    Open Edge Browser                 
    ...               ELSE IF                        ${DefaultBrowser} == 'Firefox'    Open Firefox Browser
    ...               ELSE IF                        ${DefaultBrowser} == 'IE'         Open IE Browser
    ...               ELSE                           Open Chrome Browser

Start Incognito Browser
    Run Keyword If    ${DefaultBrowser} == 'Edge'    Open Edge Browser
    ...               ELSE IF                        ${DefaultBrowser} == 'Firefox'    Open Firefox Browser
    ...               ELSE IF                        ${DefaultBrowser} == 'IE'         Open IE Browser
    ...               ELSE                           Open Chrome Incognito Browser

Open Chrome Browser
    Set Global Variable                 ${DOWNLOAD_DIRECTORY}    ${CURDIR}\\..\\Download
    Set Global Variable                 ${DRIVER_DIRECTORY}      ${CURDIR}\\..\\Download

    ${prefs}                            Create Dictionary        download.default_directory=${DOWNLOAD_DIRECTORY}
    #
    ${chrome_options} =                 Evaluate                 sys.modules['selenium.webdriver'].ChromeOptions()    sys
    #Call Method    ${chrome_options}    add_argument    test-type
    #Call Method    ${chrome_options}    add_argument    ignore-certificate-errors
    #Call Method    ${chrome_options}    add_argument    --disable-extensions
    #Call Method    ${chrome_options}    add_argument    --headless
    #Call Method    ${chrome_options}    add_argument    --disable-gpu
    #Call Method    ${chrome_options}    add_argument    --no-sandbox
    #Call Method    ${chrome_options}    add_argument    --disable-dev-shm-usage
    #Call Method    ${chrome_options}    add_argument    --window-size=1336,768
    #Call Method    ${chrome_options}    add_argument    --proxy-server=http://hcm-proxy:9090
    # Call Method                         ${chrome_options}        add_argument                                         headless
    Call Method                         ${chrome_options}        add_argument                                         --disable-notifications
    Call Method                         ${chrome_options}        add_argument                                         --lang\=en
    Call Method                         ${chrome_options}        add_experimental_option                              prefs                      ${prefs}
    Log                                 ${chrome_options}
    ${system}                           Evaluate                 sys.platform                                         sys
    # for windows
    ${driver_path}                      Set Variable             ${DRIVER_DIRECTORY}\\Webdrivers\\chromedriver.exe
    ${kwargs}                           Create Dictionary        executable_path=${driver_path}
    SeleniumLibrary.Create Webdriver    Chrome                   chrome_options=${chrome_options}                     kwargs=${kwargs}
    Set Window Size                     1336                     768
    Maximize Browser Window

Open Chrome Incognito Browser
    Set Global Variable                 ${DOWNLOAD_DIRECTORY}    ${CURDIR}\\..\\Download
    Set Global Variable                 ${DRIVER_DIRECTORY}      ${CURDIR}\\..\\Download
    ${prefs}                            Create Dictionary        download.default_directory=${DOWNLOAD_DIRECTORY}
    #
    ${chrome_options} =                 Evaluate                 sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method                         ${chrome_options}        add_argument                                         --disable-extensions
    Call Method                         ${chrome_options}        add_argument                                         --disable-notifications
    Call Method                         ${chrome_options}        add_argument                                         --incognito
    Call Method                         ${chrome_options}        add_experimental_option                              prefs                      ${prefs}
    ${system}                           Evaluate                 sys.platform                                         sys
    # for windows
    ${driver_path}                      Set Variable             ${DRIVER_DIRECTORY}\\Webdrivers\\chromedriver.exe
    ${kwargs}                           Create Dictionary        executable_path=${driver_path}

    SeleniumLibrary.Create Webdriver    Chrome                   chrome_options=${chrome_options}                     kwargs=${kwargs}
    Set Window Size                     1336                     768
    Maximize Browser Window

Open IE browser
    Set Global Variable    ${DOWNLOAD_DIRECTORY}    ${CURDIR}\\..\\Download
    Set Global Variable    ${DRIVER_DIRECTORY}      ${CURDIR}\\..\\Download
    ${prefs}               Create Dictionary        download.default_directory=${DOWNLOAD_DIRECTORY}
    #
    # ${ie_options} =        Evaluate                 sys.modules['selenium.webdriver'].DesiredCapabilities.INTERNETEXPLORER    sys,selenium.webdriver
    # Set To Dictionary      ${ie_options}            ignoreProtectedModeSettings                                               ${True}
    # Set To Dictionary      ${ie_options}            unhandledPromptBehavior                                                   ignore
    # Set To Dictionary      ${ie_options}            unexpectedAlertBehaviour                                                  ignore
    ${driver_path}    Set Variable         ${DRIVER_DIRECTORY}\\Webdrivers\\IEDriverServer.exe
    ${kwargs}         Create Dictionary    executable_path=${driver_path}
    SeleniumLibrary.Create Webdriver    Ie      kwargs=${kwargs}    
    Set Window Size                     1336    768                 
    Maximize Browser Window

Open Edge Browser
    Set Global Variable                 ${DOWNLOAD_DIRECTORY}    ${CURDIR}\\..\\Download
    Set Global Variable                 ${DRIVER_DIRECTORY}      ${CURDIR}\\..\\Download

    ${driver_path}                      Set Variable             ${DRIVER_DIRECTORY}\\Webdrivers\\msedgedriver.exe
    ${kwargs}                           Create Dictionary        executable_path=${driver_path}

    SeleniumLibrary.Create Webdriver    Edge                     kwargs=${kwargs}
    Set Window Size                     1336                     768
    Maximize Browser Window


