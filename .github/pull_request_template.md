## 這個 PR 做了什麼

<!-- 例如：更新 Ecologics 翻譯、新增 26.2 版本層級 -->

## 送出前確認

- [ ] 新增模組或版本層級是用 `translation-tool init` 產生的，不是手寫 `metadata.json`
- [ ] 翻譯有變動時跑過 `translation-tool progress`
- [ ] commit 訊息符合約定式提交

<!--
## 約定式提交

格式為 <type>(<模組顯示名稱>): <說明>，scope 用模組的英文顯示名稱。

  新增模組翻譯
    mods_feat(Simple Voice Chat): 新增模組翻譯
    mods_feat(LAST DANCE): 最後一舞 第一部分

  更新既有翻譯
    mods_update(Ecologics): 更新模組翻譯
    mods_update(Angel Ring): 更新模組翻譯

  修正翻譯錯誤
    mods_fix(Applied Energistics 2): 修正光源 P2P 通道譯名
    mods_fix(Functional Storage): 修正 1.20 錯誤的翻譯文本

非翻譯的改動用 chore / fix / ci / docs，不加模組 scope：

    ci(build): 調整流程
    chore: 更新 metadata 版本範圍

## 為什麼用工具而不是手寫

init 會一併填好 contents.tiers、source.game_version、source.loader 與
status.mod_versions；手寫容易漏掉其中幾項，而這些欄位工具無法驗證對錯。

唯一 init 不會處理的是**既有層級**：新增層級後，舊層級原本的 "<=@latest"
要自己收斂成明確上界（例如 "<=1.21"），否則兩個層級會同時匹配同一個版本群組。
這個 CI 會以 group-tier-ambiguity 擋下。

本機可先自己跑：translation-tool doctor
-->
