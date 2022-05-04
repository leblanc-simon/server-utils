import std/logging

import ../../command
import ../../../helper/process

proc definition(): Command =
    return Command(
        name: "systemd:symfony:consumer",
        ident: "systemd_symfony_consumer",
        description: "Ajout d'un consumer Symfony",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur à utiliser"
            ),
            CommandArg(
                ident: "consumer_name",
                argType: "string",
                description: "Nom de consumer à créer"
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

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc systemd_symfony_consumer*(username: string, consumer_name: string, shell: string, home: string): void =
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
