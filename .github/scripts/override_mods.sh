#!/bin/bash

## shellcheck disable=2260,2086

## Description of this scripts
echo ">>> 模組翻譯覆蓋腳本 <<<"
echo ">>> 對於一些第三方來源的自動下載覆蓋"
echo ">>> 與部分尚未釋出最新翻譯更新的模組"
echo ">>> 此步驟將會把一些已知的模組翻譯覆蓋掉"

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
    cd "$GITHUB_WORKSPACE" || exit
    # cd ~/workspace/ModsTranslationPack/ || exit
}

# Verify override contents
verify_override_translate_exists () {
    mods_name=$1
    mods_path=$2
    module_mode=$3

    # 模組模式 1 驗證檔案
    if [ "$module_mode" = 1 ]; then
      if [ -f "$mods_path"/zh_tw.json ]; then
        echo "✅ $mods_name 翻譯驗證通過！"
      else
        echo "❎ 錯誤！覆蓋 $mods_name 翻譯失敗。"
        exit 1
      fi
    # 模組模式 2 驗證指南手冊資料夾
    elif [ "$module_mode" = 2 ]; then
      if [ -d "$mods_path" ] && [ "$(ls -A "$mods_path")" ]; then
        echo "✅ $mods_name 指南手冊翻譯驗證通過！"
      else
        echo "❎ 錯誤！覆蓋 $mods_name 書本翻譯失敗。"
        exit 1
      fi
    else
      echo "❗ 錯誤！未指定模組模式或參數錯誤。"
      exit 128
    fi
}

## Downloader Functions

# Mega Downloader

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

## Random Functions

jar_extractor () {
    module_mode=$1
    mods_name=$2
    file_name=$3
    mods_path=$4

    # 模組模式 1 提取模組翻譯
    if [ "$module_mode" = 1 ]; then
      echo "🔧 提取 $mods_name 的翻譯檔..."
      if "$JAVA_HOME_17_X64"/bin/jar xf "$file_name" "$mods_path"; then
        echo "✅ 提取成功！"
      else
        echo "❎ 提取失敗！"
      fi
    # 模組模式 2 提取指南手冊翻譯與模組翻譯
    elif [ "$module_mode" = 2 ]; then
      echo "🔧 提取完整 $mods_name..."
      if "$JAVA_HOME_17_X64"/bin/jar xf "$file_name"; then
        echo "✅ 提取成功！"
      else
        echo "❎ 提取失敗！"
      fi
    else
      echo "❗ 錯誤！未指定模組模式或參數錯誤。"
      exit 128
    fi

    ## For testing
    # # 模組模式 1 提取模組翻譯
    # if [ "$module_mode" = 1 ]; then
    #   echo "🔧 提取 $mods_name 的翻譯檔..."
    #   if jar xf "$file_name" "$mods_path"; then
    #     echo "DEBUG: $mods_path jar xf $file_name $mods_path"
    #     echo "✅ 提取成功！"
    #   else
    #     echo "❎ 提取失敗！"
    #   fi
    # # 模組模式 2 提取指南手冊翻譯與模組翻譯
    # elif [ "$module_mode" = 2 ]; then
    #   echo "🔧 提取完整 $mods_name..."
    #   if jar xf "$file_name"; then
    #     echo "✅ 提取成功！"
    #   else
    #     echo "❎ 提取失敗！"
    #   fi
    # else
    #   echo "❗ 錯誤！未指定模組模式或參數錯誤。"
    #   exit 128
    # fi
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

download_mode_chooser () {
    download_mode=$1
    mods_name=$2
    download_link=$3

    if [ "$download_mode" = 1 ];then
      echo "📥 透過 Mega 下載 $mods_name..."
      mega_downloader "$mods_name" "$download_link"
    elif [ "$download_mode" = 2 ]; then
      echo "📥 透過 MediaFire 下載 $mods_name..."
      mediafire_downloader "$mods_name" "$download_link"
    else
      echo "❗ 錯誤！未指定模組模式或參數錯誤。"
      exit 128
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
    mods_guide_assets_path=$8
    local mods_guide_path_array=$9

    # Some path translate var
    mods_path_lang=$mods_path/lang
    mods_path_lang_file=$mods_path/lang/zh_tw.json

    # 模組模式 1 直接下載並放入指定路徑
    if [ "$module_mode" = 1 ]; then
      echo "🥖 開始覆蓋 $mods_name"
      echo "📁 新增資料夾..."
      mkdir -p "$mods_path_lang"
      github_downloader "$mods_name" "$mods_download_link" "$mods_path_lang"
      echo "⚙️ 驗證翻譯檔案..."
      verify_override_translate_exists "$mods_name" "$mods_path_lang" 1
      echo "🥖 $mods_name 覆蓋完成！"
    # 模組模式 2 解壓縮來自壓縮檔
    elif [ "$module_mode" = 2 ]; then
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
    # 模組模式 3 從 Jar 中提取模組翻譯
    elif [ "$module_mode" = 3 ]; then
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
    # 模組模式 4 從 Jar 中提取指南手冊與模組翻譯
    elif [ "$module_mode" = 4 ]; then
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
      echo " 移動指南手冊翻譯"
      for mods_guide_path in "$workdir_path/$mods_guide_original_path/${!mods_guide_path_array}"; do
        if cp -r "$mods_guide_path" "$mods_guide_assets_path/"; then
          echo "DEBUG: cp -r $mods_guide_path $mods_guide_original_path/"
          echo "✅ 成功將 $mods_guide_path 移動至 $mods_guide_assets_path"
        else
          echo "DEBUG: cp -r $mods_guide_path $mods_guide_original_path/"
          echo "❎ 在移動 $mods_guide_path 時失敗！"
        fi
      done
      echo "⚙️ 驗證翻譯檔案..."
      verify_override_translate_exists "$mods_name" "$mods_path_lang" 1
      echo "⚙️ 驗證指南手冊翻譯..."
      for mods_guide_path in "$mods_guide_assets_path/${!mods_guide_path_array}"; do
        verify_override_translate_exists "$mods_name ($mods_guide_assets_path/$mods_guide_path)" "$mods_guide_path" 2
      done
      echo "🥖 $mods_name 覆蓋完成！"
    fi
}

# Main Function Start

## init function
home
# install_packages (no mega download now, so disabled to speed up the script.)

## Mega

## Mediafire

### Productive Bees (work for short time, and with array break.)
# productive_bees_array=("zh_tw" "en_us")
# main_override 4 "Productive Bees" "https://www.mediafire.com/file/raz0dqfohs5jk29/productivebees-1.19.2-0.10.2.0-tw.jar" "productivebees-1.19.2-0.10.2.0-tw.jar" "productivebees" 2 "data/productivebees/patchouli_books/guide" "assets/productivebees/patchouli_books/guide" "${productive_bees_array[@]}"

### Tinker (still break)
# tinker_guide_array=("tinkers_gadgetry/zh_tw" "puny_smelting/zh_tw" "mighty_smelting/zh_tw" "materials_and_you/zh_tw" "fantastic_foundry/zh_tw" "encyclopedia/zh_tw")
# main_override 4 "Tinkers' Construct" "https://www.mediafire.com/file/phlkrv5v30neayw/TConstruct-1.18.2-3.5.3.63-tw.jar" "TConstruct-1.18.2-3.5.3.63-tw.jar" "tconstruct" 2 "assets/tconstruct/book" "book" "${tinker_guide_array[@]}"

### Mediafire ###

## (Below functions all should work)

## Immersive Engineering
# main_override 2 "Immersive Engineering" "https://www.mediafire.com/file/o5fqhaiqh72p0yd/IE%E6%B2%89%E6%B5%B8%E5%B7%A5%E7%A8%8B%E6%BC%A2%E5%8C%96v1.1.zip" "IE沉浸工程漢化v1.1.zip" "immersiveengineering" 2

## Quark
# main_override 3 "Quark" "https://www.mediafire.com/file/3ivemnio4fdbrzm/Quark-3.3-371-1.19.2-tw.jar" "Quark-3.3-371-1.19.2-tw.jar" "quark" 2

## Macaw's Mods

# main_override 3 "Macaw's Fences and Wall" "https://www.mediafire.com/file/u3rh5jbiu3v7z38/mcw-fences-1.0.6-mc1.19.2-tw.jar" "mcw-fences-1.0.6-mc1.19.2-tw.jar" "mcwfences" 2
# main_override 3 "Macaw's Bridges" "https://www.mediafire.com/file/7gs77nfermk672v/mcw-bridges-2.0.5-mc1.19.2forge-tw.jar" "mcw-bridges-2.0.5-mc1.19.2forge-tw.jar" "mcwbridges" 2
# main_override 3 "Macaw's Trapdoors" "https://www.mediafire.com/file/nk7eaw040lxgant/mcw-trapdoors-1.0.7-mc1.19.2-tw.jar" "mcw-trapdoors-1.0.7-mc1.19.2-tw.jar" "mcwtrpdoors" 2
# main_override 3 "Macaw's Doors" "https://www.mediafire.com/file/o97axparlovckcs/mcw-doors-1.0.7-mc1.19.2-tw.jar" "mcw-doors-1.0.7-mc1.19.2-tw.jar" "mcwdoors" 2
# main_override 3 "Macaw's Roofs" "https://www.mediafire.com/file/byxuw1rwctldzzx/mcw-roofs-2.2.1-mc1.19.2-forge-tw.jar" "mcw-roofs-2.2.1-mc1.19.2-forge-tw.jar" "mcwroofs" 2
# main_override 3 "Macaw's Furniture" "https://www.mediafire.com/file/cfvsk3q0rq1uukn/mcw-furniture-3.0.2-mc1.19.2-tw.jar" "mcw-furniture-3.0.2-mc1.19.2-tw.jar" "mcwfurnitures" 2
# main_override 3 "Macaw's Windows" "https://www.mediafire.com/file/0rg7xgvj71v4hhg/mcw-windows-2.0.3-mc1.19-tw.jar" "mcw-windows-2.0.3-mc1.19-tw.jar" "mcwwindows" 2

## Simply Light
# main_override 3 "Simply Light" "https://www.mediafire.com/file/zoo24n15x9lrdlq/simplylight-1.19-1.4.2-build.35-tw.jar" "simplylight-1.19-1.4.2-build.35-tw.jar" "simplylight" 2

## Supplementaries
# main_override 3 "Supplementaries" "https://www.mediafire.com/file/lu2bxls9485h9i7/supplementaries-1.19.2-2.2.22-tw.jar" "supplementaries-1.19.2-2.2.22-tw.jar" "supplementaries" 2

### GitHub ###

## Dynamic FPS
# main_override 1 "Dynamic FPS" "https://raw.githubusercontent.com/juliand665/Dynamic-FPS/main/src/main/resources/assets/dynamicfps/lang/zh_tw.json" "" "dynamicfps"

## CoFHCore
# main_override 1 "CoFHCore" "https://raw.githubusercontent.com/Jimmy-sheep/CoFHCore/1.18.2/src/main/resources/assets/cofh_core/lang/zh_tw.json" "" "cofh_core" 

## ThermalFoundation
# main_override 1 "ThermalFoundation" "https://raw.githubusercontent.com/Jimmy-sheep/ThermalFoundation/1.18.2/src/main/resources/assets/thermal/lang/zh_tw.json" "" "thermal" 
