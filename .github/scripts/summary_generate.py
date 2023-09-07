import os
import sys
import hashlib
from pathlib import Path
from glob import glob

def sha256_file(file_path: Path):
    sha256 = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            sha256.update(chunk)

    return sha256.hexdigest()

def get_checksum(file_path: Path):
    checksum = file_path.read_text().split()[0]

    return checksum

def verify(folder_list: set):
    list = []
    for f in folder_list:
        sha256 = sha256_file(Path(f, f"{f}.zip"))
        except_sha256 = get_checksum(Path(f, "checksum.txt"))

        name = Path(f, f"{f}.zip").name

        if sha256 == except_sha256:
            list.append({"name": f"{name}", "checksum": f"{sha256}"})
        else:
            print(f"ERROR! {name} checksum is wrong.")
            sys.exit(1)

    return list

def main():
    dir_list = set(glob("ModsTranslationPack-*"))
    file_list = verify(sorted(dir_list, reverse=True))
    run_id = os.environ["GITHUB_RUN_ID"]

    with open(os.environ["GITHUB_STEP_SUMMARY"], "w") as env:
        env.write("## 成品建構摘要\n\n")

        for i in file_list:
            name = i["name"]
            checksum = i["checksum"]
            env.write(f"- **{name}** `{checksum}`\n")

        env.close()

    step_output = f"🏗️ 建構資訊｜[流程](https://github.com/xMikux/ModsTranslationPack/actions/runs/{run_id})\n\n"

    for i in file_list:
        name = i["name"]
        checksum = i["checksum"]

        step_output += f"- **{name}** `{checksum}`\n"

    print(step_output)

if __name__ == "__main__":
    main()
