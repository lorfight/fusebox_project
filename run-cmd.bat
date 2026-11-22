@echo off

setlocal

set "CONDA_ENV=fusebox"
set "PYTHON_SCRIPT=runner.py"
set "TEST_IDS=LG_100"
set "MAX_EXECUTION_TIME=30"
set "AZURE_TAG_NAME=test_local"
set "BACKUP_FILE=results\allure\index.html"

for /L %%i in (1,1,1) do (
    echo Running iteration %%i

    conda activate %CONDA_ENV%
    python %PYTHON_SCRIPT% -e dev --test-ids "%TEST_IDS%" --max-execution-time %MAX_EXECUTION_TIME% --azure-tag-name "%AZURE_TAG_NAME%"

    echo Backing up %BACKUP_FILE%
    if not exist %CD%\results\allure_history mkdir %CD%\results\allure_history
    set TIME=%TIME::=%
    copy %CD%\%BACKUP_FILE% %CD%\results\allure_history\%%i.html
    echo Full path of the backup file: %CD%\results\allure_history\%%i.html
)

endlocal