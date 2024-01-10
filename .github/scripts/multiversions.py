"""Combine all multiversions language script"""

import json
import sys
import shutil
from pathlib import Path
from jsonmerge import merge
from loguru import logger

# Constant

## Init pack path
RESOURCEPACK_PATH = Path("pack/assets")

## Log Messages

MSG_COPY = "📂 複製－"
MSG_MIX_COPY = "🗂️  混合複製－"
MSG_IGNORE_COPY = "🏁 忽略複製－"

MSG_DEBUG_SRC = "｜原始路徑："
MSG_DEBUG_DEST = "｜目標路徑："

# Functions

def ci_formatter(ci: bool):
    """
    Log message fomater

        Parameters:
            ci (bool): Check if is ci
            debug (bool): Enable debug mode
    """
    # pylint: disable=line-too-long
    log_format = "<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>"

    logger.remove()
    logger.add(sys.stderr, format=log_format)

    if ci:
        pass

def load_json(path: Path) -> dict:
    """
    Load json file with path

        Parameters:
            path (Path): Path of the json file

        Returs:
            dict: Json file dict
    """
    try:
        with open(path, "r", encoding="utf8") as json_file:
            data = json.load(json_file)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(e)
        logger.exception("Loading json file have error:", e)
        sys.exit(1)

def generate_subdirs(platform: str, version: str) -> list:
    """
    Generate all subdirs into a dict

        Parameters:
            platform (str): Platform name
            version (str): Version name
        
        Returns:
            list: sub dirs list
    """
    multiversion_path = Path("MultiVersions", platform, version)
    subfolders = []

    for sub in multiversion_path.iterdir():
        if sub.is_dir():
            subfolders.append(sub)
        else:
            logger.error("Error, subfolder append have problem:", sub)

    return subfolders

def generate_ignore_id(version: str) -> set:
    """
    Using config file to extract ignore mods list

        Parameters:
            version (str): Version

        Returs:
            set: mod ids
    """

    ids = None

    config_data = load_json("MultiVersions/configs/mods-settings.json")

    for i in config_data["versions"]:
        if i["version"] == version:
            ids = set(i["keeplist"])

    return ids

def copy_lang(platform: str, version: str, ignore_ids: set, first_copy: bool):
    """
    Copy mod langauge file from source to destination (workdir of pack)
    When first_copy bool is false, it will start to verify ignore_ids to check need to mixup or not.

        Parameters:
            platform (str): Platform name
            version (str): Version name
            ignore_ids (str): Ignore Ids set
            first_copy (bool): Fist time copy, if not, well have another logical
    """

    def verify_legacy(path: Path) -> str:
        """
        Verify is .json or .lang file

            Parameters:
                path (Path): Path of the lang dir
            
            Returs:
                str: return file suffix
        """
        file_suffix = next((x.suffix for x in path.iterdir() if x.is_file()), None)

        match file_suffix:
            case ".json":
                return "zh_tw.json"
            case ".lang":
                return "zh_tw.lang"

    def mix_lang(src: Path, dest: Path) -> str:
        """
        Mix up two different langauge

            Parameters:
                src (Path): Source of the path you want to merge to
                dest (Path): Destination of the path you want to merge in

            Returs:
                str: the data of json
        """
        src_data = open(src, "r", encoding="utf8").read()
        dest_data = open(dest, "r", encoding="utf8").read()
        merged_data = merge(src_data, dest_data)

        return merged_data

    if first_copy:
        logger.info("首次複製開始！")
        logger.info("")

        # Init subdirs
        subdirs = generate_subdirs(platform, version)

        # Init Pack dir
        logger.info("初始化工作資料夾")
        Path.mkdir(RESOURCEPACK_PATH, parents=True)

        # Copy files
        for subdir in subdirs:
            # Init mods info vars
            mod_id = subdir.name
            file_suffix = verify_legacy(subdir.joinpath("lang"))
            src_path = subdir.joinpath(f"lang/{file_suffix}")
            dest_path = Path(f"{RESOURCEPACK_PATH}/{mod_id}/lang/")

            logger.info(f"{MSG_COPY}{mod_id}")
            logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
            logger.debug(f"{MSG_DEBUG_DEST}{dest_path.joinpath(file_suffix)}")
            dest_path.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(src_path, dest_path.joinpath(file_suffix))
    else:
        logger.info("")
        logger.info("二次複製開始！")
        logger.info("進行必要混合。")
        logger.info("")

        # Init subdirs
        subdirs = generate_subdirs(platform, version)

        if ignore_ids is None:
            ignore_ids = {}

        # Copy and remix files
        for subdir in subdirs:
            mod_id = subdir.name
            file_suffix = verify_legacy(subdir.joinpath("lang"))
            src_path = subdir.joinpath(f"lang/{file_suffix}")
            dest_path = Path(f"{RESOURCEPACK_PATH}/{mod_id}/lang/")

            # Check if id in ignore_ids set
            if mod_id not in ignore_ids:
                # Check dir is exists
                if dest_path.exists():
                    logger.info(f"{MSG_MIX_COPY}{mod_id}")
                    logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
                    logger.debug(f"{MSG_DEBUG_DEST}{dest_path.joinpath(file_suffix)}")
                    mix_data = mix_lang(src_path, dest_path.joinpath(file_suffix))
                    with open(dest_path.joinpath(file_suffix), "w", encoding="utf8") as f:
                        f.write(mix_data)
                else:
                    logger.info(f"{MSG_COPY}{mod_id}")
                    logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
                    logger.debug(f"{MSG_DEBUG_DEST}{dest_path.joinpath(file_suffix)}")
                    dest_path.mkdir(parents=True, exist_ok=True)
                    shutil.copyfile(src_path, dest_path.joinpath(file_suffix))
            else:
                logger.info(f"{MSG_IGNORE_COPY}{mod_id}")

def copy_guide():
    """
    
    """
    pass

def main():
    """
    abc
    """
    ci_formatter(False)
    test_ignore = {"ftbchunks", "itemcollectors"}
    copy_lang("Forge", "main", test_ignore, True)
    copy_lang("Forge", "1.18", test_ignore, False)
    # LOGURU_LEVEL=INFO
    # I need to change CI to use loguru level to info
    # For debug, there have an bool to control it

main()
