#!/bin/bash

# Specify the line number below which the file content should be cut
LINE_NUMBER=367

# Store the new content to replace the cut portion of the file
NEW_CONTENT=$(cat .github/configs/override_list.txt)
# Specify the file to modify
FILE_TO_MODIFY=".github/scripts/override_mods.sh"

# Cut the file content below the specified line number
sed -i "${LINE_NUMBER},$ d" ${FILE_TO_MODIFY}

# Insert the new content
echo "${NEW_CONTENT}" >> ${FILE_TO_MODIFY}

# Modify path
sed -i 's+\/MultiVersions\/Override\/++g' .github/scripts/override_mods.sh
