import std/logging

import ../command
import ../../helper/process

proc definition(): Command =
    return Command(
        name: "user:add",
        ident: "user_add",
        description: "Ajout d'un utilisateur système",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur à créer"
            )
        ],
        options: @[
            CommandOpt(
                longName: "shell",
                shortName: "s",
                ident: "shell",
                optionType: "string",
                defaultValue: "/bin/bash",
                description: "Shell de l'utilisateur"
            ),
            CommandOpt(
                longName: "home", 
                shortName: "", 
                ident: "home", 
                optionType: "string", 
                defaultValue: "", 
                description: "Dossier utilisateur"
            )
        ]
    )

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc user_add*(username: string, shell: string, home: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "adduser", arguments: @[
        "--home", home,
        "--shell", shell,
        "--disabled-password",
        "--gecos", "",
        username
    ])

    if processBuilder.execute():
        info("User " & username & " created")
    else:
        error("Fail to create user " & username)
