#!/bin/bash

## Description of this scripts
echo ">>> 模組翻譯覆蓋腳本 <<<"
echo ">>> 對於一些第三方來源的自動下載覆蓋"
echo ">>> 與部分尚未釋出最新翻譯更新的模組"
echo ">>> 此步驟將會把一些已知的模組翻譯覆蓋掉"

## Import Common Libary
# shellcheck source=/dev/null
source ./.github/scripts/Common_Library.sh

## DEBUG Var

# java_path=$(which jar)
java_home_path=${java_path:-$JAVA_HOME_17_X64/bin/jar}

# home_path=~/workspace/GitHub/xMikux/ModsTranslationPack
home_path=$GITHUB_WORKSPACE/MultiVersions/Override/

if [ ! -d "$home_path" ]; then
  mkdir -p "$home_path"
fi

## Tools Install

install_packages () {
    ## 小資訊:
    ## megatools 並不知道原始連結是甚麼
    ## 這邊有一個修正連結的問題 https://github.com/megous/megatools/issues/157#issuecomment-615835778

    echo "🧰 安裝必要軟體..."
    sudo apt-get update > /dev/null
    sudo apt-get install -y megatools > /dev/null
    echo "🧰 完成!"
}

## Common Function

# Return to workspace root
home () {
    cd "$home_path" || exit
}

# Verify override contents
verify_override_translate_exists () {
    mods_name=$1
    mods_path=$2
    module_mode=$3

    case $module_mode in
      # 模組模式 1 驗證檔案
      "1")
        if [ -f "$mods_path"/zh_tw.json ]; then
          echo "✅ $mods_name 翻譯驗證通過！"
        else
          echo "❎ 錯誤！覆蓋 $mods_name 翻譯失敗。"
          exit 1
        fi
        ;;
      # 模組模式 2 驗證指南手冊資料夾
      "2")
        if [ -d "$mods_path" ] && [ "$(ls -A "$mods_path")" ]; then
          echo "✅ $mods_name 指南手冊翻譯驗證通過！（$mods_path）"
        else
          echo "❎ 錯誤！覆蓋 $mods_name 書本翻譯失敗。"
          exit 1
        fi
        ;;
      *)
       error_func
       ;;
      esac
}

## Downloader Functions

mega_downloader () {
    mods_name=$1
    download_link=$2

    echo "📁 下載 $mods_name 中..."
    command_excuter "megadl $download_link" "下載完成！" "下載失敗！"
}

mediafire_downloader () {
    mods_name=$1
    download_link=$2

    echo "📁 下載 $mods_name 中..."
    command_excuter "wget -q $(wget -U 'Wget Bot' -qO - "$download_link" | grep 'id="downloadButton"' | grep -Po '(?<=href=")[^"]*')" "下載完成！" "下載失敗！"
}

github_downloader () {
    mods_name=$1
    download_link=$2
    download_file_path=$3

    echo "📁 下載 $mods_name 中..."
    command_excuter "wget -q $download_link -P $download_file_path" "下載完成！" "下載失敗！"
}

download_mode_chooser () {
    download_mode=$1
    mods_name=$2
    download_link=$3
    download_file_path=$4

    case $download_mode in
      # 模組模式 1 Mega
      "1")
        echo "📥 透過 Mega 下載 $mods_name..."
        mega_downloader "$mods_name" "$download_link"
        ;;
      # 模組模式 2 MediaFire
      "2")
        echo "📥 透過 MediaFire 下載 $mods_name..."
        mediafire_downloader "$mods_name" "$download_link"
        ;;
      "3")
        echo "📥 透過 Wget 下載 $mods_name..."
        github_downloader "$mods_name" "$download_link" "$download_file_path"
        ;;
      *)
        error_func
        ;;
      esac
}

## Extractor Functions

jar_extractor () {
    module_mode=$1
    mods_name=$2
    file_name=$3
    mods_path=$4

    case $module_mode in
      # 模組模式 1 提取模組翻譯
      "1")
        echo "🔧 提取 $mods_name 的翻譯檔..."
        command_excuter "$java_home_path xf $file_name $mods_path" "提取成功！" "提取失敗！"
        ;;
      # 模組模式 2 提取指南手冊翻譯與模組翻譯
      "2")
        echo "🔧 提取完整 $mods_name..."
        command_excuter "$java_home_path xf $file_name" "提取成功！" "提取失敗！"
        ;;
      *)
        error_func
        ;;
      esac
}

zip_extractor () {
    mods_name=$1
    file_name=$2

    echo "📦 解壓縮 $mods_name 檔案..."
    command_excuter "unzip -q $file_name" "解壓縮成功！" "解壓縮失敗！"
}

# License Downloader

license_downloader () {
    mods_name=$1
    license_link=$2

    echo "🪪 下載 $mods_name 授權條款..."
    command_excuter "wget -q $license_link -O LICENSE_$mods_name" "下載完成！" "下載失敗！"
    echo "   "
}

## Main Override Functions

main_override () {
    module_mode=$1
    mods_name=$2
    mods_download_link=$3
    # shellcheck disable=SC2086
    mods_file_name=$(basename $mods_download_link)
    mods_path=assets/$4
    download_mode=$5
    mods_guide_original_path=$6
    mods_guide_assets_path=$mods_path/$7
    local -n mods_guide_path_array=${8:-null}
    mods_guide_mode=${9}

    # Some path translate var
    mods_path_lang=$mods_path/lang
    mods_path_lang_file=$mods_path/lang/zh_tw.json

    case $module_mode in
      # 模組模式 1 直接下載並放入指定路徑
      "1")
        home
        echo "🥖 開始覆蓋 $mods_name"
        echo "📁 新增資料夾..."
        mkdir -p "$mods_path_lang"
        github_downloader "$mods_name" "$mods_download_link" "$mods_path_lang"
        echo "⚙️ 驗證翻譯檔案..."
        verify_override_translate_exists "$mods_name" "$mods_path_lang" 1
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      # 模組模式 2 解壓縮來自壓縮檔
      "2")
        echo "🥖 開始覆蓋 $mods_name"
        echo "📁 新增暫存資料夾..."
        workdir_path="$(mktemp -d)"
        echo "🐌 移動至暫存資料夾 $workdir_path..."
        cd "$workdir_path" || exit
        download_mode_chooser "$download_mode" "$mods_name" "$mods_download_link"
        zip_extractor "$mods_name" "$mods_file_name"
        echo "🐌 回到主目錄"
        home
        echo "📁 移動翻譯資料夾"
        mv "$workdir_path"/"$mods_path" assets
        echo "⚙️ 驗證翻譯檔案..."
        verify_override_translate_exists "$mods_name" "$mods_path_lang" 1
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      # 模組模式 3 從 Jar 中提取模組翻譯
      "3")
        echo "🥖 開始覆蓋 $mods_name"
        echo "📁 新增暫存資料夾..."
        workdir_path="$(mktemp -d)"
        echo "🐌 移動至暫存資料夾 $workdir_path..."
        cd "$workdir_path" || exit
        download_mode_chooser "$download_mode" "$mods_name" "$mods_download_link"
        jar_extractor 1 "$mods_name" "$mods_file_name" "$mods_path_lang_file"
        echo "🐌 回到主目錄"
        home
        echo "📁 新增資料夾..."
        mkdir -p "$mods_path_lang"
        echo "📁 複製翻譯..."
        cp "$workdir_path"/"$mods_path_lang_file" "$mods_path_lang"
        echo "⚙️ 驗證翻譯檔案..."
        verify_override_translate_exists "$mods_name" "$mods_path_lang" 1
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      # 模組模式 4 從 Jar 中提取指南手冊與模組翻譯
      "4")
        echo "🥖 開始覆蓋 $mods_name"
        echo "📁 新增暫存資料夾..."
        workdir_path="$(mktemp -d)"
        echo "🐌 移動至暫存資料夾 $workdir_path..."
        cd "$workdir_path" || exit
        download_mode_chooser "$download_mode" "$mods_name" "$mods_download_link"
        jar_extractor 2 "$mods_name" "$mods_file_name"
        echo "🐌 回到主目錄"
        home
        echo "📁 新增資料夾..."
        mkdir -p "$mods_path_lang"
        mkdir -p "$mods_guide_assets_path"
        echo "📁 複製翻譯..."
        cp "$workdir_path"/"$mods_path_lang_file" "$mods_path_lang"
        echo "🛗 移動指南手冊翻譯"
        case $mods_guide_mode in
          "1")
            for i in "${mods_guide_path_array[@]}"; do
              mods_guide_path=$workdir_path/$mods_guide_original_path/$i
              if cp -r "$mods_guide_path" "$mods_guide_assets_path/"; then
                echo "✅ 成功將 $mods_guide_path 移動至 $mods_guide_assets_path"
              else
                echo "❎ 在移動 $mods_guide_path 時失敗！"
              fi
            done
            ;;
          "2")
            for i in "${mods_guide_path_array[@]}"; do
              mods_guide_path=$workdir_path/$mods_guide_original_path/$i
              mods_assets_path=$mods_guide_assets_path/$i
              if mkdir -p "$mods_assets_path"; then
                if cp -r "$mods_guide_path"/* "$mods_assets_path"; then
                  echo "✅ 成功將 $mods_guide_path 移動至 $mods_guide_assets_path/$i"
                else
                  echo "❎ 在移動 $mods_guide_path/$i 時失敗！"
                fi
              fi
            done
            ;;
          *)
            error_func
            ;;
        esac
        echo "⚙️ 驗證翻譯檔案..."
        verify_override_translate_exists "$mods_name" "$mods_path_lang" 1
        echo "⚙️ 驗證指南手冊翻譯..."
        for i in "${mods_guide_path_array[@]}"; do
          mods_guide_path=$mods_guide_assets_path/$i
          verify_override_translate_exists "$mods_name" "$mods_guide_path" 2
        done
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      # 模組模式 5 解壓縮 zip 並放入所有物品
      "5")
        echo "🥖 開始覆蓋 $mods_name"
        echo "📁 新增暫存資料夾..."
        workdir_path="$(mktemp -d)"
        echo "🐌 移動至暫存資料夾 $workdir_path..."
        cd "$workdir_path" || exit
        download_mode_chooser "$download_mode" "$mods_name" "$mods_download_link" "$workdir_path"
        zip_extractor "$mods_name" "$mods_file_name"
        echo "🐌 回到主目錄"
        home
        echo "📁 移動翻譯資料夾"
        cp -r "$workdir_path"/assets/* assets
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      # 模組模式 6 下載 GitHub 上的手冊
      "6")
        echo "🥖 開始覆蓋 $mods_name"
        echo "📁 新增暫存資料夾..."
        workdir_path="$(mktemp -d)"
        echo "🐌 移動至暫存資料夾 $workdir_path..."
        cd "$workdir_path" || exit
        echo "☁️ 從 GitHub 複製專案..."
        git clone -b "$download_mode" "$mods_download_link" repo > /dev/null
        echo "🐌 回到主目錄"
        home
        echo "📁 新增資料夾..."
        mkdir -p "$mods_guide_assets_path"
        echo "📁 移動手冊翻譯"
        command_excuter "cp -r $workdir_path/repo/$mods_guide_original_path $mods_guide_assets_path" "移動成功！" "移動失敗！"
        verify_override_translate_exists "$mods_name" "$mods_guide_assets_path/zh_tw" 2
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      *)
        error_func
      esac
}

# Main Function Start

## init function
home
# install_packages (no mega download now, so disabled to speed up the script.)

## 使用解說 ##
# main_override *1模組模式 模組名稱 模組覆蓋連結 模組assetsID *3下載模式 *4指南手冊原始路徑 *5指南手冊assets路徑 *6指南手冊陣列 *7特殊模式
#
# *1 模組模式總共有四種
#    - 1 直接下載並放入指定路徑
#    - 2 解壓縮來自壓縮檔
#    - 3 從 Jar 中提取模組翻譯
#    - 4 從 Jar 中提取指南手冊與模組翻譯
#    - 5 解壓縮 zip 並放入所有物品
#    - 6 從 GitHub 上下載 Patchouli (下載模式變成分支切換)
#
# *3 下載模式共有兩種
#    - 1 透過 Mega
#    - 2 透過 MediaFire
#
# 以下列表將是指南手冊提取參數，普通情況下不會用到，且該參數很容易炸掉
#
# *4 原始指南手冊位置
#
# *5 指南手冊 assets 路徑
#
# *6 指南手冊的多陣列資料夾複製
#
# *7 特殊行為模式
#    - 1 預設通常都會使用模式 1，僅複製單一資料夾
#    - 2 特殊情況下需要多個以上的資料夾移動

### GitHub ###

## Dynamic FPS
main_override 1 "Dynamic FPS" "https://raw.githubusercontent.com/juliand665/Dynamic-FPS/main/src/main/resources/assets/dynamicfps/lang/zh_tw.json" "dynamicfps"
license_downloader "DynamicFPS" "https://raw.githubusercontent.com/juliand665/Dynamic-FPS/main/LICENSE"

## CoFHCore
main_override 1 "CoFHCore" "https://raw.githubusercontent.com/Jimmy-sheep/CoFHCore/1.18.2/src/main/resources/assets/cofh_core/lang/zh_tw.json" "cofh_core" 

## ThermalFoundation (Guide)
main_override 1 "ThermalFoundation" "https://raw.githubusercontent.com/Jimmy-sheep/ThermalCore/1.19.x/src/main/resources/assets/thermal/lang/zh_tw.json" "thermal" 
main_override 6 "ThermalFoundation Patchouli" "https://github.com/Jimmy-sheep/ThermalFoundation.git" "thermal" "1.18.2" "src/main/resources/data/thermal/patchouli_books/guidebook/zh_tw" "patchouli_books/guide"

## Alchemistry
main_override 1 "Alchemistry" "https://raw.githubusercontent.com/SmashingMods/Alchemistry/1.18.x/src/main/resources/assets/alchemistry/lang/zh_tw.json" "alchemistry" 
license_downloader "Alchemistry" "https://raw.githubusercontent.com/SmashingMods/Alchemistry/1.18.x/LICENSE"

## MMLP CN to ZW
main_override 5 "MMLP CN to ZW" "https://github.com/TeamKugimiya/MMLP-CN-to-ZW/releases/download/latest/MMLP-CN-to-ZW.zip" "" 3
license_downloader "MMLP-CN-to-ZW" "https://raw.githubusercontent.com/CFPAOrg/Minecraft-Mod-Language-Package/main/LICENSE"

# Finish echo

mv "$home_path/assets" "$home_path/main"

echo "✅ 完成所有模組覆蓋執行！"
