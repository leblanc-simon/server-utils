import std/logging

import ../../command
import ../../../helper/process

proc definition(): Command =
    return Command(
        name: "mysql:user:add",
        ident: "mysql_user_add",
        description: "Ajout d'un utilisateur MySQL",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur MySQL à créer"
            ),
            CommandArg(
                ident: "password",
                argType: "string",
                description: "Mot de passe de l'utilisateur MySQL"
            )
        ]
    )

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc mysql_user_add*(username: string, password: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "mysql", arguments: @[
        "--execute",
        "CREATE USER '" & username & "'@'localhost' IDENTIFIED BY '" & password & "'"
    ])

    if processBuilder.execute():
        info("MySQL User " & username & " created")
    else:
        error("Fail to create user " & username)
