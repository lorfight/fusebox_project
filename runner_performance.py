import subprocess
import time
import os
import argparse
import json
import csv
import shutil
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import glob
import signal
path_cur_dir = os.getcwd()
results_dir = os.path.join(f'{path_cur_dir}','results')
output_dir = os.path.join(results_dir, 'report')

def summery_csv_file(file_csv):
    files = glob.glob(os.path.join(results_dir,"export","*.csv"))
    df_list = []
    for file in files:
        df = pd.read_csv(file)
        df_list.append(df)
    final_df = pd.concat(df_list,ignore_index=True)
    final_df.to_csv(file_csv,index=False)
    
def load_json(file_path):
    try:
        with open(file_path) as f:
            return json.load(f)
    except Exception as e:
        print(f'Failed to load {file_path}. Error: {e}')
        return {}

def get_config(config_env):
    config_path = f'{path_cur_dir}/configs/site/{config_env}.json'
    print("Config path: ", config_path)
    return  load_json(config_path)

def remove_and_create_dir(directory):
    shutil.rmtree(directory, ignore_errors=True)
    os.makedirs(directory, exist_ok=True)
    
def init_and_clean_up_directories(result_folders, results_dir):
    try:
        for folder in result_folders:
            remove_and_create_dir(os.path.join(results_dir, folder))
    except Exception as e:
        print(f'Failed to init and clean up directories. Error: {e}')
        
def set_runtime_variables(configs):
    for key, value in configs.items():
        if type(value) == dict:
            for key2, value2 in value.items():
                print(f"Set Runtime Variable: {key.upper()}_{key2.upper()}")
                os.environ[f"{key.upper()}_{key2.upper()}"] = str(value2)
        else:
            print(f"Set Runtime Variable: {key.upper()}")
            os.environ[key.upper()] = str(value)
    return
def parse_data(file_csv):
    # ===== LOAD DATA =====
    df = pd.read_csv(file_csv)

    df["timestamp"] = pd.to_datetime(df["timestamp"])
    df["duration"] = pd.to_numeric(df["duration"], errors="coerce")
    df = df.dropna()

    df = df.sort_values("timestamp")

    # ===== METRICS =====
    metrics = df.groupby(["endpoint", "method"])["duration"].agg([
        "count", "min", "max", "mean"
    ])

    metrics["p95"] = df.groupby(["endpoint", "method"])["duration"].quantile(0.95)
    metrics["p99"] = df.groupby(["endpoint", "method"])["duration"].quantile(0.99)

    print("\n=== METRICS ===\n")
    print(metrics)
    with open(os.path.join(results_dir,"metrics","metrics.txt"), "w", encoding="utf-8") as f:
        f.write(str(metrics))

    # ===== 1. RESPONSE TIME OVER TIME =====
    plt.figure()
    for (endpoint, method), group in df.groupby(["endpoint", "method"]):
        label = f"{method} {endpoint}"
        plt.plot(group["timestamp"], group["duration"], label=label)

    plt.title("Response Time Over Time")
    plt.xlabel("Time")
    plt.ylabel("ms")
    plt.legend()
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(os.path.join(results_dir,"metrics","response_time.png"))
    plt.close()

    # ===== 2. DISTRIBUTION =====
    plt.figure()
    df["duration"].hist(bins=20)
    plt.title("Response Time Distribution")
    plt.xlabel("ms")
    plt.ylabel("count")
    plt.tight_layout()
    plt.savefig(os.path.join(results_dir,"metrics","distribution.png"))
    plt.close()

    # ===== 3. PERCENTILES =====
    percentiles = df.groupby(["endpoint", "method"])["duration"] \
        .quantile([0.5, 0.9, 0.95, 0.99]).unstack()

    percentiles.columns = ["p50","p90","p95","p99"]
    percentiles.index = [
        f"{endpoint} ({method})"
        for endpoint, method in percentiles.index
    ]
    percentiles = percentiles.sort_values(by="p95", ascending=False)
    percentiles.plot(kind='bar')
    plt.title("Percentiles")
    plt.ylabel("ms")
    plt.xticks(rotation=45, ha="right")
    plt.tight_layout()
    plt.savefig(os.path.join(results_dir,"metrics","percentiles.png"))
    plt.close() 
    
    # ===== 4. THROUGHPUT =====
    df.set_index("timestamp", inplace=True)

    throughput = df.groupby(["endpoint", "method"]) \
        .resample("1min") \
        .size() \
        .unstack([0,1])

    throughput.plot()
    plt.title("Throughput (req/min)")
    plt.ylabel("count")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(os.path.join(results_dir,"metrics","throughput.png"))
    plt.close() 

    
def main():
    parser = argparse.ArgumentParser(description='A program that reads input file and writes output file.')
    parser.add_argument('-e', type=str, help='<environment>')
    parser.add_argument('--num_vu', type=int, help='<environment>')
    parser.add_argument('--ramp_up_total_sec', type=int, help='<environment>')
    parser.add_argument('--duration_sec', type=int, help='<environment>')
    parser.add_argument('-s', type=str, help='<strategy>')
    parser.add_argument('-i', type=str, help='<Tags>')
    
    
    
    args = parser.parse_args()
    config_env = args.e
    num_vu = args.num_vu
    ramp_up_total_sec = args.ramp_up_total_sec
    duration_sec = args.duration_sec
    strategy = args.s
    test_include = args.i
    configs = get_config(config_env)
    set_runtime_variables(configs)
    result_folders = ['robotframework', 'report', 'report_archive', 'temp_report', 'history','export', 'metrics']
    init_and_clean_up_directories(result_folders, results_dir)
    
    with open(f'{path_cur_dir}/configs/type/performance.json') as f:
        list_robots = json.load(f)
        robot_path = os.path.join(path_cur_dir,'tests',list_robots[strategy])
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
        
    users_data = []
    with open(f'{path_cur_dir}/resources/PageObjects/TestData/user/user.{config_env}.csv', mode='r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            users_data.append(row)
        
    interval = ramp_up_total_sec / num_vu
    processes = []
    print("robot_path :" + robot_path)
    
    for i in range(num_vu):
        current_user = users_data[i]['username']
        current_pass = users_data[i]['password']
        
        p = subprocess.Popen([
            "python", "-m", "robot",
            f"-i {test_include}",
            "--variable", f"USERNAME:{current_user}",
            "--variable", f"PASSWORD:{current_pass}",
            "--outputdir", "results/robotframework",
            "--output", f"out_{current_user}.xml",
            f"{robot_path}"
            ],creationflags=subprocess.CREATE_NEW_PROCESS_GROUP)
        processes.append(p)
        if i < num_vu - 1:
            time.sleep(interval)
    # ===== RUN FOR DURATION =====
    print(f"Running for {duration_sec} seconds...")
    time.sleep(duration_sec)
    

    # ===== KILL ALL =====
    print("Stopping all processes...")
    for p in processes:
        try:
            os.kill(p.pid,signal.CTRL_BREAK_EVENT)
        except Exception as e:
            print(f"error stopping process: {e}")
            
    time.sleep(5)
    for p in processes:
        if p.poll is None:
            subprocess.call(f"taskkill /F /T /PID {p.pid}", shell= True)
    for p in processes:
        try:
            p.wait(TimeoutError=10)
        except:
            pass
        
    print("All processes stopped. Start merging/report...")
    final_file_csv = os.path.join(results_dir,"export","perf_results.csv")
    summery_csv_file(final_file_csv)
    parse_data(final_file_csv)
    

if __name__ == '__main__':
    main()