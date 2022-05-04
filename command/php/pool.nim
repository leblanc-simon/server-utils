import std/logging
import std/json
from strutils import intToStr

import ../command
#import ../../helper/process
import ../../helper/echo
import ../../helper/template_builder

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
    var templateBuilder: TemplateBuilder
    templateBuilder = TemplateBuilder(templatePath: "php/pool.conf", parameters: %* {
        "username": username,
        "version": version,
        "port": intToStr(port)
    })

    echoInfo(templateBuilder.render())
