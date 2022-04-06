import std/os
import std/osproc
import std/strutils
import system
from posix import read, write, fdatasync, close

#[
    Vérifie qu'un binaire PHP est bien la version voulue
]#
proc checkVersionPhp(binary: string, version: string): bool =
    var process = startProcess(binary, "", ["--version"])

    var output = outputHandle(process)
    var buffer = newstring(10)
    var realVersion = ""

    while true:
        var rc = read(output, buffer.cstring, buffer.len)
        if rc <= 0:
            break
        realVersion.add(buffer[0..rc-1])
    
    close(process)

    return contains(realVersion, version)

#[
    Récupération du chemin complet d'un binaire php en fonction de sa version
]#
proc getPhpBin*(version: string): string {.raises: [IOError, OSError, Exception].} =
    let paths: array[13, string] = [
        "/opt/php/8.1/bin",
        "/opt/php/8.0/bin",
        "/opt/php/7.4/bin",
        "/opt/php/7.3/bin",
        "/opt/php/7.2/bin",
        "/opt/php/7.1/bin",
        "/opt/php/7.0/bin",
        "/opt/php/5.6/bin",
        "/opt/php/5.5/bin",
        "/opt/php/5.4/bin",
        "/opt/php/5.3/bin",
        "/opt/php/5.2/bin",
        "/opt/php/4.4/bin",
    ]

    for path in paths:
        var binary: string = findExe(path & "/php")
        if "" != binary and checkVersionPhp(binary, version):
            return binary

    var binary: string = findExe("php")
    if "" != binary and checkVersionPhp(binary, version):
        return binary

    binary = findExe("php" & version)
    if "" != binary and checkVersionPhp(binary, version):
        return binary

    binary = findExe("php-" & version)
    if "" != binary and checkVersionPhp(binary, version):
        return binary

    raise newException(IOError, "Impossible de trouver le binaire PHP en version " & version)

#[
    Récupération du chemin complet d'un binaire
]#
proc getBinary*(name: string): string {.raises: [IOError, OSError, Exception].} =
    var binary: string = findExe(name)

    if "" == binary and "php" == name:
        binary = getPhpBin("")

    if "" == binary:
        raise newException(IOError, "Impossible de trouver le binaire" & name)

    return binary