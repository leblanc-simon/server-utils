import std/logging

import ../../command
import ../../../helper/process

proc definition(): Command =
    return Command(
        name: "postgresql:user:add",
        ident: "postgresql_user_add",
        description: "Ajout d'un utilisateur PostgreSQL",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur PostgreSQL à créer"
            ),
            CommandArg(
                ident: "password",
                argType: "string",
                description: "Mot de passe de l'utilisateur PostgreSQL"
            )
        ]
    )

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc postgresql_user_add*(username: string, password: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "sudo", arguments: @[
        "-u",
        "postgres",
        "-H",
        "psql",
        "-c",
        "CREATE ROLE " & username & " LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION PASSWORD '" & password & "'"
    ])

    if processBuilder.execute():
        info("PostgreSQL User " & username & " created")
    else:
        error("Fail to create PostgreSQL user " & username)
