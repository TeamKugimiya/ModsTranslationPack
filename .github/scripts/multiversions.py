"""
Pack Core - MultiVersions Mixer

This script will auto mixup different platform and version mods lang
"""
import shutil
from pathlib import Path
from jsonmerge import merge
# import json

RESOURCEPACK_PATH = Path("pack/assets")

def check_legacy_langfile(path: Path):
    """
    Check langfile is legacy or not
    and return the Path
    """
    file_suffix = next((x.suffix for x in path.iterdir() if x.is_file()), None)

    match file_suffix:
        case ".json":
            return path.joinpath("zh_tw.json")
        case ".lang":
            return path.joinpath("zh_tw.lang")

def generate_subfolders(platform: str, version: str):
    """
    Generate subfolders
    """
    folder_path = Path("MultiVersions", platform, version)
    subfolders = []

    for sub in folder_path.iterdir():
        if sub.is_dir():
            subfolders.append(sub)
        else:
            print("ERROR: " + sub)

    return subfolders

def copy_resource_lang(folders: dict, check_mode: bool):
    """
    Copy mods lang
    """

    # Init pack folder
    Path.mkdir(RESOURCEPACK_PATH, parents=True, exist_ok=True)

    for folder in folders:
        mod_id = folder.name
        src_lang_path = check_legacy_langfile(folder.joinpath("lang"))
        pack_lang_path = Path(f"{RESOURCEPACK_PATH}/{mod_id}/lang")

        # Init mod dir
        pack_lang_path.mkdir(parents=True, exist_ok=True)

        if not check_mode:
            shutil.copyfile(src_lang_path, pack_lang_path.joinpath("zh_tw.json"))
            print("預設複製：" + mod_id)
        else:
            check_file_exist = pack_lang_path.joinpath("zh_tw.json").exists()

            if check_file_exist:
                print("檢查複製（存在）：" + mod_id)
                # Base is second, Head is the first main
                base = open(src_lang_path, "r", encoding="utf8").read()
                head = open(pack_lang_path.joinpath("zh_tw.json"), "r", encoding="utf8").read()

                merged = merge(base, head)
                with open(pack_lang_path.joinpath("zh_tw.json"), "w", encoding="utf8") as file:
                    file.write(merged)
            else:
                print("檢查複製（不存在）：" + mod_id)
                shutil.copyfile(src_lang_path, pack_lang_path.joinpath("zh_tw.json"))

def copy_resource_guide():
    """
    Null
    """

def lang_mixing():
    """
    Mixup different platform lang files
    Priority should be like
    *current workflow trigger version > *another higher version > *main version
    and json priton
    """
    fabric_current = generate_subfolders("Forge", "1.18")
    fabric_secondir = generate_subfolders("Forge", "1.19")
    fabric_main = generate_subfolders("Forge", "main")
    copy_resource_lang(fabric_current, check_mode=False)
    copy_resource_lang(fabric_secondir, check_mode=True)
    copy_resource_lang(fabric_main, check_mode=True)

lang_mixing()
