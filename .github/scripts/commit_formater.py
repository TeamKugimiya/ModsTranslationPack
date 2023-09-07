import os
import re
import sys

def extract_conventional_commits(commit_message):
    pattern = r'^(\w+)(?:\(([^)]+)\))?: (.+)$'
    match = re.match(pattern, commit_message)

    if match:
        commit_type = match.group(1)
        commit_scope = match.group(2)
        commit_description = match.group(3)

        return {
            "type": commit_type,
            "scope": commit_scope,
            "description": commit_description
        }
    else:
        return None

def type_title(type):
    type_mapping = {
        "mods_feat": "⚡ 新增模組翻譯",
        "mods_update": "🐌 更新模組翻譯",
        "mods_fix": "🐛 修正模組翻譯錯誤",
        "mods_improve": "✨ 提升模組翻譯品質",
        "mods_localize": "🌐 用語在地化",
        "mods_remove": "🧭 移除翻譯",
        "chore": "🧹 清理專案",
        "ci": "☁️ 持續整合 / 持續佈署",
        "docs": "📑 文件更新"
    }

    return type_mapping.get(type, "🔆 其他")

def replace_prs(commit_message):
    pattern = r'\(#(\d+)\)'
    def replace_link(match):
        pr_number = match.group(1)
        return f'([#{pr_number}]({PROJECT_URL}/pull/{pr_number}))'

    updated_message = re.sub(pattern, replace_link, commit_message)

    return updated_message

def short_sha_link(commit_sha):
    short_sha = commit_sha[:7]

    return f" ([{short_sha}]({PROJECT_URL}/commit/{commit_sha}))"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    PROJECT_URL = "https://github.com/xMikux/ModsTranslationPack"
    commit_message = sys.argv[1]
    commit_info = extract_conventional_commits(commit_message)
    commit_sha = os.environ["GITHUB_SHA"]

    if commit_info:
        line = "## {}\n\n".format(type_title(commit_info["type"]))
        if commit_info["scope"]:
            line += "* **{}**: ".format(commit_info["scope"])
            line += replace_prs(commit_info["description"])
        else:
            line += "* {}".format(replace_prs(commit_info["description"]))
        line += short_sha_link(commit_sha)

        print(line)
    else:
        sys.exit(1)
