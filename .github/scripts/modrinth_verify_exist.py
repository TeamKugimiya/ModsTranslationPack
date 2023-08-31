import os
import sys
import json
import requests

def main(version):
    modrinth_api = f"https://api.modrinth.com/v2/project/cF5VXmkW/version/{version}"
    github_project = os.environ["GITHUB_REPOSITORY"]
    headers = {"User-Agent": f"{github_project} (Verify Exist Script)"}

    response = requests.get(modrinth_api, headers=headers)

    if response.status_code == 200:
        json_data = json.loads(response.text)
        version_number = json_data["version_number"]
        date_published = json_data["date_published"]

        # Set step output
        with open(os.environ["GITHUB_OUTPUT"], "w") as f:
            f.write("version_exist=true")

        # Print a warning message
        print(f"::warning:: 版本 ``{version_number}`` 已存在！發佈時間 ``{date_published}``")  # noqa: E501
    else:
        print("版本未存在！")
        # Set step output
        with open(os.environ["GITHUB_OUTPUT"], "w") as f:
            f.write("version_exist=false")

if __name__ == "__main__":
    git_version = sys.argv[1]
    if len(sys.argv) < 2:
        sys.exit(1)
    main(git_version)
