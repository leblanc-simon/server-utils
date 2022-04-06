import std/macros
import std/strutils

type
    CommandArg* = object
        ident*: string
        argType*: string
        description*: string

    CommandOpt* = object
        longName*: string
        shortName*: string
        ident*: string
        optionType*: string
        description*: string
        defaultValue*: string

    CommandFlag* = object
        longName*: string
        shortName*: string
        description*: string
        ident*: string
        defaultValue*: string

    Command* = object
        name*: string
        ident*: string
        description*: string
        arguments*: seq[CommandArg]
        options*: seq[CommandOpt]
        flags*: seq[CommandFlag]

proc generateHelp(command: Command): string =
    var help = ""

    help.add("./server-utils " & command.name)

    if command.arguments.len != 0:
        for argument in command.arguments:
            help.add(" " & argument.ident)

    if command.options.len != 0:
        for option in command.options:
            help.add(" [--" & option.longName & "=...]")

    if command.flags.len != 0:
        for flag in command.flags:
            help.add(" [--" & flag.longName & "]")
    
    help.add("\n\n" & command.description & "\n\n")

    if command.arguments.len != 0:
        for argument in command.arguments:
            help.add("  " & alignLeft(argument.ident, 30) & argument.description & "\n")
        help.add("\n")

    if command.options.len != 0:
        for option in command.options:
            help.add("  " & alignLeft("--" & option.longName & "=...", 30) & option.description & "\n")
        help.add("\n")

    if command.flags.len != 0:
        for flag in command.flags:
            help.add("  " & alignLeft("--" & flag.longName, 30) & flag.description & "\n")
        
    return help


proc createCommand*(command: Command): NimNode =
    let commandTree = nnkStmtList.newTree()

    let subcommandTree = nnkCommand.newTree()

    subcommandTree.add newIdentNode("subcommand")
    subcommandTree.add newIdentNode(command.ident)
    subcommandTree.add newLit(command.name)

    let optionsCommandTree = nnkStmtList.newTree()

    let helpTree = nnkCall.newTree()
    helpTree.add newIdentNode("exitoption")
    helpTree.add newLit("help")
    helpTree.add newLit("h")
    helpTree.add newLit(generateHelp(command))
    optionsCommandTree.add helpTree

    for argument in command.arguments:
        let argumentTree = nnkCall.newTree()
        argumentTree.add newIdentNode("argument")
        argumentTree.add newIdentNode(command.ident & "_" & argument.ident)
        argumentTree.add newIdentNode(argument.argType)

        optionsCommandTree.add argumentTree
    
    for option in command.options:
        let optionTree = nnkCall.newTree()
        optionTree.add newIdentNode("option")
        optionTree.add newIdentNode(command.ident & "_" & option.ident)
        optionTree.add newIdentNode(option.optionType)
        optionTree.add newLit(option.longName)
        optionTree.add newLit(option.shortName)
        optionTree.add newLit(option.defaultValue)

        optionsCommandTree.add optionTree
    
    for flag in command.flags:
        let flagTree = nnkCall.newTree()
        flagTree.add newIdentNode("flag")
        flagTree.add newIdentNode(command.ident & "_" & flag.ident)
        flagTree.add newLit(flag.longName)
        flagTree.add newLit(flag.shortName)

        optionsCommandTree.add flagTree

    subcommandTree.add optionsCommandTree
    commandTree.add subcommandTree

    return commandTree

proc createProcess*(command: Command): NimNode =
    let processTree = nnkStmtList.newTree()
    let ifTree = nnkIfStmt.newTree()
    let ifStmt = nnkElifExpr.newTree()
    ifStmt.add newIdentNode(command.ident)

    let execTree = nnkStmtList.newTree()

    let callTree = nnkCall.newTree()
    callTree.add newIdentNode(command.ident)

    for argument in command.arguments:
        callTree.add newIdentNode(command.ident & "_" & argument.ident)
    
    for option in command.options:
        callTree.add newIdentNode(command.ident & "_" & option.ident)
    
    for flag in command.flags:
        callTree.add newIdentNode(command.ident & "_" & flag.ident)

    execTree.add callTree
    ifStmt.add execTree

    ifTree.add ifStmt
    processTree.add ifTree

    return processTree
