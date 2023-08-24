import os
import sys
import json
import logging
from pathlib import Path

if os.environ.get("CI"):
    formatter = "%(levelname)s - %(message)s"
    logging.basicConfig(level=logging.INFO, format=formatter)
else:
    formatter = "%(levelname)s - %(message)s"
    logging.basicConfig(level=logging.INFO, format=formatter)

logger = logging.getLogger(__name__)

ERROR_MSG = "結構錯誤！"
LANG_ORIGINAL_FILES = ["en_us.json", "en_us.lang"]
LANG_TRANSLATE_FILES = ["zh_tw.json", "zh_tw.lang"]

def loadJsonFile(filePath: str):
    try:
        with open(filePath, "r", encoding="utf8") as f:
            data = json.load(f)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        logger.error(f"讀取 JSON 檔案時發生錯誤: {e}")
        return None

def log_error_exit(error_msg, path):
    logger.error(error_msg)
    logger.error(f"路徑：{path}")
    sys.exit(1)

def find_subfolders(root_folder):
    subfolders = []

    for dir in os.listdir(root_folder):
        dir_path = Path(root_folder, dir)
        if os.path.isdir(dir_path):
            subfolders.append(dir_path)

    return subfolders

def check_lang_exists(path):
    existing_files = set(os.listdir(path))
    original_files_exist = set(LANG_ORIGINAL_FILES) & existing_files
    translate_files_exist = set(LANG_TRANSLATE_FILES) & existing_files

    return len(original_files_exist) > 0 and len(translate_files_exist) > 0

def check_dir_has_data(dir):
    return any(os.scandir(dir))

def validate_language(subdir):
    if check_lang_exists(subdir):
        logger.debug("結構語言驗證通過。")
        logger.debug(f"路徑：{subdir}")
    else:
        log_error_exit(f"{ERROR_MSG}未包括正確語言檔案。", subdir)

def validate_manual(subdir):
    if check_dir_has_data(subdir):
        logger.debug("結構手冊驗證通過。")
        logger.debug(f"路徑：{subdir}")
    else:
        log_error_exit(f"{ERROR_MSG}手冊資料夾中未有任何資料！", subdir)

def verify_structure(dir):
    subfolders = find_subfolders(dir)

    if not subfolders:
        log_error_exit(f"{ERROR_MSG}未包含任何資料夾。", dir)

    for subdir in subfolders:
        subdir_name = subdir.name
        if "lang" in subdir_name:
            validate_language(subdir)
        elif "patchouli_books" in subdir_name:
            validate_manual(subdir)
        else:
            log_error_exit(f"{ERROR_MSG}資料夾下存在未被設定的結構。", subdir)

def verify_loop(platform, version):
    scan_path = Path("MultiVersions", platform, version)
    if not os.path.isdir(scan_path):
        logger.warning(f"警告！{scan_path} 資料夾路徑並不存在。")
        return

    subfolders = find_subfolders(scan_path)

    for dir in subfolders:
        verify_structure(dir)

def main(versions_dict):
    for platform in versions_dict["supported_platform"]:
        for version in versions_dict["versions"]:
            verify_loop(platform, version["dir_path"])

if __name__ == "__main__":
    versions_dict = loadJsonFile(".github/configs/versions.json")
    main(versions_dict)
