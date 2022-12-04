#!/bin/bash

# shellcheck disable=2260,2086

echo ">>> 模組翻譯覆蓋腳本 <<<"
echo ">>> 某些模組的翻譯如果搭配其他翻譯包"
echo ">>> 所使用會將翻譯好的內容變成未翻譯"
echo ">>> 此步驟將會把一些已知的模組翻譯覆蓋掉"

## Tool Install

installer_packages () {
    sudo apt-get update > /dev/null
    sudo apt-get install -y megatools > /dev/null
}

## Common Function

# Retrun to workspace root
home () {
    cd "$GITHUB_WORKSPACE" || exit
}

# Make workdir 
mk_workdir () {
    mkdir workdir
    cd workdir || exit
}

# Remove workdir
rm_workdir () {
    rm -r workdir
}

## Verify Function

# Verify Translate File is exist
verify_translate_exist () {
    if [ -f "$2/zh_tw.json" ]; then
        echo "翻譯驗證通過！"
    else 
        echo "錯誤！覆蓋 $1 翻譯失敗。"
        exit 1
    fi
}

# Verify Book Translate Folder is exist
verify_books_translate_exists () {
    if [ -d "$2" ]
    then
        if [ "$(ls -A $2)" ]; then
        echo "書本翻譯驗證通過！（$2）"
        else
        echo "錯誤！ $2 中並未存在任何資料夾或檔案。"
        fi
    else
        echo "錯誤！$1 的覆蓋資料夾未找到。"
        exit 1
    fi
}

## Common Downloader

mega_Downloader () {
    echo ">> 小資訊:"
    echo ">> megatools 並不知道原始連結是甚麼"
    echo ">> 這邊有一個修正連結的問題 https://github.com/megous/megatools/issues/157#issuecomment-615835778"

    echo "(Mega) 正在下載 $1 ..."
    megadl "$2"
}

mediafire_Downloader () {
    echo "(Mediafire) 正在下載 $1 ..."
    wget -q "$(wget -qO - "$2" | grep 'id="downloadButton"' | grep -Po '(?<=href=")[^"]*')"
}

direct_Downloader () {
    echo "(Wget) 正在下載 $1 到指定路徑..."
    wget -q $2 -P $3
}

## Override 

# Mega
mega_override () {
    mk_workdir
    pwd

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEGA=$2

    # Mega Download
    mega_Downloader $1 $3

    echo "解壓縮 $4"
    unzip -q "$4"

    echo "回到工作目錄..."
    home

    echo "移動 $1 的翻譯內容..."
    mv workdir/$PATH_MEGA assets

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEGA/lang"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}

# Mediafire
mediafire_override () {
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEDIAFIRE=$2

    # Mediafire Download
    mediafire_Downloader $1 $3

    echo "取出 $1 翻譯檔"
    $JAVA_HOME_17_X64/bin/jar xf $4 $PATH_MEDIAFIRE/zh_tw.json

    echo "回到工作目錄..."
    home

    echo "創建 $1 語言資料夾..."
    mkdir -p $PATH_MEDIAFIRE

    echo "複製 $1 的翻譯內容..."
    cp workdir/$PATH_MEDIAFIRE/zh_tw.json $PATH_MEDIAFIRE/

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEDIAFIRE"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}

mediafire_override_resourcepack () {
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEDIAFIRE_RES=$2

    # Mediafire Download
    mediafire_Downloader $1 $3

    echo "解壓縮 $1"
    unzip -q "$4"

    echo "回到工作目錄..."
    home

    echo "複製 $1 的翻譯內容..."
    mv workdir/$PATH_MEDIAFIRE_RES assets

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEDIAFIRE_RES/lang"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}

mediafire_tinker_override () {
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEDIAFIRE_TINKER=$2
    PATH_MEDIAFIRE_TINKER_BOOKS=$3

    # Mediafire Download
    mediafire_Downloader $1 $4

    echo "解壓縮 $1 Jar"
    $JAVA_HOME_17_X64/bin/jar xf $5

    echo "回到工作目錄..."
    home

    echo "創建 $1 語言資料夾..."
    mkdir -p $PATH_MEDIAFIRE_TINKER

    echo "複製 $1 的翻譯內容..."
    cp workdir/$PATH_MEDIAFIRE_TINKER/zh_tw.json $PATH_MEDIAFIRE_TINKER/

    echo "創建 $1 書本資料夾"
    mkdir -p $PATH_MEDIAFIRE_TINKER_BOOKS/tinkers_gadgetry
    mkdir -p $PATH_MEDIAFIRE_TINKER_BOOKS/puny_smelting
    mkdir -p $PATH_MEDIAFIRE_TINKER_BOOKS/mighty_smelting
    mkdir -p $PATH_MEDIAFIRE_TINKER_BOOKS/materials_and_you
    mkdir -p $PATH_MEDIAFIRE_TINKER_BOOKS/fantastic_foundry
    mkdir -p $PATH_MEDIAFIRE_TINKER_BOOKS/encyclopedia

    echo "複製 $1 的書本內容..."
    cp -r workdir/$PATH_MEDIAFIRE_TINKER_BOOKS/tinkers_gadgetry/zh_tw $PATH_MEDIAFIRE_TINKER_BOOKS/tinkers_gadgetry
    cp -r workdir/$PATH_MEDIAFIRE_TINKER_BOOKS/puny_smelting/zh_tw $PATH_MEDIAFIRE_TINKER_BOOKS/puny_smelting
    cp -r workdir/$PATH_MEDIAFIRE_TINKER_BOOKS/mighty_smelting/zh_tw $PATH_MEDIAFIRE_TINKER_BOOKS/mighty_smelting
    cp -r workdir/$PATH_MEDIAFIRE_TINKER_BOOKS/materials_and_you/zh_tw $PATH_MEDIAFIRE_TINKER_BOOKS/materials_and_you
    cp -r workdir/$PATH_MEDIAFIRE_TINKER_BOOKS/fantastic_foundry/zh_tw $PATH_MEDIAFIRE_TINKER_BOOKS/fantastic_foundry
    cp -r workdir/$PATH_MEDIAFIRE_TINKER_BOOKS/encyclopedia/zh_tw $PATH_MEDIAFIRE_TINKER_BOOKS/encyclopedia

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEDIAFIRE_TINKER"

    echo "檢查 $1 覆蓋書本內容是否存在"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS/tinkers_gadgetry"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS/puny_smelting"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS/mighty_smelting"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS/materials_and_you"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS/fantastic_foundry"
    verify_books_translate_exists "$1" "$PATH_MEDIAFIRE_TINKER_BOOKS/encyclopedia"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}

mediafire_productive_bees_override () {
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEDIAFIRE_PRODUCTIVE_BEES=$2
    PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS=$3

    # Mediafire Download
    mediafire_Downloader $1 $4

    echo "解壓縮 $1 Jar"
    $JAVA_HOME_17_X64/bin/jar xf $5

    echo "回到工作目錄..."
    home

    echo "創建 $1 語言資料夾..."
    mkdir -p $PATH_MEDIAFIRE_PRODUCTIVE_BEES

    echo "複製 $1 的翻譯內容..."
    cp workdir/$PATH_MEDIAFIRE_PRODUCTIVE_BEES/zh_tw.json $PATH_MEDIAFIRE_PRODUCTIVE_BEES/

    echo "創建 $1 書本資料夾"
    mkdir -p assets/$PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS/guide

    echo "複製 $1 的書本內容..."
    cp -r workdir/data/$PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS/guide/zh_tw assets/$PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS/guide
    cp workdir/data/$PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS/guide/book.json assets/$PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS/guide

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEDIAFIRE_PRODUCTIVE_BEES"

    echo "檢查 $1 覆蓋書本內容是否存在"
    verify_books_translate_exists "$1" "assets/$PATH_MEDIAFIRE_PRODUCTIVE_BEES_BOOKS/guide/"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}

github_override () {
    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_GITHUB=$2

    echo "創建 $1 語言資料夾..."
    mkdir -p $PATH_GITHUB

    # Direct Download
    direct_Downloader $1 $3 $PATH_GITHUB

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_GITHUB"

    echo "完成 $1 覆蓋！"
}

## Main

home
installer_packages

## Mega

## Mediafire

### Productive Bees (特殊)
mediafire_productive_bees_override "Productive Bees" "assets/productivebees/lang" "productivebees/patchouli_books" "https://www.mediafire.com/file/raz0dqfohs5jk29/productivebees-1.19.2-0.10.2.0-tw.jar" "productivebees-1.19.2-0.10.2.0-tw.jar"

### Tinker (特殊)
mediafire_tinker_override "Tinkers' Construct" "assets/tconstruct/lang" "assets/tconstruct/book" "https://www.mediafire.com/file/snogv3qqn57o8rf/TConstruct-1.18.2-3.5.2.40-tw.jar" "TConstruct-1.18.2-3.5.2.40-tw.jar"

### Quark
mediafire_override "Quark" "assets/quark/lang" "https://www.mediafire.com/file/3ivemnio4fdbrzm/Quark-3.3-371-1.19.2-tw.jar" "Quark-3.3-371-1.19.2-tw.jar"

### Macaw's Mods

mediafire_override "Macaw's Fences and Wall" "assets/mcwfences/lang" "https://www.mediafire.com/file/u3rh5jbiu3v7z38/mcw-fences-1.0.6-mc1.19.2-tw.jar" "mcw-fences-1.0.6-mc1.19.2-tw.jar"
mediafire_override "Macaw's Bridges" "assets/mcwbridges/lang" "https://www.mediafire.com/file/7gs77nfermk672v/mcw-bridges-2.0.5-mc1.19.2forge-tw.jar" "mcw-bridges-2.0.5-mc1.19.2forge-tw.jar"
mediafire_override "Macaw's Trapdoors" "assets/mcwtrpdoors/lang" "https://www.mediafire.com/file/nk7eaw040lxgant/mcw-trapdoors-1.0.7-mc1.19.2-tw.jar" "mcw-trapdoors-1.0.7-mc1.19.2-tw.jar"
mediafire_override "Macaw's Doors" "assets/mcwdoors/lang" "https://www.mediafire.com/file/o97axparlovckcs/mcw-doors-1.0.7-mc1.19.2-tw.jar" "mcw-doors-1.0.7-mc1.19.2-tw.jar"
mediafire_override "Macaw's Roofs" "assets/mcwroofs/lang" "https://www.mediafire.com/file/byxuw1rwctldzzx/mcw-roofs-2.2.1-mc1.19.2-forge-tw.jar" "mcw-roofs-2.2.1-mc1.19.2-forge-tw.jar"
mediafire_override "Macaw's Furniture" "assets/mcwfurnitures/lang" "https://www.mediafire.com/file/cfvsk3q0rq1uukn/mcw-furniture-3.0.2-mc1.19.2-tw.jar" "mcw-furniture-3.0.2-mc1.19.2-tw.jar"
mediafire_override "Macaw's Windows" "assets/mcwwindows/lang" "https://www.mediafire.com/file/0rg7xgvj71v4hhg/mcw-windows-2.0.3-mc1.19-tw.jar" "mcw-windows-2.0.3-mc1.19-tw.jar"

### Immersive Engineering
mediafire_override_resourcepack "Immersive Engineering" "assets/immersiveengineering" "https://www.mediafire.com/file/o5fqhaiqh72p0yd/IE%E6%B2%89%E6%B5%B8%E5%B7%A5%E7%A8%8B%E6%BC%A2%E5%8C%96v1.1.zip" "IE沉浸工程漢化v1.1.zip"

### Simply Light
mediafire_override "Simply Light" "assets/simplylight/lang" "https://www.mediafire.com/file/zoo24n15x9lrdlq/simplylight-1.19-1.4.2-build.35-tw.jar" "simplylight-1.19-1.4.2-build.35-tw.jar"

### Supplementaries
mediafire_override "Supplementaries" "assets/supplementaries/lang" "https://www.mediafire.com/file/lu2bxls9485h9i7/supplementaries-1.19.2-2.2.22-tw.jar" "supplementaries-1.19.2-2.2.22-tw.jar"

## GitHub

### Dynamic FPS
github_override "Dynamic FPS" "assets/dynamicfps/lang" "https://raw.githubusercontent.com/juliand665/Dynamic-FPS/main/src/main/resources/assets/dynamicfps/lang/zh_tw.json"
