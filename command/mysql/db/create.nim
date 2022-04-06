import std/logging

import ../../command
import ../../../helper/process

proc definition(): Command =
    return Command(
        name: "mysql:db:create",
        ident: "mysql_db_create",
        description: "Création d'une base de données MySQL",
        arguments: @[
            CommandArg(
                ident: "database",
                argType: "string",
                description: "Nom de la base de données MySQL à créer"
            )
        ]
    )

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc mysql_db_create*(database: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "mysql", arguments: @[
        "--execute",
        "CREATE DATABASE '" & database & "';"
    ])

    if processBuilder.execute():
        info("MySQL database " & database & " created")
    else:
        error("Fail to create database " & database)
