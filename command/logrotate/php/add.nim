import std/logging
import std/json

import ../../command
import ../../../helper/echo
import ../../../helper/template_builder

proc definition(): Command =
    return Command(
        name: "logrotate:php:add",
        ident: "logrotate_php_add",
        description: "Ajout de la configuration logrotate pour un pool PHP",
        arguments: @[
            CommandArg(
                ident: "home",
                argType: "string",
                description: "Répertoire utilisateur"
            )
        ],
        options: @[]
    )

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc logrotate_php_add*(home: string): void =
    var templateBuilder: TemplateBuilder
    templateBuilder = TemplateBuilder(templatePath: "logrotate/php-pool", parameters: %* {
        "home": home
    })

    echoInfo(templateBuilder.render())
