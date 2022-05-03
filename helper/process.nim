import std/logging
import std/osproc
import std/strutils

import ./binary

type ProcessBuilder* = ref object of RootObj
    binary*: string
    arguments*: seq[string]

method getBinaryPath*(this: ProcessBuilder): string {.base.} =
    return binary.getBinary(this.binary)

method logCommand*(this: ProcessBuilder): void {.base.} =
    info(this.getBinaryPath() & " " & this.arguments.join(" "))

method execute*(this: ProcessBuilder): bool {.base.} =
    this.logCommand()

    let process: Process = startProcess(this.getBinaryPath(), "", this.arguments, nil, {poStdErrToStdOut})
    defer: close(process)
    
    let (lines, exitCode) = process.readLines
    
    if exitCode != 0:
        for line in lines:
            error(line)
        return false

    for line in lines:
        info(line)

    return true