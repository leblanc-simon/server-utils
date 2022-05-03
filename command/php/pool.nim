import std/logging

import ../command
#import ../../helper/process

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
                defaultValue: "0",
                description: "Port à utiliser pour le pool PHP"
            )
        ]
    )

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc php_pool*(username: string, version: string, port: int): void =
    error("Fail to create user " & username)
