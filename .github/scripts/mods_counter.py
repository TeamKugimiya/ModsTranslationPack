import os
import sys
import json
from pathlib import Path

def loadJsonFile(filePath: str):
    try:
        with open(filePath, "r", encoding="utf8") as f:
            data = json.load(f)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"讀取 JSON 檔案時發生錯誤: {e}")
        sys.exit(1)

def list_subfolder(root_folder):
    subfolders = []

    for dir in os.listdir(root_folder):
        dir_path = Path(root_folder, dir)
        if os.path.isdir(dir_path):
            subfolders.append(dir)
    
    return subfolders

def main(versions_dict):
    mods = set()
    for platform in versions_dict["supported_platform"]:
        for version in versions_dict["versions"]:
            dir_path = Path("MultiVersions", platform, version["dir_path"])
            if os.path.isdir(dir_path):
                mods.update(list_subfolder(dir_path))

    # 移除 Sodium & Sodium Extra，這些來自 Crowdin
    mods.remove("sodium")
    mods.remove("sodium-extra")

    return len(mods)

if __name__ == "__main__":
    versions_dict = loadJsonFile(".github/configs/versions.json")
    mod_number = main(versions_dict)
    print(mod_number)
