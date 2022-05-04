import std/parseopt
import std/logging
import std/os
import system
import std/strutils
import std/times

import macros

import helper/binary
import helper/configuration
import helper/echo

import commandant

include "include/commands.nim"

const serverUtilsVersion = "0.0.1"
const serverUtilsName = "server-utils"

var appDir: string = normalizePathEnd(getAppDir(), trailingSep = true)
var configDir: string = normalizePathEnd(appDir & "config", trailingSep = true)
var logDir: string = normalizePathEnd(appDir & "logs", trailingSep = true)
var currentDate: string = (now()).format("yyyy-MM-dd")

discard existsOrCreateDir(configDir)
discard existsOrCreateDir(logDir)

var consoleLog = newConsoleLogger(fmtStr="[$date $time][$levelname] ")
var fileLog = newFileLogger(logDir & "/" & currentDate & "-" & serverUtilsName & ".log", fmtStr="[$date $time][$levelname] ")

addHandler(consoleLog)
addHandler(fileLog)

proc helpMessage(): string =
    var help: seq[string] = @[]
    include "include/commandhelp.nim"

    result = os.getAppFilename() & """ <subcommand> <subcommand options>

Available subcommands:

""" & help.join("\n")

commandline:
    exitoption("help", "h", helpMessage())
    exitoption("version", "v", serverUtilsVersion)
    include "include/commandlines.nim"

#dumpAstGen:
#    var help: seq[string] = @[]
#    help.add("test")
#    help.add("test2")
#    echo help.join(" ")
#dumpTree:
#  if init:
#    echo fmt"creating a new project directory, {name}. One second..."
#  if user_add:
#    add_user(user_add_username, user_add_shell, user_add_home)
#  else:
#    echo "please use either the 'init' or 'build' subcommand..."
#    echo helpMessage()

include "include/commandprocess.nim"

try:
    echoInfo(getBinary("php"))
    echoInfo(getPhpBin("7.4"))

    let configuration: Configuration = Configuration()
    if false == configuration.parse("template.ini"):
        echoError("Fail to parse file")

    echoInfo(configuration.mysql.schemas.join("/"))
except IOError:
    let
        e = getCurrentException()
        msg = getCurrentExceptionMsg()
    echoError("Got exception " & repr(e) & " with message " & msg)
