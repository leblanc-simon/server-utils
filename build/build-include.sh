#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

cd ${SCRIPT_DIR}/../command
if [ $? -ne 0 ]; then
    exit 1
fi

command_files=$(find . -type f -name '*.nim')

commands="# Commands import\n"
commandlines="# Command defined\n"
commandprocess="# Commands processed\n"
commandhelp="# Commands help\n"

function convertFileToImportName {
    local filenameWithoutExtension="${1%.nim}"
    local importName=$(echo "${filenameWithoutExtension#*.}" | sed -r 's#(^|/)(\w)#\U\2#g')
    echo "command${importName}"
}

function getImport {
    local filenameWithoutExtension="${1%.nim}"
    local importName="$2"

    echo "import ../command${filenameWithoutExtension#*.} as ${importName}"
}

lastDir=""

for command_file in ${command_files}; do
    if [ "${command_file}" == './command.nim' ]; then
        continue
    fi

    currentDir=$(echo ${command_file} | sed -Ee 's#^./([a-z]+)/.*$#\1#')

    if [ "${lastDir}" != "${currentDir}" ]; then
        commands="${commands}\n"
        commandlines="${commandlines}\n"
        commandprocess="${commandprocess}\n"
        commandhelp="${commandhelp}\n"
    fi
    lastDir="${currentDir}"

    importName=$(convertFileToImportName ${command_file})

    commands="${commands}$(getImport ${command_file} ${importName})\n"
    commandlines="${commandlines}${importName}.addCommand()\n"
    commandprocess="${commandprocess}${importName}.addProcess()\n"
    commandhelp="${commandhelp}${importName}.addHelp()\n"

done

echo -ne ${commands} > "${SCRIPT_DIR}/../include/commands.nim"
echo -ne ${commandlines} > "${SCRIPT_DIR}/../include/commandlines.nim"
echo -ne ${commandprocess} > "${SCRIPT_DIR}/../include/commandprocess.nim"
echo -ne ${commandhelp} > "${SCRIPT_DIR}/../include/commandhelp.nim"

exit 0