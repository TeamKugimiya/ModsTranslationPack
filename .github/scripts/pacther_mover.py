"""Simple Patch mover"""

import os
import sys
import shutil
import json
from loguru import logger
from pathlib import Path

RESOURCEPACK_PATH = Path("pack/assets")

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

def override_extracter(version: str):
    data = {}
    dir_path = None

    with open("MultiVersions/Patcher/.config.json", "r", encoding="utf8") as f:
        patcher_data = json.load(f)
    
    with open(".github/configs/versions.json", "r", encoding="utf8") as f:
        versions_data = json.load(f)

    for i in versions_data["versions"]:
        if i["mc_version"] == version:
            dir_path = i["dir_path"]

    for i in patcher_data["forced_override"]:
        if i["version"] == dir_path:
            data = i["mods_id"]

    return data, dir_path

def patch_mover(version_path: str, override_dict: dict):
    """
    Simple patch mover
    """
    patcher_path = Path(f"MultiVersions/Patcher/{version_path}")
    logger.info(f"🚩 複製補丁（{version_path}）")
    logger.info("")

    if patcher_path.exists():
        for i in Path(patcher_path).iterdir():
            id = i.name
            id_log = i.name

            if id.endswith("patch") is not True:
                logger.error(f"⚠️ {id} 不符合資料夾命名規則")
                sys.exit(1)

            if id in override_dict:
                id = i.name.rstrip("-patch")
                id_log = (f"{id}（覆寫）")

            logger.info(f"📂 複製 {id_log}")
            path = Path(f"{RESOURCEPACK_PATH}/{id}/lang")
            path.mkdir(parents=True)
            shutil.copy(i.joinpath("lang/zh_tw.json"), path)
        
        logger.info("")

    else:
        logger.warning(f"⚠️ {version_path} 資料夾不存在！")

def main():
    """
    Main!
    """
    ci = os.environ.get("CI")
    ci_formatter(ci)
    ci_version = os.environ.get("matrix_version")

    patch_mover("global", {})

    override_dict_version, dir_path = override_extracter(ci_version)
    patch_mover(dir_path, override_dict_version)

main()