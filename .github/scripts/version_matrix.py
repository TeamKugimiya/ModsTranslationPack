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

def matrix_extractor(json_dict: dict):
    versions = [{"version": version_info["mc_version"]} for version_info in json_dict["versions"]]  # noqa: E501
    return {"include": versions}

def main(json_dict: dict):
    result = matrix_extractor(json_dict)
    return result

if __name__ == "__main__":
    json_dict = loadJsonFile(".github/configs/versions.json")
    result = main(json_dict)
    output = json.dumps(result, separators=(",", ":"), ensure_ascii=False).replace("'", "\"")  # noqa: E501
    print(output)
