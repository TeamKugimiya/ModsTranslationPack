#!/bin/bash

list_dir () {
  find ../assets/ -maxdepth 1 -type d -exec echo "$1" \; > "$2"
}

readme_generate () {
    file_name=readme_result.md
    list_dir '<li>{}</li>' $file_name
    sed -i "s+<li>../assets/</li>++" $file_name
    sed -i "s+<li>../assets/minecraft</li>++" $file_name
    sed -i "s+../assets/++" $file_name
    sed -i "/^$/d" $file_name
}

modslist_generate () {
    file_name=modslist_result.md
    list_dir '| {} | :x: |  |' $file_name
    sed -i "1s+| ../assets/ | :x: |  |++" $file_name
    sed -i "s+| {} | ../assets/minecraft | :x: |  |++" $file_name
    sed -i "s+../assets/++" $file_name
    sed -i "/^$/d" $file_name
}

modslist_added_generate () {
    file_name=modslist_result.md
    x_placeholder=" | :x: |  |"
    x_x_placeholder=" | :x: |"
    question_placeholder=" | :question: |"
    check_placeholder=" | :heavy_check_mark: |"
    # sed -i "s+MODNAME$x_placeholder+MODNAME$check_placeholder [已回饋]() |+" $file_name

    sed -i "s+screencapper$x_placeholder+screencapper$check_placeholder [已回饋](https://github.com/Deftu/Screencapper/pull/6)，但翻譯有變動，需再度 PR |+" $file_name
    sed -i "s+sodium$x_placeholder+sodium$x_x_placeholder 由於 Crowdin 並未連上主專案進行同步翻譯 |+" $file_name
    sed -i "s+sodium-extra$x_placeholder+sodium-extra$check_placeholder 已提交上 Crowdin |+" $file_name
    sed -i "s+automodpack$x_placeholder+automodpack$check_placeholder [已回饋](https://github.com/Skidamek/AutoModpack/pull/64) |+" $file_name
    sed -i "s+energymeter$x_placeholder+energymeter$question_placeholder [等待合併](https://github.com/AlmostReliable/energymeter-forge/pull/26) |+" $file_name
    sed -i "s+fluxnetworks$x_placeholder+fluxnetworks$check_placeholder [已回饋](https://github.com/SonarSonic/Flux-Networks/pull/482)，需要更新。 |+" $file_name
    sed -i "s+trashcans$x_placeholder+trashcans$question_placeholder [等待合併](https://github.com/SuperMartijn642/TrashCans/pull/20) |+" $file_name
}

readme_generate
modslist_generate
modslist_added_generate
