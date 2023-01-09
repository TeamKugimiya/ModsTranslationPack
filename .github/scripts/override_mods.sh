#!/bin/bash

## Description of this scripts
echo ">>> 模組翻譯覆蓋腳本 <<<"
echo ">>> 對於一些第三方來源的自動下載覆蓋"
echo ">>> 與部分尚未釋出最新翻譯更新的模組"
echo ">>> 此步驟將會把一些已知的模組翻譯覆蓋掉"

## DEBUG Var

# java_path=$(which jar)
java_home_path=${java_path:-$JAVA_HOME_17_X64/bin/jar}

# home=$HOME/workspace/ModsTranslationPack/test
home_path=${home:-$GITHUB_WORKSPACE}

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

# Error function
error () {
    echo "❗ 錯誤！未指定模組模式或參數錯誤。"
    exit 128
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
       error
       ;;
      esac
}

## Downloader Functions

mega_downloader () {
    mods_name=$1
    download_link=$2

    echo "📁 下載 $mods_name 中..."
    if megadl "$download_link"; then
      echo "✅ 下載完成！"
    else
      echo "❎ 下載失敗！"
    fi
}

mediafire_downloader () {
    mods_name=$1
    download_link=$2

    echo "📁 下載 $mods_name 中..."
    if wget -q "$(wget -qO - "$download_link" | grep 'id="downloadButton"' | grep -Po '(?<=href=")[^"]*')"; then
      echo "✅ 下載完成！"
    else
      echo "❎ 下載失敗！"
    fi
}

github_downloader () {
    mods_name=$1
    download_link=$2
    download_file_path=$3

    echo "📁 下載 $mods_name 中..."
    if wget -q "$download_link" -P "$download_file_path"; then
      echo "✅ 下載完成！"
    else
      echo "❎ 下載失敗！"
    fi
}

download_mode_chooser () {
    download_mode=$1
    mods_name=$2
    download_link=$3

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
        github_downloader "$mods_name" "$download_link"
        ;;
      *)
        error
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
        if "$java_home_path" xf "$file_name" "$mods_path"; then
          echo "✅ 提取成功！"
        else
          echo "❎ 提取失敗！"
        fi
        ;;
      # 模組模式 2 提取指南手冊翻譯與模組翻譯
      "2")
        echo "🔧 提取完整 $mods_name..."
        if "$java_home_path" xf "$file_name"; then
          echo "✅ 提取成功！"
        else
          echo "❎ 提取失敗！"
        fi
        ;;
      *)
        error
        ;;
      esac
}

zip_extractor () {
    mods_name=$1
    file_name=$2

    echo "📦 解壓縮 $mods_name 檔案..."
    if unzip -q "$file_name"; then
      echo "✅ 解壓縮成功！"
    else
      echo "❎ 解壓縮失敗！"
    fi
}

# License Downloader

license_downloader () {
    mods_name=$1
    license_link=$2

    echo "🪪 下載 $mods_name 授權條款..."
    if wget -q "$license_link" -O "LICENSE_$mods_name"; then
      echo "✅ 下載完成！"
      echo "   "
    else
      echo "❎ 下載失敗！"
    fi
}

## Main Override Functions

main_override () {
    module_mode=$1
    mods_name=$2
    mods_download_link=$3
    mods_file_name=$4
    mods_path=assets/$5
    download_mode=$6
    mods_guide_original_path=$7
    mods_guide_assets_path=$mods_path/$8
    local -n mods_guide_path_array=${9:-null}
    mods_guide_mode=${10}

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
            error
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
      "5")
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
        cp -r "$workdir_path"/assets/* assets
        echo "🥖 $mods_name 覆蓋完成！"
        echo "   "
        ;;
      *)
        error
      esac
}

# Main Function Start

## init function
home
# install_packages (no mega download now, so disabled to speed up the script.)

## 使用解說 ##
# main_override *1模組模式 模組名稱 模組覆蓋連結 *2模組覆蓋檔案名 模組assetsID *3下載模式 *4指南手冊原始路徑 *5指南手冊assets路徑 *6指南手冊陣列 *7特殊模式
#
# *1 模組模式總共有四種
#    - 1 直接下載並放入指定路徑
#    - 2 解壓縮來自壓縮檔
#    - 3 從 Jar 中提取模組翻譯
#    - 4 從 Jar 中提取指南手冊與模組翻譯
#
# *2 模組覆蓋檔案名當使用模組模式 1 時將可以為空
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

### Mediafire ###

### Productive Bees (Guide) 
# shellcheck disable=SC2034
productive_bees_array=("zh_tw")
main_override 4 "Productive Bees" "https://www.mediafire.com/file/raz0dqfohs5jk29/productivebees-1.19.2-0.10.2.0-tw.jar" "productivebees-1.19.2-0.10.2.0-tw.jar" "productivebees" 2 "data/productivebees/patchouli_books/guide" "patchouli_books/guide" productive_bees_array 1

### Tinker (Guide)
# shellcheck disable=SC2034
tinker_guide_array=("tinkers_gadgetry/zh_tw" "puny_smelting/zh_tw" "mighty_smelting/zh_tw" "materials_and_you/zh_tw" "fantastic_foundry/zh_tw" "encyclopedia/zh_tw")
main_override 4 "Tinkers' Construct" "https://www.mediafire.com/file/phlkrv5v30neayw/TConstruct-1.18.2-3.5.3.63-tw.jar" "TConstruct-1.18.2-3.5.3.63-tw.jar" "tconstruct" 2 "assets/tconstruct/book" "book" tinker_guide_array 2

## Immersive Engineering
main_override 2 "Immersive Engineering" "https://www.mediafire.com/file/o5fqhaiqh72p0yd/IE%E6%B2%89%E6%B5%B8%E5%B7%A5%E7%A8%8B%E6%BC%A2%E5%8C%96v1.1.zip" "IE沉浸工程漢化v1.1.zip" "immersiveengineering" 2

## Quark
# main_override 3 "Quark" "https://www.mediafire.com/file/3ivemnio4fdbrzm/Quark-3.3-371-1.19.2-tw.jar" "Quark-3.3-371-1.19.2-tw.jar" "quark" 2

## Macaw's Mods

main_override 3 "Macaw's Fences and Wall" "https://www.mediafire.com/file/gzbayubyq7e8rrb/mcw-fences-1.0.7-mc1.19.2forge-tw.jar" "mcw-fences-1.0.7-mc1.19.2forge-tw.jar" "mcwfences" 2
main_override 3 "Macaw's Bridges" "https://www.mediafire.com/file/f508an5jjm6m4u1/mcw-bridges-2.0.6-mc1.19.3forge-tw.jar" "mcw-bridges-2.0.6-mc1.19.3forge-tw.jar" "mcwbridges" 2
main_override 3 "Macaw's Trapdoors" "https://www.mediafire.com/file/nk7eaw040lxgant/mcw-trapdoors-1.0.7-mc1.19.2-tw.jar" "mcw-trapdoors-1.0.7-mc1.19.2-tw.jar" "mcwtrpdoors" 2
main_override 3 "Macaw's Doors" "https://www.mediafire.com/file/o97axparlovckcs/mcw-doors-1.0.7-mc1.19.2-tw.jar" "mcw-doors-1.0.7-mc1.19.2-tw.jar" "mcwdoors" 2
main_override 3 "Macaw's Roofs" "https://www.mediafire.com/file/byxuw1rwctldzzx/mcw-roofs-2.2.1-mc1.19.2-forge-tw.jar" "mcw-roofs-2.2.1-mc1.19.2-forge-tw.jar" "mcwroofs" 2
main_override 3 "Macaw's Furniture" "https://www.mediafire.com/file/cfvsk3q0rq1uukn/mcw-furniture-3.0.2-mc1.19.2-tw.jar" "mcw-furniture-3.0.2-mc1.19.2-tw.jar" "mcwfurnitures" 2
main_override 3 "Macaw's Windows" "https://www.mediafire.com/file/0rg7xgvj71v4hhg/mcw-windows-2.0.3-mc1.19-tw.jar" "mcw-windows-2.0.3-mc1.19-tw.jar" "mcwwindows" 2

## Simply Light
main_override 3 "Simply Light" "https://www.mediafire.com/file/vcozdmfxucxdfn1/simplylight-1.19.3-1.4.5-build.46-tw.jar" "simplylight-1.19.3-1.4.5-build.46-tw.jar" "simplylight" 2

## Supplementaries
main_override 3 "Supplementaries" "https://www.mediafire.com/file/ppq1oka7kyckwhd/supplementaries-1.19.2-2.2.32-tw.jar" "supplementaries-1.19.2-2.2.32-tw.jar" "supplementaries" 2

## MrCrayfish's Furniture Mod
main_override 3 "MrCrayfish's Furniture Mod" "https://www.mediafire.com/file/v6zk7kbq5nk74ne/cfm-7.0.0-pre34-mc1.19-tw.jar" "cfm-7.0.0-pre34-mc1.19-tw.jar" "cfm" 2

## Cooking for Blockheads
main_override 3 "Cooking for Blockheads" "https://www.mediafire.com/file/q2lep7wvg3y3wft/cookingforblockheads-forge-1.19.3-14.0.1-tw.jar" "cookingforblockheads-forge-1.19.3-14.0.1-tw.jar" "cookingforblockheads" 2

### GitHub ###

## Dynamic FPS
main_override 1 "Dynamic FPS" "https://raw.githubusercontent.com/juliand665/Dynamic-FPS/main/src/main/resources/assets/dynamicfps/lang/zh_tw.json" "" "dynamicfps"
license_downloader "DynamicFPS" "https://raw.githubusercontent.com/juliand665/Dynamic-FPS/main/LICENSE"

## CoFHCore
main_override 1 "CoFHCore" "https://raw.githubusercontent.com/CoFH/CoFHCore/1.18.2/src/main/resources/assets/cofh_core/lang/zh_tw.json" "" "cofh_core" 

## ThermalFoundation
main_override 1 "ThermalFoundation" "https://raw.githubusercontent.com/Jimmy-sheep/ThermalFoundation/1.18.2/src/main/resources/assets/thermal/lang/zh_tw.json" "" "thermal" 

# ## Alchemistry
main_override 1 "Alchemistry" "https://raw.githubusercontent.com/SmashingMods/Alchemistry/1.18.x/src/main/resources/assets/alchemistry/lang/zh_tw.json" "" "alchemistry" 
license_downloader "Alchemistry" "https://raw.githubusercontent.com/SmashingMods/Alchemistry/1.18.x/LICENSE"

## MMLP CN to ZW
main_override 5 "MMLP CN to ZW" "https://github.com/TeamKugimiya/MMLP-CN-to-ZW/releases/download/latest/MMLP-CN-to-ZW.zip" "MMLP-CN-to-ZW.zip" "" 3
license_downloader "MMLP-CN-to-ZW" "https://raw.githubusercontent.com/CFPAOrg/Minecraft-Mod-Language-Package/main/LICENSE"

# Finish echo

echo "✅ 完成所有模組覆蓋執行！"
