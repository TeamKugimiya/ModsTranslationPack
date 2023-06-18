import mediafire_dl
import tempfile
import os
import zipfile
import shutil
import json
import urllib.request
import sys
import subprocess
import aiohttp
import asyncio
from pathlib import Path

### Utils (?) ###

## Load JSON
def loadJsonFile(filePath: str):
    try:
        with open(filePath, "r", encoding="utf8") as f:
            data = json.load(f)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"讀取 JSON 檔案時發生錯誤: {e}")
        sys.exit(1)

## Verify URL
async def verify_url(mod_dicts: dict, mods_dict: dict, should_exit_on_fail: bool, session):
    response = await session.head(mod_dicts["url"])
    mod_name = mod_dicts["modName"]
    status_code = response.status

    if mod_name not in mods_dict["ingoreCheckList"]:
        if status_code != 200:
            print(f"⚠ {mod_name} 模組下載 URL 出現錯誤：{status_code}")
            if should_exit_on_fail:
                sys.exit(1)

async def verifyURL(should_exit_on_fail: bool, mods_dict: dict):
    async with aiohttp.ClientSession() as session:
        tasks = []
        for mod_dicts in mods_dict["lists"]:
            task = verify_url(mod_dicts, mods_dict, should_exit_on_fail, session)
            tasks.append(task)
        await asyncio.gather(*tasks)

## Print Mod Info ! - TODO Redo
def print_mod_info(modName: str, modId: str):
    print("🛈 模組名", modName)
    print("> 模組 ID", modId)

## Download File
def downloadFile(url: str, filePath, gitBranch: str =None):
    if url.startswith("https://github.com/") and url.endswith(".git"):
        command = ["git", "clone", "-q", "-b", gitBranch, url, filePath]
        subprocess.run(command, check=True)
    elif url.startswith("https://github.com/") and url.endswith(".zip") or \
        url.startswith("https://raw.githubusercontent.com/"):
        urllib.request.urlretrieve(url, filePath)
    elif url.startswith("https://www.mediafire.com/"):
        mediafire_dl.download(url, filePath, quiet=True)
    else:
        print("⚠️ 錯誤，無法自我找到正確的下載方式")
        sys.exit(1)

## Mod ID Finder
def modId_Finder(dir: str):
    for file_path in Path(dir).rglob("zh_tw.json"):
        mod_id = file_path.parent.parent.name
        return mod_id

# Language Extracter TODO Refactor ALL
 
def jar_lang_copyer(dir, modloader, version):
    mod_id = modId_Finder(dir)
    source_path = os.path.join(dir, "assets", mod_id, "lang", "zh_tw.json")
    dest_path = Path("MultiVersions", modloader, version, mod_id, "lang", "zh_tw.json")

    print("> 模組 ID", mod_id)
    print("> 原始路徑", source_path)
    print("> 目的路徑", dest_path)

    try:
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(source_path, dest_path)
    except OSError as e:
        print(f"Error occurred while copying file: {e}")

def jar_guide_copyer(dir, array, path, modloader, version, special=None):
    mod_id = modId_Finder(dir)

    for i in array:
        try:
            source_path = os.path.join(dir, i)
            if special:
                if os.path.isdir(source_path):
                    manual_dirname = os.path.basename(os.path.dirname(i))
                    manual_langname = os.path.basename(i)
                    shutil.copytree(source_path, os.path.join("MultiVersions", modloader, version, mod_id, path, manual_dirname, manual_langname))
                    print(f"> 手冊複製 {i} 到 {path}")
                elif os.path.isfile(source_path):
                    shutil.copy(source_path, os.path.join("MultiVersions", modloader, version, mod_id, path))
                    print(f"> 手冊複製 {i} 到 {path}")
                else:
                    print(f"{source_path} 不是一個有效的資料夾或檔案")
            else:
                if os.path.isdir(source_path):
                    shutil.copytree(source_path, os.path.join("MultiVersions", modloader, version, mod_id, path, os.path.basename(i)))
                    print(f"> 手冊複製 {i} 到 {path}")
                elif os.path.isfile(source_path):
                    shutil.copy(source_path, os.path.join("MultiVersions", modloader, version, mod_id, path))
                    print(f"> 手冊複製 {i} 到 {path}")
                else:
                    print(f"{source_path} 不是一個有效的資料夾或檔案")
        except OSError as e:
            print(f"複製手冊時發生錯誤：{e}")    

def jar_extract(modname, modloader, version, url):
    temp_dir = tempfile.mkdtemp()
    override_file = os.path.join(temp_dir, os.path.basename(url))

    print("🛈 模組名", modname)

    downloadFile(url, override_file)

    with zipfile.ZipFile(override_file, "r") as jar:
        jar.extractall(temp_dir)

    jar_lang_copyer(temp_dir, modloader, version)

    shutil.rmtree(temp_dir)

def jar_extract_guide(modname, guidepath, guidesave, modloader, version, url, special=None):
    temp_dir = tempfile.mkdtemp()
    override_file = os.path.join(temp_dir, os.path.basename(url))

    print("🛈 模組名", modname)

    downloadFile(url, override_file)

    with zipfile.ZipFile(override_file, "r") as jar:
        jar.extractall(temp_dir)

    jar_lang_copyer(temp_dir, modloader, version)

    jar_guide_copyer(temp_dir, guidepath, guidesave, modloader, version, special)

    shutil.rmtree(temp_dir)

def zip_copyer(temp_dir, modloader, version):
    mod_id = modId_Finder(temp_dir)
    source_path = os.path.join(temp_dir, "assets", mod_id)
    dest_path = Path("MultiVersions", modloader, version, mod_id)

    print("> 模組 ID", mod_id)
    print("> 原始路徑", source_path)
    print("> 目的路徑", dest_path)

    try:
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copytree(source_path, dest_path)
    except OSError as e:
        print(f"Error occurred while copying file: {e}")

def zip_copyer_all(temp_dir, modloader, version):
    source_path = os.path.join(temp_dir, "assets")
    dest_path = Path("MultiVersions", modloader, version)

    print("> 模組 ID 複製全部")
    print("> 原始路徑", source_path)
    print("> 目的路徑", dest_path)

    try:
        shutil.copytree(source_path, dest_path, dirs_exist_ok=True)
    except OSError as e:
        print(f"Error occurred while copying file: {e}")

def zip_extract(modname, modloader, version, url, extractAll: bool):
    temp_dir = tempfile.mkdtemp()
    override_file = os.path.join(temp_dir, os.path.basename(url))

    print("🛈 模組名", modname)

    downloadFile(url, override_file)

    with zipfile.ZipFile(override_file, "r") as zip:
        zip.extractall(temp_dir)

    if extractAll:
        zip_copyer_all(temp_dir, modloader, version)
    else:
        zip_copyer(temp_dir, modloader, version)

    shutil.rmtree(temp_dir)

def git_lang_copyer(dir, modloader, version):
    mod_id = modId_Finder(dir)
    source_path = os.path.join(dir, "src", "main", "resources", "assets", mod_id, "lang", "zh_tw.json")
    dest_path = Path("MultiVersions", modloader, version, mod_id, "lang", "zh_tw.json")

    print("> 模組 ID", mod_id)
    print("> 原始路徑", source_path)
    print("> 目的路徑", dest_path)

    try:
        dest_path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy(source_path, dest_path)
    except OSError as e:
        print(f"Error occurred while copying file: {e}")

def git_guide_copyer(dir, array, path, modloader, version):
    mod_id = modId_Finder(dir)

    for i in array:
        try:
            source_path = os.path.join(dir, i)
            if os.path.isdir(source_path):
                dest_path = os.path.join("MultiVersions", modloader, version, 
                                         mod_id, path, os.path.basename(i))
                shutil.copytree(source_path, dest_path)
                print(f"> 手冊複製 {i} 到 {path}")
            elif os.path.isfile(source_path):
                dest_path = os.path.join("MultiVersions", modloader, version,
                                         mod_id, path)
                shutil.copy(source_path, dest_path)
                print(f"> 手冊複製 {i} 到 {path}")
            else:
                print(f"{source_path} 不是一個有效的資料夾或檔案")
        except OSError as e:
            print(f"複製手冊時發生錯誤：{e}")   

def git_clone(modname, guidepath, guidesave, branch, modloader, version, url):
    temp_dir = tempfile.mkdtemp()
    print("🛈 模組名", modname)

    downloadFile(url, os.path.join(temp_dir), branch)

    git_lang_copyer(temp_dir, modloader, version)

    git_guide_copyer(temp_dir, guidepath, guidesave, modloader, version)

    shutil.rmtree(temp_dir)

# Process Download Action

## Direct Download JSON File
def directDownload_Lang(modName: str, modLoader: str, version: str, url: str):
    url_parts = url.split("/")
    modId = url_parts[-3]
    path = Path("MultiVersions", modLoader, version, modId, "lang", "zh_tw.json")

    print_mod_info(modName, modId)

    path.parent.mkdir(parents=True, exist_ok=True)
    downloadFile(url, path)

## Direct Download License File
def directDownload_License(modName: str, url: str):
    fixed_modName = modName.replace(" ", "-")
    path = Path("Override", f"LICENSE_{fixed_modName}")

    print(f"🪪 下載 {modName} 授權條款")
    path.parent.mkdir(parents=True, exist_ok=True)
    downloadFile(url, path)

## Main Process Download
def process_mods_list(mods_dict: dict):
    for mods_dict in mods_dict["lists"]:
        modname = mods_dict["modName"]
        modloader = mods_dict["modLoader"]
        modversion = mods_dict["modVersion"]
        extractype = mods_dict.get("extractType", "Mods")
        guidepaths = mods_dict.get("guidePaths")
        guidesave = mods_dict.get("guideSave")
        specialcopy = mods_dict.get("specialCopy")
        branch = mods_dict.get("branchVersion")
        license_url = mods_dict.get("licenseURL")
        url = mods_dict["url"]

        if url.endswith(".json"):
            directDownload_Lang(modname, modloader, modversion, url)
        elif url.endswith(".jar") and extractype == "Mods":
            jar_extract(modname, modloader, modversion, url)
        elif url.endswith(".jar") and extractype == "Mods-With-Guide":
            jar_extract_guide(modname, guidepaths, guidesave, modloader, modversion, url, specialcopy)
        elif url.endswith(".zip") and extractype == "Mods":
            zip_extract(modname, modloader, modversion, url, False)
        elif url.endswith(".zip") and extractype == "ExtractAll":
            zip_extract(modname, modloader, modversion, url, True)
        elif url.endswith(".git") and extractype == "Mods-With-Guide-Git":
            git_clone(modname, guidepaths, guidesave, branch, modloader, modversion, url)
        else:
            print(f"⚠ 模組 {modname} 並未執行到任何覆蓋！")

        if license_url:
            directDownload_License(modname, license_url)

        print("")

# Execute
def main(json_file_path):
    mods_list = loadJsonFile(json_file_path)
    asyncio.run(verifyURL(True, mods_list))
    process_mods_list(mods_list)

if __name__ == "__main__":
    if os.environ.get("CI"):
        json_file_path = "../.github/configs/override_list.json"
    else:
        json_file_path = "../../configs/override_list.json"

    if len(sys.argv) > 1 and sys.argv[1] == "Test":
        mods_list = loadJsonFile(json_file_path)
        asyncio.run(verifyURL(False, mods_list))
    else:
        main(json_file_path)
