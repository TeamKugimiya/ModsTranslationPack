# pylint: disable=C0114
import os
import sys
import json
from pathlib import Path

# Message set list
MSG_INFO = set()
MSG_WARN = set()
MSG_ERROR = set()

# Message error count
ERROR_NUM = 0

def load_json(path: Path):
    """
    Load and return json data
    """
    try:
        with open(path, "r", encoding="utf8") as json_data:
            data = json.load(json_data)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as exc:
        print(f"讀取 JSON 檔案時發生錯誤: {exc}")
        return None

def log_message(msg: str, path: Path, msg_type: str):
    """
    A simple log function to add all message into their list

    Type list: INFO, WARN, ERROR
    """
    prefix_warn = "::warning::" if os.environ.get("CI") else ""
    prefix_error = "::error::" if os.environ.get("CI") else ""

    match msg_type:
        case "INFO":
            MSG_INFO.add(f"{msg} - {path}")
        case "WARN":
            MSG_WARN.add(f"{prefix_warn}{msg} - {path}")
        case "ERROR":
            MSG_ERROR.add(f"{prefix_error}{msg} - {path}")
            global ERROR_NUM # pylint: disable=W0603
            ERROR_NUM += 1
        case _:
            print("⚠️ 類型錯誤！")
            sys.exit(1)

def print_block(msg_list: set, group_title: str):
    """
    Print message with group (GitHub Action)
    """
    print(f"::group::{group_title}")
    for i in msg_list:
        print(i)
    print("::endgroup::")

def find_subfolders(root_folder: Path):
    """
    Find all subfolder and return list
    """
    subfolders = []

    for sub in root_folder.iterdir():
        if sub.is_dir():
            subfolders.append(sub)
        elif sub.is_file():
            log_message("📁 外部驗證｜存在不該存在的檔案或資料夾", sub, "ERROR")
        else:
            log_message("📁 外部驗證｜找不到任何檔案", sub, "ERROR")

    return subfolders

def check_lang_exists(path: Path):
    """
    Check folder list, and see the correct file
    """
    lang_original_files = ["en_us.json", "en_us.lang"]
    lang_translate_files = ["zh_tw.json", "zh_tw.lang"]
    existing_files = set(x.name for x in path.iterdir() if x.is_file())
    original_files_exist = set(lang_original_files) & existing_files
    translate_files_exist = set(lang_translate_files) & existing_files

    return len(original_files_exist) > 0 and len(translate_files_exist) > 0

def check_dir_has_data(path):
    """
    Return True if the folder has data
    """
    return any(os.scandir(path))

def validate_language(subdir):
    """
    Verify langauge is exist
    """
    if check_lang_exists(subdir):
        log_message("🌐 語言｜結構驗證通過", subdir, "INFO")
    else:
        log_message("🌐 語言｜結構驗證失敗（未包含 Json 翻譯檔）", subdir, "ERROR")

def validate_manual(subdir):
    """
    TODO need a better way to verify
    Using file size to check the dir is no empty
    """
    if check_dir_has_data(subdir):
        log_message("📖 手冊｜結構驗證通過", subdir, "INFO")
    else:
        log_message("📖 手冊｜結構驗證失敗（手冊資料夾無任何資料）", subdir, "ERROR")

def verify_structure(path):
    """
    Verify mods lang and patchouli dir
    """
    subfolders = find_subfolders(path)

    if not subfolders:
        log_message("🚧 結構｜不存在任何資料夾。", path, "ERROR")

    for subdir in subfolders:
        subdir_name = subdir.name
        if subdir_name == "lang":
            validate_language(subdir)
        elif subdir_name == "patchouli_books":
            validate_manual(subdir)
        elif subdir_name == "ae2guide":
            pass
        elif subdir_name == "guides":
            pass
        elif subdir_name == "books":
            pass
        elif subdir_name == "template_programs":
            pass
        else:
            log_message("🚧 結構｜資料夾下存在未被設定的結構。", subdir, "ERROR")

def verify_loop(platform, version):
    """
    Loop different platform and version
    """
    scan_path = Path("MultiVersions", platform, version)
    if not scan_path.is_dir():
        log_message("🚧 結構｜資料夾不存在", scan_path, "WARN")
        return

    subfolders = find_subfolders(scan_path)

    for sub in subfolders:
        verify_structure(sub)

def verify_clean(json_dict: dict):
    """
    Verify only json dict folder
    """
    path = Path("MultiVersions")
    platform = json_dict["supported_platform"]
    list_version = {version["dir_path"] for version in json_dict["versions"]}
    allowed_items = set(platform + ["configs", "Patcher", "README.md"])
    error_message = "📁 外部驗證｜存在不允許的檔案或資料夾"

    for item in path.iterdir():
        if item.name not in allowed_items:
            log_message(error_message, item, "ERROR")

        if item.name in platform:
            for sub_item in item.iterdir():
                if sub_item.name not in list_version:
                    log_message(error_message, sub_item, "ERROR")

if __name__ == "__main__":
    versions_dict = load_json(".github/configs/versions.json")
    verify_clean(versions_dict)

    for p in versions_dict["supported_platform"]:
        for v in versions_dict["versions"]:
            verify_loop(p, v["dir_path"])

    print_block(MSG_INFO, "資訊")
    print_block(MSG_WARN, "警告")
    print_block(MSG_ERROR, "錯誤")

    if ERROR_NUM > 0:
        sys.exit(1)
