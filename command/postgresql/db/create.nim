import std/logging

import ../../command
import ../../../helper/process

proc definition(): Command =
    return Command(
        name: "postgresql:db:create",
        ident: "postgresql_db_create",
        description: "Création d'une base de données PostgreSQL",
        arguments: @[
            CommandArg(
                ident: "database",
                argType: "string",
                description: "Nom de la base de données PostgreSQL à créer"
            ),
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur PostgreSQL possédant la base de donnée"
            ),
        ]
    )

macro addHelp*(): untyped =
    result = createHelp(definition())

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc postgresql_db_create*(database: string, username: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "sudo", arguments: @[
        "-u",
        "postgres",
        "-H",
        "psql",
        "-c",
        "CREATE DATABASE " & database & " WITH OWNER = " & username & " ENCODING = 'UTF8' LC_COLLATE = 'fr_FR.UTF-8' LC_CTYPE = 'fr_FR.UTF-8' TABLESPACE = pg_default CONNECTION LIMIT = -1 IS_TEMPLATE = False;"
    ])

    if processBuilder.execute():
        info("PostgreSQL database " & database & " created")
    else:
        error("Fail to create PostgreSQL database " & database)
