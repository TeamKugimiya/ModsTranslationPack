import os
import sys
import json

def loadJsonFile(filePath: str):
    try:
        with open(filePath, "r", encoding="utf8") as f:
            data = json.load(f)
            return data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"讀取 JSON 檔案時發生錯誤: {e}")
        sys.exit(1)

def value_extractor(json_dict: dict, mc_version: str, value: str):
    selected_version = None
    for version_info in json_dict["versions"]:
        if version_info["mc_version"] == mc_version:
            selected_version = version_info
            break

    if selected_version is not None:
        try:
            result = selected_version[value]
        except KeyError:
            sys.exit(1)

        return result 
    else:
        sys.exit(1)

def main(json_dict: dict, mc_version: str, value: str):
    result = value_extractor(json_dict, mc_version, value)
    return result

if __name__ == "__main__":
    json_dict = loadJsonFile(".github/configs/versions.json")
    mc_version = os.environ.get("matrix_version")
    value = sys.argv[1]
    if len(sys.argv) < 2:
        sys.exit(1)
    result = main(json_dict, mc_version, value)
    print(result)
