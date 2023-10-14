"""Simple Contributors Html table generator"""
import os
import json
import requests

GITHUB_TOKEN = os.environ.get("GITHUB_TOKEN")
AUTH_HEADER = {'Authorization': f'Bearer {GITHUB_TOKEN}'}

def get_github_user_name(api_url: str, default_name: str):
    """
    Using api url to get and retrun user name
    """

    response = requests.get(api_url, headers=AUTH_HEADER, timeout=6)

    if response.status_code == 200:
        json_data = json.loads(response.content)
        return json_data["name"] if json_data["name"] is not None else default_name
    else:
        print("ERROR, not successful to get user data")

def get_contributors_list():
    """
    Using GitHub contributors api to get list, and return needs info list
    """
    response = requests.get("https://api.github.com/repos/xMikux/ModsTranslationPack/contributors?per_page=100", headers=AUTH_HEADER, timeout=6)
    contributor_list = []

    if response.status_code == 200:
        json_data = json.loads(response.content)

        for data in json_data:
            if "[bot]" not in data["login"]:
                user_name = get_github_user_name(data["url"], data["login"])
                html_url = data["html_url"]
                avatar_url = data["avatar_url"]

                user_info = {
                    "user_name": user_name,
                    "html_url": html_url,
                    "avatar_url": avatar_url
                }

                contributor_list.append(user_info)

    return contributor_list

def generate_html_list(user_list: dict):
    """
    Generate contributor html table list
    """

    html_table = "<table>\n  <tr>\n"

    for i, user in enumerate(user_list, 1):
        html_table += '    <td align="center">\n'
        html_table += f'      <a href="{user["html_url"]}" title="{user["user_name"]}">\n'
        html_table += f'        <img src="{user["avatar_url"]}" width="100;" alt="{user["user_name"]}"/>\n'
        html_table += '        <br />\n'
        html_table += f'        <sub><b>{user["user_name"]}</b></sub>\n'
        html_table += '      </a>\n'
        html_table += '    </td>\n'

        if i % 6 == 0 and i != len(user_list):
            html_table += "  </tr>\n  <tr>\n"

    html_table += "  </tr>\n</table>"

    return html_table

if __name__ == "__main__":
    api_list = get_contributors_list()
    html_list = generate_html_list(api_list)
    print(html_list)
