"""Combine all multiversions language script"""

import json
import os
import sys
import shutil
from pathlib import Path
from jsonmerge import merge
from loguru import logger

# Constant

## Init pack path
RESOURCEPACK_PATH = Path("pack/assets")

## Config Path
MODS_SETTINGS = Path("MultiVersions/configs/mods-settings.json")
VERSIONS_CONFIG = Path(".github/configs/versions.json")

## Log Messages

MSG_COPY = "📂 複製－"
MSG_MIX_COPY = "🗂️ 混合複製－"
MSG_IGNORE_COPY = "🚧 忽略複製－"

MSG_GUIDE_COPY = "📖 複製手冊－"
MSG_GUIDE_IGNORE_COPY = "🚧 忽略複製手冊－"

MSG_PLATFORM_FIRST = "🚩 平台 {platform}｜版本 {version}｜模組語言首次複製"
MSG_PLATFORM_SECOND = "🚩 平台 {platform}｜版本 {version}｜模組語言二次複製與混合"
MSG_PLATFORM_GUIDE = "🚩 平台 {platform}｜版本 {version}｜手冊複製"

MSG_DEBUG_SRC = "｜原始路徑："
MSG_DEBUG_DEST = "｜目標路徑："

# Functions

def ci_formatter(ci: bool):
    """
    Log message fomater

        Parameters:
            ci (bool): Check if is ci
    """
    if ci:
        # pylint: disable=line-too-long
        log_format = "<green>{time:YYYY-MM-DD HH:mm:ss}</green>｜<level>{level: <8}</level> - <level>{message}</level>"
        logger.remove()
        logger.add(sys.stderr, format=log_format)
    else:
        log_format = "<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>"
        logger.remove()
        logger.add(sys.stderr, format=log_format)
        logger.add("loguru.log")

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

def copy_lang(platform: str, version: str, dir_path: str, ignore_ids: set, first_copy: bool, ci: bool):
    """
    Copy mod langauge file from source to destination (workdir of pack)
    When first_copy bool is false, it will start to verify ignore_ids to check need to mixup or not.

        Parameters:
            platform (str): Platform name
            version (str): Version name
            dir_path (str): The dir of path
            ignore_ids (str): Ignore Ids set
            first_copy (bool): Fist time copy, if not, well have another logical
            ci (bool): If is ci, then it will append group context
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
        ### TODO this function have oreder problem
        src_data = open(src, "r", encoding="utf8").read()
        dest_data = open(dest, "r", encoding="utf8").read()
        merged_data = merge(src_data, dest_data)

        return merged_data

    if first_copy:
        if ci:
            print("::group::" + MSG_PLATFORM_FIRST.format(platform=platform, version=version))
        logger.info(MSG_PLATFORM_FIRST.format(platform=platform, version=version))
        logger.info("")

        # Init subdirs
        subdirs = generate_subdirs(platform, dir_path)

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

        if ci:
            print("::endgroup::")
    else:
        if ci:
            print("::group::" + MSG_PLATFORM_FIRST.format(platform=platform, version=version))
        logger.info("")
        logger.info(MSG_PLATFORM_SECOND.format(platform=platform, version=version))
        logger.info("")

        # Init subdirs
        subdirs = generate_subdirs(platform, dir_path)

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

        if ci:
            print("::endgroup::")

def copy_guide(platform: str, version: str, dir_path: str, ci: bool):
    """
    Copy mod guide if exist, this will check config file to see what the path of.

        Parameters:
            platform (str): Platform name
            version (str): Version name
            dir_path (str): The dir of path
            ci (bool): If is ci, then it will append group context
    """
    if ci:
        print("::group::" + MSG_PLATFORM_GUIDE.format(platform=platform, version=version))
    logger.info("")
    logger.info(MSG_PLATFORM_GUIDE.format(platform=platform, version=version))
    logger.info("")

    for i in Path(f"MultiVersions/{platform}/{dir_path}").iterdir():
        for j in i.iterdir():
            if j.name != "lang":
                # Default guide path
                if j.name == "patchouli_books":
                    mod_id = j.parent.name
                    for i in j.iterdir():
                        guide_id = i.name
                    src_path = j.joinpath(f"{guide_id}/zh_tw")
                    # pylint: disable=line-too-long
                    dest_path = Path(f"{RESOURCEPACK_PATH}/{mod_id}/patchouli_books/{guide_id}/zh_tw")

                    if dest_path.exists() is not True:
                        logger.info(f"{MSG_GUIDE_COPY}{mod_id}")
                        logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
                        logger.debug(f"{MSG_DEBUG_DEST}{dest_path}")
                        shutil.copytree(src_path, dest_path)
                    else:
                        logger.info(f"{MSG_GUIDE_IGNORE_COPY}{mod_id}")
                # Special guide path
                elif j.name == "ae2guide" or j.name == "book" or j.name == "blue_skies":
                    mod_id = j.parent.name
                    src_path = j
                    dest_path = Path(f"{RESOURCEPACK_PATH}/{mod_id}/{j.name}")

                    if dest_path.exists() is not True:
                        logger.info(f"{MSG_GUIDE_COPY}{mod_id}")
                        logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
                        logger.debug(f"{MSG_DEBUG_DEST}{dest_path}")
                        shutil.copytree(src_path, dest_path)
                    else:
                        logger.info(f"{MSG_GUIDE_IGNORE_COPY}{mod_id}")
                else:
                    logger.error(f"⚠️ 未收入 {j.name} 的手冊資料夾行為！")
    if ci:
        print("::endgroup::")

def extract_versions(path: Path, version: str) -> dict:
    """
    Extract mc_versions to new array, with setting version

        Parameters:
            path (str): The path of version json
            version (str): Version of matrix
    """
    mc_versions = []
    json_data = load_json(path)

    for ver in json_data["versions"]:
        mc_versions.append({"version": ver["mc_version"], "dir_path": ver["dir_path"]})

    index = next((i for i, item in enumerate(mc_versions) if item['version'] == version), None)

    if index is not None:
        return mc_versions[index:]

    logger.error(f"不存在 {version} 版本！")
    sys.exit(1)

def main():
    """
    First run of function
    """
    ci = os.environ.get("CI")
    ci_formatter(ci)

    # Init Vars
    mc_version_matrix = os.environ.get("matrix_version")
    # mc_version_matrix = "1.18.x"
    version_list = extract_versions(VERSIONS_CONFIG, mc_version_matrix)

    # Generate ignore list
    ignore_list = None
    mod_settings_data = load_json(MODS_SETTINGS)
    for i in mod_settings_data["versions"]:
        if i["version"] == mc_version_matrix:
            ignore_list = i["keeplist"]

    # Copy guide and lang files
    for i in version_list:
        first_run = True if i["version"] == mc_version_matrix else False
        copy_lang("Forge", i["version"], i["dir_path"], ignore_list, first_run, ci)
        copy_lang("Fabric", i["version"], i["dir_path"], ignore_list, False, ci)
        copy_guide("Forge", i["version"], i["dir_path"], ci)

if __name__ == "__main__":
    main()
