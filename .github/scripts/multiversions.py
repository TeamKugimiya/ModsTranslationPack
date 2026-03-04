"""Combine all multiversions language script"""

import json
import os
import sys
import shutil
from pathlib import Path
from loguru import logger

# Constant

## Init pack path
RESOURCEPACK_PATH = Path("pack/assets")

## Config Path
MODS_SETTINGS = Path("MultiVersions/configs/mods-settings.json")
VERSIONS_CONFIG = Path(".github/configs/versions.json")

# All copy guide settings
SIMPLE_GUIDE_DIRS = {
    "ae2guide", "book", "books", "blue_skies",
    "manual", "guides", "template_programs",
}

# For speical path case; j.name -> copy path subdir
SPECIAL_GUIDE_PATHS = {
    "oracle_index": "books/oritech/.translated/zh_tw",
}

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
        log_format = "<green>{time:YYYY-MM-DD HH:mm:ss}</green>｜<level>{level}</level>｜<level>{message}</level>"
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

def copy_lang(platform: str, version: str, dir_path: str, ignore_ids: set, first_copy: bool):
    """
    Copy mod langauge file from source to destination (workdir of pack)
    When first_copy bool is false, it will start to verify ignore_ids to check need to mixup or not.

        Parameters:
            platform (str): Platform name
            version (str): Version name
            dir_path (str): The dir of path
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
        with open(src, "r", encoding="utf8") as file1:
            data1 = json.load(file1)

        with open(dest, "r", encoding="utf8") as file2:
            data2 = json.load(file2)

        combined_data = {**data1, **data2}

        return json.dumps(combined_data, indent=2, ensure_ascii=False)

    if first_copy:
        logger.info(MSG_PLATFORM_FIRST.format(platform=platform, version=version))
        logger.info("")

        # Init subdirs
        subdirs = generate_subdirs(platform, dir_path)

        # Init Pack dir
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
                        f.write(str(mix_data))
                else:
                    logger.info(f"{MSG_COPY}{mod_id}")
                    logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
                    logger.debug(f"{MSG_DEBUG_DEST}{dest_path.joinpath(file_suffix)}")
                    dest_path.mkdir(parents=True, exist_ok=True)
                    shutil.copyfile(src_path, dest_path.joinpath(file_suffix))
            else:
                logger.info(f"{MSG_IGNORE_COPY}{mod_id}")

def copy_guide(platform: str, version: str, dir_path: str):
    """
    Copy mod guide if exist, this will check config file to see what the path of.

        Parameters:
            platform (str): Platform name
            version (str): Version name
            dir_path (str): The dir of path
    """
    logger.info("")
    logger.info(MSG_PLATFORM_GUIDE.format(platform=platform, version=version))
    logger.info("")

    for mod_dir in Path(f"MultiVersions/{platform}/{dir_path}").iterdir():
        for sub_dir in mod_dir.iterdir():
            if sub_dir.name == "lang":
                continue

            mod_id = sub_dir.parent.name

            # Default guide path (Patchouli)
            if sub_dir.name == "patchouli_books":
                guide_dirs = list(sub_dir.iterdir())
                if not guide_dirs:
                    logger.warning(f"⚠️ patchouli_books 下無子目錄: {sub_dir}")
                    continue
                guide_id = guide_dirs[0].name
                src_path = sub_dir / guide_id / "zh_tw"
                dest_path = Path(
                    f"{RESOURCEPACK_PATH}/{mod_id}/patchouli_books/{guide_id}/zh_tw"
                )

            # Simple guide path (copy entire folder)
            elif sub_dir.name in SIMPLE_GUIDE_DIRS:
                src_path = sub_dir
                dest_path = Path(f"{RESOURCEPACK_PATH}/{mod_id}/{sub_dir.name}")

            # Special guide path (copy specific sub-path)
            elif sub_dir.name in SPECIAL_GUIDE_PATHS:
                relative = SPECIAL_GUIDE_PATHS[sub_dir.name]
                src_path = sub_dir / relative
                dest_path = Path(
                    f"{RESOURCEPACK_PATH}/{mod_id}/{sub_dir.name}/{relative}"
                )

            else:
                logger.error(f"⚠️ 未收入 {sub_dir} 的手冊資料夾行為！")
                continue

            if not dest_path.exists():
                logger.info(f"{MSG_GUIDE_COPY}{mod_id}")
                logger.debug(f"{MSG_DEBUG_SRC}{src_path}")
                logger.debug(f"{MSG_DEBUG_DEST}{dest_path}")
                shutil.copytree(src_path, dest_path)
            else:
                logger.info(f"{MSG_GUIDE_IGNORE_COPY}{mod_id}")

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
        copy_lang("Forge", i["version"], i["dir_path"], ignore_list, first_run)
        copy_lang("Fabric", i["version"], i["dir_path"], ignore_list, False)
        copy_guide("Forge", i["version"], i["dir_path"])

if __name__ == "__main__":
    main()
