*** Settings ***
Library      SeleniumLibrary
Resource     ../../Locators/locators_import.robot
Variables    ../../TestData/${environment}_TestData.py

*** Variables ***
${environment}    Development