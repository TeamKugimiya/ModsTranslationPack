"""Simple Patch mover"""

import os
import sys
import shutil
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

def patch_mover(version_pat: str):
    """
    Simple patch mover
    """
    patcher_path = Path(f"MultiVersions/Patcher/{version_path}")
    logger.info(f"🚩 複製補丁（{version_path}）")
    logger.info("")

    if patcher_path.exist():

    for i in Path(f"").iterdir():
        id = i.name
        if id.endswith("patch"):
            logger.info(f"📂 複製 {id}")
            path = Path(f"{RESOURCEPACK_PATH}/{id}/lang")
            path.mkdir(parents=True)
            shutil.copy(i.joinpath("lang/zh_tw.json"), path)
        else:
            logger.error(f"⚠️ {id} 不符合資料夾命名規則")
            sys.exit(1)

def main():
    """
    Main!
    """
    ci = os.environ.get("CI")
    ci_formatter(ci)
    patch_mover()

main()