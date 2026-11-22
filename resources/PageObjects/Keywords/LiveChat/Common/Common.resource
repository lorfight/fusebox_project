*** Settings ***
Library    Browser    timeout=30s    run_on_failure=Take Screenshot Embed    
Library    ../../Layers/Fakedata/FakeData.py
Library    Collections
Library    DateTime

*** Keywords ***
Take Screenshot Embed
    Take Screen Shot    fullPage=${True}    filename=EMBED