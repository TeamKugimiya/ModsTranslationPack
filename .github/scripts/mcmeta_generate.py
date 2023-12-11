"""Simple Generate pack.mcmeta file script"""
import os
import sys
import json
import subprocess
from pathlib import Path

# Constant
DESCRIPTION = [ "§f模組翻譯包｜版本 ", "\n§3感謝所有參與專案的貢獻者！" ]

def load_json_file(path: Path):
    """
    Load json file from path
    """
    try:
        with open(path, "r", encoding="utf8") as json_file:
            data = json.load(json_file)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as ex:
        print(f"讀取 JSON 檔案時發生錯誤: {ex}")
        sys.exit(1)

def get_git_sha():
    """
    Get current commit git sha (short)
    """
    try:
        git_command = ["git", "rev-parse", "--short", "HEAD"]
        git_short_sha = subprocess.check_output(git_command).strip().decode("utf-8")
        return git_short_sha
    except subprocess.CalledProcessError:
        sys.exit(1)

def format_version(is_release: bool, version: str):
    """
    Format with minecraft color code
    """
    release_color = "§b"
    beta_color = "§a"
    if is_release:
        return release_color + version
    else:
        return beta_color + f"git {version}"

def boolean_fixer(boolean: str):
    """
    Fix github using small T and F
    """
    if boolean == "true":
        return True

    return False

def generate_mcmeta(mc_version: str, config_path: Path, data_dict: dict, is_release: bool, version: str):
    """
    Generate pack.mcmeta into configs
    """

    def pack_mcmeta_format(format_ver: int, desc_ver: str, support_format_min: int, support_format_max: int):
        """
        Generate mcmeta json
        """
        pack_mcmeta_json = {
            "pack" : {
                "pack_format": format_ver,
                "description": [
                    DESCRIPTION[0] + desc_ver,
                    DESCRIPTION[1]
                ],
                "supported_formats": {
                    "min_inclusive": support_format_min,
                    "max_inclusive": support_format_max
                }
            }
        }

        return pack_mcmeta_json

    selected_version = None
    for version_info in data_dict["versions"]:
        if version_info["mc_version"] == mc_version:
            selected_version = version_info
            break

    if selected_version is not None:
        git_sha = get_git_sha()
        pack_format = selected_version["pack_format"]
        supported_format_min = selected_version["supported_formats"]["min"]
        supported_format_max = selected_version["supported_formats"]["max"]
        version_desc = "發布版本" if is_release else "測試版本"
        version_input = version if is_release else git_sha

        print("資訊：")
        print("Minecraft 版本：", selected_version["mc_version"])
        print("資源包格式版本：", selected_version["pack_format"])
        print(f"資源包格式多版本：最低 {supported_format_min}、最高 {supported_format_max}")
        print(f"{version_desc}：{version_input}")

        pack_mcmeta_json_data = pack_mcmeta_format(pack_format, format_version(is_release, version_input), supported_format_min, supported_format_max)

        with config_path.open("w") as file:
            json.dump(pack_mcmeta_json_data, file, ensure_ascii=False)
    else:
        print("::error:: 錯誤！版本未存在。")
        sys.exit(1)

if __name__ == "__main__":
    mc_version_matrix = os.environ.get("matrix_version")
    release_boolean = boolean_fixer(os.environ.get("release"))
    release_version = os.environ.get("release_version")
    pack_config_path = Path("MultiVersions/configs/pack.mcmeta")
    json_data = load_json_file(".github/configs/versions.json")

    generate_mcmeta(mc_version_matrix, pack_config_path, json_data, release_boolean, release_version)
