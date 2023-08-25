import os
import sys

def insert_content(file_path: str, multiline_mode: bool, start_tag: str, end_tag: str, content_insert: str):  # noqa: E501
    with open(file_path, "r") as file:
        file_contents = file.read()
    
    start_index = file_contents.find(start_tag)
    end_index = file_contents.find(end_tag)

    if start_index == -1 or end_tag == -1:
        print("未找到 Tags")
        sys.exit(1)

    if multiline_mode:
        updated_contents = (
            file_contents[:start_index + len(start_tag)] +
            "\n" +
            content_insert +
            "\n" +
            file_contents[end_index:]
        )
    else:
        updated_contents = (
            file_contents[:start_index + len(start_tag)] +
            content_insert +
            file_contents[end_index:]
        )

    with open(file_path, "w") as file:
        file.write(updated_contents)

def main():
    file_path = os.environ.get("FILE_PATH")
    multiline_mode = os.environ.get("MULTILINE_MODE", False)
    start_tag = os.environ.get("START_TAG")
    end_tag = os.environ.get("END_TAG")
    content = os.environ.get("CONTENT")
    envs = [file_path, start_tag, end_tag, content]

    if all(envs):
        insert_content(file_path, multiline_mode, start_tag, end_tag, content)
    else:
        print("錯誤，有環境變數未存在！")
        sys.exit(1)

if __name__ == "__main__":
    main()
