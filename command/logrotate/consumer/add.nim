import std/logging
import std/json

import ../../command
import ../../../helper/echo
import ../../../helper/template_builder

proc definition(): Command =
    return Command(
        name: "logrotate:consumer:add",
        ident: "logrotate_consumer_add",
        description: "Ajout de la configuration logrotate pour un consumer",
        arguments: @[
            CommandArg(
                ident: "consumer",
                argType: "string",
                description: "Nom du consumer pour lequel créer la configuration du logrotate"
            ),
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

proc logrotate_consumer_add*(consumer: string, home: string): void =
    var templateBuilder: TemplateBuilder
    templateBuilder = TemplateBuilder(templatePath: "logrotate/consumer", parameters: %* {
        "consumer": consumer,
        "home": home
    })

    echoInfo(templateBuilder.render())
