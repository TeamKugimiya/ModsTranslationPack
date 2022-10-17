#!/bin/bash

# shellcheck disable=2260,2086

echo ">>> 模組翻譯覆蓋腳本 <<<"
echo ">>> 某些模組的翻譯如果搭配其他翻譯包"
echo ">>> 所使用會將翻譯好的內容變成未翻譯"
echo ">>> 此步驟將會把一些已知的模組翻譯覆蓋掉"

home () {
    cd "$GITHUB_WORKSPACE" || exit
}

mk_workdir () {
    mkdir workdir
    cd workdir || exit
}

rm_workdir () {
    rm -r workdir
}

verify_translate_exist () {
    if [ -f "$2/zh_tw.json" ]; then
        echo "翻譯驗證通過！"
    else 
        echo "錯誤！覆蓋 $1 翻譯失敗。"
        exit 1
    fi
}

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

mega_override () {
    mk_workdir
    pwd

    echo "小資訊:"
    echo "megatools 並不知道原始連結是甚麼"
    echo "這邊有一個修正連結的問題 https://github.com/megous/megatools/issues/157#issuecomment-615835778"

    echo "安裝 megatools..."
    sudo apt-get update
    sudo apt-get install -y megatools

    echo "覆蓋 $1..."

    echo "設置 $2 路徑變數"
    PATH_MEGA=$3

    echo "下載 $1..."
    megadl "$4"

    echo "解壓縮 $5"
    unzip "$5"

    echo "回到工作目錄..."
    cd ..

    echo "移動 $1 的翻譯內容..."
    mv workdir/$PATH_MEGA assets

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEGA/lang"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}


mediafire_override () {
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEDIAFIRE=$2

    echo "下載 $1"
    wget -q "$(wget -qO - "$3" | grep 'id="downloadButton"' | grep -Po '(?<=href=")[^"]*')"

    echo "取出 $1 翻譯檔"
    $JAVA_HOME_17_X64/bin/jar xf $4 $PATH_MEDIAFIRE/zh_tw.json

    echo "回到工作目錄..."
    cd ..

    echo "創建 $1 語言資料夾..."
    mkdir -p $PATH_MEDIAFIRE

    echo "複製 $1 的翻譯內容..."
    cp workdir/$PATH_MEDIAFIRE/zh_tw.json $PATH_MEDIAFIRE/

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_MEDIAFIRE"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}
          

mediafire_tinker_override () {
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_MEDIAFIRE_TINKER=$2
    PATH_MEDIAFIRE_TINKER_BOOKS=$3

    echo "下載 $1"
    wget -q "$(wget -qO - "$4" | grep 'id="downloadButton"' | grep -Po '(?<=href=")[^"]*')"

    echo "解壓縮 $1 Jar"
    $JAVA_HOME_17_X64/bin/jar xf $5

    echo "回到工作目錄..."
    cd ..

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

    echo "下載 $1"
    wget -q "$(wget -qO - "$4" | grep 'id="downloadButton"' | grep -Po '(?<=href=")[^"]*')"

    echo "解壓縮 $1 Jar"
    $JAVA_HOME_17_X64/bin/jar xf $5

    echo "回到工作目錄..."
    cd ..

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
    mk_workdir

    echo "覆蓋 $1..."

    echo "設置 $1 路徑變數"
    PATH_GITHUB=$2

    echo "創建 $1 語言資料夾..."
    mkdir -p $PATH_GITHUB

    echo "下載 $1 翻譯檔案到語言資料夾內..."
    wget -q $3 -P $PATH_GITHUB

    echo "檢查 $1 覆蓋內容是否存在"
    verify_translate_exist "$1" "$PATH_GITHUB"

    echo "完成 $1 覆蓋！清理工作資料夾"
    rm_workdir
}

# Main

## 回到工作目錄
home

## Mega

### BloodMagic
mega_override "BloodMagic" "BLOODMAGIC" "assets/bloodmagic" "https://mega.nz/#!KR0CQC5Z!MkEdb3M5q9FHLIgY7WLE18T8EqKFMVUd1guryQWdTQc" "1.18 BloodMagic-zh_tw-v2.zip"
echo "修正 BloodMagic 的全形空格"
sed -i 's/	//1' assets/bloodmagic/patchouli_books/guide/zh_tw/entries/altar/soul_network.json

## Mediafire

### ProjectE
mediafire_override "ProjectE" "assets/projecte/lang" "https://www.mediafire.com/file/uhtspihpscmrqsb/ProjectE-1.19.2-PE1.0.1B-tw.jar" "ProjectE-1.19.2-PE1.0.1B-tw.jar"

### The Twilight Forest
mediafire_override "The Twilight Forest" "assets/twilightforest/lang" "https://www.mediafire.com/file/kl96rxo50e68j93/twilightforest-1.18.2-4.1.1423-universal-tw.jar" "twilightforest-1.18.2-4.1.1423-universal-tw.jar"

### Productive Bees (特殊)
mediafire_productive_bees_override "Productive Bees" "assets/productivebees/lang" "productivebees/patchouli_books" "https://www.mediafire.com/file/raz0dqfohs5jk29/productivebees-1.19.2-0.10.2.0-tw.jar" "productivebees-1.19.2-0.10.2.0-tw.jar"

### Tinker (特殊)
mediafire_tinker_override "Tinkers' Construct" "assets/tconstruct/lang" "assets/tconstruct/book" "https://www.mediafire.com/file/snogv3qqn57o8rf/TConstruct-1.18.2-3.5.2.40-tw.jar" "TConstruct-1.18.2-3.5.2.40-tw.jar"

## GitHub

### Create
# github_override "Create" "assets/create/lang" "https://raw.githubusercontent.com/Creators-of-Create/Create/mc1.18/dev/src/main/resources/assets/create/lang/zh_tw.json"
