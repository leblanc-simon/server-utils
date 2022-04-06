import std/logging

import ../command
import ../../helper/process

proc definition(): Command =
    return Command(
        name: "php:pool",
        ident: "php_pool",
        description: "Ajout d'un pool PHP",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur à créer"
            ),
            CommandArg(
                ident: "version",
                argType: "string",
                description: "Version de PHP à utiliser"
            )
        ],
        options: @[
            CommandOpt(
                longName: "port",
                shortName: "p",
                ident: "port",
                optionType: "int",
                defaultValue: 0,
                description: "Port à utiliser pour le pool PHP"
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
