import mediafire_dl
import tempfile
import os
import zipfile
import shutil
import json
import urllib.request
import sys
import requests
import subprocess
from pathlib import Path

def simple_load(json_file_path: str):
    try:
        with open(json_file_path, "r", encoding="utf8") as f:
            data = json.load(f)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error when loading JSON file: {e}")
        sys.exit(1)

def url_checker(url: str):
    response = requests.head(url)
    status_code = response.status_code

    if status_code == requests.codes.ok:
        return True
    else:
        return False

def check_url_exists(mods_dict: dict):
    for mod_dicts in mods_dict["lists"]:
        response = requests.head(mod_dicts["url"])
        mod_name = mod_dicts["modName"]
        status_code = response.status_code

        if status_code == requests.codes.ok:
            pass
        else:
            print(f"⚠ {mod_name} 模組下載 URL 出現錯誤：{status_code}")

def downloader(url, file_path, branch=None):
    if url.startswith("https://github.com/") and url.endswith(".zip"):
        urllib.request.urlretrieve(url, file_path)
        return

    if url.startswith("https://github.com/") and url.endswith(".git"):
        command = ["git", "clone", "-q", "-b", branch, url, file_path]
        subprocess.run(command, check=True)
        return

    if url_checker(url):
        if url.startswith("https://www.mediafire.com/"):
            mediafire_dl.download(url, file_path, quiet=True)
        elif url.startswith("https://raw.githubusercontent.com/") and url.endswith("LICENSE"):
            urllib.request.urlretrieve(url, file_path)
        elif url.startswith("https://raw.githubusercontent.com/"):
            urllib.request.urlretrieve(url, file_path)
        else:
            print("Error, can't find correct downloader")
            sys.exit(1)
    else:
        print("⚠ 警告，下載失敗！")
        sys.exit(1)

def direct_language(modname, modloader, version, url):
    url_parts = url.split("/")
    mod_id = url_parts[-3]
    path = Path("MultiVersions", modloader, version, mod_id, "lang", "zh_tw.json")

    print("🛈 模組名", modname)
    print("> 模組 ID", mod_id)

    path.parent.mkdir(parents=True, exist_ok=True)
    downloader(url, path)

def direct_license(modname, url):
    modname_fix = modname.replace(" ", "-")
    path = Path(f"LICENSE_{modname_fix}")

    print(f"🪪 下載 {modname} 授權條款")
    downloader(url, path)

def language_finder(dir):
    for file_path in Path(dir).rglob("zh_tw.json"):
        mod_id = file_path.parent.parent.name
        return mod_id

def jar_lang_copyer(dir, modloader, version):
    mod_id = language_finder(dir)
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
    mod_id = language_finder(dir)

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

    downloader(url, override_file)

    with zipfile.ZipFile(override_file, "r") as jar:
        jar.extractall(temp_dir)

    jar_lang_copyer(temp_dir, modloader, version)

    shutil.rmtree(temp_dir)

def jar_extract_guide(modname, guidepath, guidesave, modloader, version, url, special=None):
    temp_dir = tempfile.mkdtemp()
    override_file = os.path.join(temp_dir, os.path.basename(url))

    print("🛈 模組名", modname)

    downloader(url, override_file)

    with zipfile.ZipFile(override_file, "r") as jar:
        jar.extractall(temp_dir)

    jar_lang_copyer(temp_dir, modloader, version)

    jar_guide_copyer(temp_dir, guidepath, guidesave, modloader, version, special)

    shutil.rmtree(temp_dir)

def zip_copyer(temp_dir, modloader, version):
    mod_id = language_finder(temp_dir)
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
    print(temp_dir)
    override_file = os.path.join(temp_dir, os.path.basename(url))
    print(override_file)

    print("🛈 模組名", modname)

    downloader(url, override_file)

    with zipfile.ZipFile(override_file, "r") as zip:
        zip.extractall(temp_dir)

    if extractAll:
        zip_copyer_all(temp_dir, modloader, version)
    else:
        zip_copyer(temp_dir, modloader, version)

    shutil.rmtree(temp_dir)

def git_lang_copyer(dir, modloader, version):
    mod_id = language_finder(dir)
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
    mod_id = language_finder(dir)

    for i in array:
        try:
            source_path = os.path.join(dir, i)
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

def git_clone(modname, guidepath, guidesave, branch, modloader, version, url):
    temp_dir = tempfile.mkdtemp()
    print("🛈 模組名", modname)

    downloader(url, os.path.join(temp_dir), branch)

    git_lang_copyer(temp_dir, modloader, version)

    git_guide_copyer(temp_dir, guidepath, guidesave, modloader, version)

    shutil.rmtree(temp_dir)

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
            direct_language(modname, modloader, modversion, url)
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
            direct_license(modname, url)

        print("")

def main(json_file_path):
    mods_list = simple_load(json_file_path)
    process_mods_list(mods_list)

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "Test":
        mods_dict = simple_load("../../configs/override_list.json")
        check_url_exists(mods_dict)
    else:
        json_file_path = "../../configs/override_list.json"
        main(json_file_path)
