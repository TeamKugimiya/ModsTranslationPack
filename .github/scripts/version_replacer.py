import os
import sys
import json
import subprocess
from pathlib import Path

def loadJsonFile(filePath: str):
    try:
        with open(filePath, "r", encoding="utf8") as f:
            data = json.load(f)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"讀取 JSON 檔案時發生錯誤: {e}")
        sys.exit(1)

def replace_text(file_path: Path, placeholder: str, replace_text: str):
    with open(file_path, "r") as file:
        file_content = file.read()
    
    updated_content = file_content.replace(placeholder, replace_text)

    with open(file_path, "w") as file:
        file.write(updated_content)

def get_git_sha():
    try:
        git_command = ["git", "rev-parse", "--short", "HEAD"]
        git_short_sha = subprocess.check_output(git_command).strip().decode("utf-8")
        return git_short_sha
    except subprocess.CalledProcessError:
        sys.exit(1)

def format_version(is_release: bool, version: str):
    release_color = "§b"
    beta_color = "§3"
    if is_release:
        return release_color + version
    else:
        return beta_color + f"git {version}"

def boolean_fixer(bool: str):
    if bool == "true":
        return True
    elif bool == "false":
        return False

def replace_pack_format(mc_version: str, config_path: Path, data_dict: dict):
    selected_version = None
    for version_info in data_dict["versions"]:
        if version_info["mc_version"] == mc_version:
            selected_version = version_info
            break

    if selected_version is not None:
        format_version = selected_version["pack_format"]
        print("資訊：")
        print("Minecraft 版本：", selected_version["mc_version"])
        print("資源包格式版本：", selected_version["pack_format"])

        replace_text(config_path, "${PACK_FORMAT_PLACEHOLDER}", format_version)
    else:
        print("::error:: 錯誤！版本未存在。")
        sys.exit(1)

def replace_pack_version(is_release: bool, release_version: str, config_path: Path):
    placeholder = "${VERSION_PLACEHOLDER}"
    git_sha = get_git_sha()
    if is_release:
        print(f"發布版本：{release_version}")
        replace_text(config_path, placeholder, format_version(True, release_version))
    else:
        print(f"測試版本：{git_sha}")
        replace_text(config_path, placeholder, format_version(False, git_sha))

def main(mc_version: str, is_release: bool, release_version: str):
    pack_config_path = Path("MultiVersions/configs/pack.mcmeta")
    json_data = loadJsonFile(".github/configs/versions.json")

    replace_pack_format(mc_version, pack_config_path, json_data)
    replace_pack_version(is_release, release_version, pack_config_path)

if __name__ == "__main__":
    mc_version = os.environ.get("matrix_version")
    release = boolean_fixer(os.environ.get("release"))
    release_version = os.environ.get("release_version")
    main(mc_version, release, release_version)
