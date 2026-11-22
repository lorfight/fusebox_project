import re

def read_file_to_string(file_path):
    with open(file_path, 'r') as file:
        return file.read()

def split_content_and_write_to_file(file_path):
    str_MSG = read_file_to_string(file_path)
    regex = re.compile(r"(?<=~)")
    split_content = "\n".join(regex.split(str_MSG))
    split_content += "~"
    with open(file_path, 'w') as f:
        f.write(split_content)

def remove_last_two_chars(file_path):
    with open(file_path, 'r+', encoding='utf-8') as file:
        content = file.read()
        file.seek(0)
        file.write(content[:-2])
        file.truncate()