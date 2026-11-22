*** Settings ***
Resource    ../../../../../libraries/Util.resource

Library    ./Utils.py
Variables    ./Utils.py

*** Keywords ***
Scan List Barcode
    [Arguments]    ${list_barcode}    ${timeout}=10000
    ${orig_timeout}    Set Selenium Timeout    20 seconds
    Execute Async Javascript
    ...    var callback = arguments[arguments.length - 1]; var a = ${list_barcode}; scanProcessing = true; a.map(function(x, i){ queue.push(x); }); scanProcessing = false; ProcessQueue(); setTimeout(function() { callback(); }, ${timeout});
    Set Selenium Timeout    ${orig_timeout}

Random RS Barcode
    ${random_rs_barcode}    Evaluate    'RS' + ''.join(str(random.randint(0,9)) for _ in range(7))    random
    RETURN    ${random_rs_barcode}

Get Barcode With Random Serial Number
    [Arguments]    ${ndc_part}    ${lot_part}
    ${serial_number}    Evaluate    str(random.randint(1,9)) + ''.join(str(random.randint(0,9)) for _ in range(8))    random
    RETURN    ${ndc_part}${serial_number}${lot_part}