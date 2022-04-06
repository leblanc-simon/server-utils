import std/parseopt
import std/logging
import std/os
import system
import std/times

import command/mysql/db/create as commandMysqlDbCreate
import command/mysql/user/add as commandMysqlUserAdd
import command/mysql/user/allow as commandMysqlUserAllow

import command/user/add as commandUserAdd
import command/user/remove as commandUserRemove

import helper/binary
import helper/echo

import commandant

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
  result = """
  pico-nim project template builder
  Usage: example2 <subcommand> <subcommand options> <sillyArg>
  Available subcommands: 
    {...}
  """

commandline:
  argument(sillyArg, float) 
  exitoption("help", "h", helpMessage())
  exitoption("version", "v", serverUtilsVersion)
  errormsg("you have made some kind of mistake")
  subcommand init, "init", "i":
    argument(name, string)
    flag(override, "override", "O")
    option(sdk, string, "sdk", "s")
    option(nimbase, string, "nimbase", "h")
    exitoption("help", "h", "I wish i could help you, but I can't")
  commandMysqlDbCreate.addCommand()
  commandMysqlUserAdd.addCommand()
  commandMysqlUserAllow.addCommand()
  
  commandUserAdd.addCommand()
  commandUserRemove.addCommand()
  
#dumpTree:
#  if init:
#    echo fmt"creating a new project directory, {name}. One second..."
#  if user_add:
#    add_user(user_add_username, user_add_shell, user_add_home)
#  else:
#    echo "please use either the 'init' or 'build' subcommand..."
#    echo helpMessage()

commandMysqlDbCreate.addProcess()
commandMysqlUserAdd.addProcess()
commandMysqlUserAllow.addProcess()

commandUserAdd.addProcess()
commandUserRemove.addProcess()

try:
    echoInfo(getBinary("php"))
    echoInfo(getPhpBin("7.4"))
except IOError:
    let
        e = getCurrentException()
        msg = getCurrentExceptionMsg()
    echoError("Got exception " & repr(e) & " with message " & msg)