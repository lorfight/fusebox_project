# Introduction 
This project focus to build and manage all automation test scripts for Fusebox project.

# Tech Stack
- Python 3.7 (or higher)
- Conda
- Selenium (latest version)
- Robot Framework (latest version)
- Pytest
- Allure Report
- Jenkins
- Docker
- Azure Pipelines
- Azure Blob Storage

# Project Structure
```angular2html
Fusebox's Automation Testing Project/
│
├── configs/                       # Environment and configuration files
│   ├── dev.json                   # Development environment configurations
│   ├── staging.json               # Staging environment configurations
│   ├── prod.json                  # Production environment configurations
│   └── qa.json                    # QA environment configurations
│
├── resources/                     # Resources and keywords
│   ├── Common.resource            # Common keywords and variables
│   ├── LoginPage.resource         # Keywords specific to the Login page
│   └── UserPage.resource          # Keywords specific to the User page
│
├── tests/                         # Test cases
│   ├── module1/                   # Module 1 tests
│   │   ├── test_flow1.robot       # Test flow 1 for Module 1
│   │   └── test_flow2.robot       # Test flow 2 for Module 1
│   ├── module2/                   # Module 2 tests
│   │   ├── test_flow1.robot       # Test flow 1 for Module 2
│   │   └── test_flow2.robot       # Test flow 2 for Module 2
│   └── ...
│
├── results/                       # Test results (ignored by VCS)
│
├── libraries/                     # Custom libraries
│   ├── CustomLibrary.py
│   └── ...
│
├── static/                        # Static files like images, drivers, etc.
│   ├── images/                    # Image files used in tests
│   │   ├── logo.png
│   │   └── ...
│   ├── drivers/                   # Selenium drivers
│   │   ├── chromedriver.exe       # Chrome driver
│   │   └── ...
│   └── ...
│
├── Dockerfile                     # Dockerfile for containerizing the application
│
├── azure-pipelines.yaml           # Azure Pipelines configuration file
│
├── requirements.txt               # Project dependencies
│
└── README.md                      # Project documentation

```

# Development & Delivery Flow

1. Checkout `topic branch` from `main` branch and write test cases in Robot Framework syntax. You can add common keywords in `resources/Common.resource` file.

    ```bash
    git checkout -b <topic-branch>
    git add .
    git commit -m "<commit-message>"
    git push origin <topic-branch>
    ```
    
2. Create your profile in `profiles` dir. Profile name should be your name. For example: `profiles/<your-name>.json`. Update config values in your profile.
3. Run your test cases with your profile by following command:

Note: If use `conda` to manage package set variable in `configs/${env}.json`:
```bash
  "bool_robot_env": true,
``` 
create and activate env:
```bash
 conda create --name fusebox pytorch
 conda activate fusebox
```
else: 
```bash
  "bool_robot_env": false,
``` 
then run:
```bash
    python runner.py -e <profile-name> -b <browser> -t <tag> -r <report>
```
With:
- `<profile-name>`: Environment to run test cases. Available values: `dev`, `staging`, `prod`, `qa`.
- `<browser>`: Browser to run test cases. Available values: `chrome`, `firefox`, `edge`.
- `<tag>`: Tag to group test cases. For example: `PROD_AT_Fusebox_1.0.0`.
- `<report>`: Report type. Available values: `allure`, `robot`, `none`.

1. After running test cases, you can see the test results in `results` directory. You can also see the test report in `results/report.html` file.
2. Commit your changes and push to remote repository.
3. Create a pull request and assign it to your team leader for review.
4. After your team leader approved your pull request, merge it to `main` branch.
5. Tag your commit with the format: `<environment>_AT_<product>_<version>`. For example: `PROD_AT_Fusebox_1.0.0`.
6. The pipeline will be triggered automatically and run all test cases in `main` branch.
7.  Report will be uploaded to Azure Blob Storage and you can see it in `https://fusebox.blob.core.windows.net/reports/<tag>/report.html` URL.