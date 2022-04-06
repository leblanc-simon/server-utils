import std/logging

import ../command
import ../../helper/process

proc definition(): Command =
    return Command(
        name: "user:remove",
        ident: "user_remove",
        description: "Suppression d'un utilisateur système",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur à supprimer"
            )
        ]
    )

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc user_remove*(username: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "deluser", arguments: @[
        "--force",
        "--remove-home",
        username
    ])

    if processBuilder.execute():
        info("User " & username & "deleted")
    else:
        error("Fail to delete user " & username)