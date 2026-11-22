from openpyxl import Workbook
import os
import random
import string
import shutil
from datetime import datetime

def random_text(size=3000):
    return ''.join(
        random.choices(string.ascii_letters + string.digits, k=size)
    )

def create_dummy_binary_file(file_path, target_size_mb):
    with open(file_path, "wb") as f:
        f.write(os.urandom(target_size_mb * 1024 * 1024))


def create_dummy_text_file(file_path, target_size_mb):
    target_bytes = target_size_mb * 1024 * 1024
    written = 0

    with open(file_path, "w", encoding="utf-8") as f:
        while written < target_bytes:
            line = random_text(3000) + "\n"
            f.write(line)
            written += len(line.encode("utf-8"))

def create_xlsx_file(file_path, target_size_mb):
    cols = 5
    bytes_per_row = 2048 * cols
    rows = int((target_size_mb * 1024 * 1024) / bytes_per_row)

    wb = Workbook(write_only=True)
    ws = wb.create_sheet("Data")

    for _ in range(rows):
        ws.append([random_text() for _ in range(cols)])

    wb.save(file_path)

def create_files(
    parent_dir,
    file_type,
    file_count=1,
    target_size_mb=16
):
    output_dir = os.path.join(parent_dir, "datafee_folder")
    if not os.path.exists(output_dir):
        raise FileNotFoundError(f"Folder not found: {output_dir}")

    created_file_paths = []
    file_names = []

    time_prefix = datetime.now().strftime("%d%m_%H%M")

    def build_file_name(index: int):
        if file_type == "no_extension":
            return f"{time_prefix}_file_no_extension_{index}"
        return f"{time_prefix}_file_{file_type}_{index}.{file_type}"

    base_file_name = build_file_name(1)
    base_file_path = os.path.join(output_dir, base_file_name)

    if file_type == "xlsx":
        create_xlsx_file(base_file_path, target_size_mb)

    elif file_type == "csv":
        create_dummy_text_file(base_file_path, target_size_mb)

    elif file_type in ["xls", "pdf", "docx", "no_extension"]:
        create_dummy_binary_file(base_file_path, target_size_mb)

    else:
        raise ValueError(f"Unsupported file type: {file_type}")

    created_file_paths.append(base_file_path)
    file_names.append(base_file_name)

    size_mb = os.path.getsize(base_file_path) / (1024 * 1024)
    print(f"Created base file: {base_file_path} | Size: {size_mb:.2f} MB")

    for i in range(2, file_count + 1):
        file_name = build_file_name(i)
        target_path = os.path.join(output_dir, file_name)
        shutil.copy(base_file_path, target_path)
        created_file_paths.append(target_path)
        file_names.append(file_name)

    return created_file_paths, file_names