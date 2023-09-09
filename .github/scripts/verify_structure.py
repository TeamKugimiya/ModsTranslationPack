# pylint: disable=C0114
import os
import sys
import json
from pathlib import Path

ERROR_MSG = "結構錯誤！"
ERROR_NUM = 0
LANG_ORIGINAL_FILES = ["en_us.json", "en_us.lang"]
LANG_TRANSLATE_FILES = ["zh_tw.json", "zh_tw.lang"]
PREFIX_ERROR = "::error::" if os.environ.get("CI") else ""
PREFIX_WARNING = "::warning::" if os.environ.get("CI") else ""

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

def log_warning(warning_msg, path):
    """
    Log warning message and path
    """
    print(PREFIX_WARNING + warning_msg)
    print(f"路徑：{path}")

def log_error(error_msg, path):
    """
    Log error message and path
    Add error count
    """
    print(PREFIX_ERROR + error_msg)
    print(f"路徑：{path}")
    global ERROR_NUM # pylint: disable=W0603
    ERROR_NUM += 1

def find_subfolders(root_folder: Path):
    """
    Find all subfolder and return list
    """
    subfolders = []

    for sub in root_folder.iterdir():
        if sub.is_dir():
            subfolders.append(sub)
        elif sub.is_file():
            log_error("警告，資料夾搜尋到不該存在的檔案！", sub)
        else:
            log_error("錯誤！", sub)

    return subfolders

def check_lang_exists(path: Path):
    """
    Check folder list, and see the correct file
    """
    existing_files = set(x.name for x in path.iterdir() if x.is_file())
    original_files_exist = set(LANG_ORIGINAL_FILES) & existing_files
    translate_files_exist = set(LANG_TRANSLATE_FILES) & existing_files

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
        print("結構語言驗證通過。")
        print(f"路徑：{subdir}")
    else:
        log_error(f"{ERROR_MSG}未包括正確語言檔案。", subdir)

def validate_manual(subdir):
    """
    TODO need a better way to verify
    Using file size to check the dir is no empty
    """
    if check_dir_has_data(subdir):
        print("結構手冊驗證通過。")
        print(f"路徑：{subdir}")
    else:
        log_error(f"{ERROR_MSG}手冊資料夾中未有任何資料！", subdir)

def verify_structure(path):
    """
    Verify mods lang and patchouli dir
    """
    subfolders = find_subfolders(path)

    if not subfolders:
        log_error(f"{ERROR_MSG}未包含任何資料夾。", path)

    for subdir in subfolders:
        subdir_name = subdir.name
        if subdir_name == "lang":
            validate_language(subdir)
        elif subdir_name == "patchouli_books":
            validate_manual(subdir)
        else:
            log_error(f"{ERROR_MSG}資料夾下存在未被設定的結構。", subdir)

def verify_loop(platform, version):
    """
    Loop different platform and version
    """
    scan_path = Path("MultiVersions", platform, version)
    if not scan_path.is_dir():
        log_warning("警告！資料夾路徑並不存在。", scan_path)
        return

    subfolders = find_subfolders(scan_path)

    for sub in subfolders:
        verify_structure(sub)

def verify_clean(json_dict: dict):
    """
    Verify only json dict folder
    """
    path = Path("MultiVersions")
    platform = list(json_dict["supported_platform"])
    list_version = [version["dir_path"] for version in json_dict["versions"]]
    platform_check = list(json_dict["supported_platform"])
    extra = ["configs", "Patcher", "README.md"]
    platform_check.extend(extra)

    multiversion_list = path.iterdir()

    for i in multiversion_list:
        folder_name = i.name
        if folder_name not in platform_check:
            log_error("錯誤，有未允許的檔案或資料夾存在！", i)
    for i in platform:
        mutli_list = path.joinpath(i).iterdir()

        for i in mutli_list:
            if i.name not in list_version:
                log_error("錯誤，有未允許的檔案或資料夾存在！", i)

if __name__ == "__main__":
    versions_dict = load_json(".github/configs/versions.json")
    verify_clean(versions_dict)
    for p in versions_dict["supported_platform"]:
        for v in versions_dict["versions"]:
            verify_loop(p, v["dir_path"])

    if ERROR_NUM > 0:
        print("警告：錯誤")
        sys.exit(1)
