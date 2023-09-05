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

if __name__ == "__main__":
    commit_message = sys.argv[1]
    if len(sys.argv) < 2:
        sys.exit(1)
    commit_info = extract_conventional_commits(commit_message)
    line = ""

    if commit_info:
        line += "## {}\n\n".format(type_title(commit_info["type"]))
        if commit_info["scope"]:
            line += "* **{}**: ".format(commit_info["scope"])
            line += commit_info["description"]
        else:
            line += "* {}".format(commit_info["description"])

        print(line)
    else:
        sys.exit(1)
