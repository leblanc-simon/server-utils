import std/logging
import std/json

import ../../command
import ../../../helper/echo
import ../../../helper/template_builder

proc definition(): Command =
    return Command(
        name: "systemd:symfony:consumer",
        ident: "systemd_symfony_consumer",
        description: "Ajout d'un consumer Symfony",
        arguments: @[
            CommandArg(
                ident: "consumer_name",
                argType: "string",
                description: "Nom de consumer à créer"
            )
        ],
        options: @[
            CommandOpt(
                longName: "username",
                shortName: "u",
                ident: "username",
                optionType: "string",
                defaultValue: "",
                description: "Nom de l'utilisateur dans lequel s'exécutera le service"
            ),
            CommandOpt(
                longName: "php_binary",
                shortName: "p",
                ident: "php_binary",
                optionType: "string",
                defaultValue: "",
                description: "Binaire PHP à utiliser"
            ),
            CommandOpt(
                longName: "home", 
                shortName: "h", 
                ident: "home", 
                optionType: "string", 
                defaultValue: "", 
                description: "Dossier utilisateur"
            ),
            CommandOpt(
                longName: "hostname",
                shortName: "w",
                ident: "hostname",
                optionType: "string",
                defaultValue: "",
                description: "Nom de domaine"
            ),
            CommandOpt(
                longName: "symfony",
                shortName: "s",
                ident: "symfony",
                optionType: "int",
                defaultValue: "5",
                description: "Version de Symfony pour le consumer"
            )
        ]
    )

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc systemd_symfony_consumer*(consumer_name: string, username: string, php_binary: string, home: string, hostname: string, symfony: int): void =
    var templateBuilder: TemplateBuilder
    var templateConsumer: string
    if symfony > 3:
        templateConsumer = "systemd/consumer-service-symfony-5.service"
    else:
        templateConsumer = "systemd/consumer-service-symfony-3.service"

    templateBuilder = TemplateBuilder(templatePath: templateConsumer, parameters: %* {
        "consumer_name": consumer_name,
        "username": username,
        "php_binary": php_binary,
        "home": home,
        "hostname": hostname
    })

    echoInfo(templateBuilder.render())
