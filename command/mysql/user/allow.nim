import std/logging

import ../../command
import ../../../helper/process

proc definition(): Command =
    return Command(
        name: "mysql:user:allow",
        ident: "mysql_user_allow",
        description: "Donne tous les droits à un utilisateur MySQL sur une base de données",
        arguments: @[
            CommandArg(
                ident: "username",
                argType: "string",
                description: "Nom de l'utilisateur MySQL"
            ),
            CommandArg(
                ident: "database",
                argType: "string",
                description: "Nom de la base de données"
            )
        ]
    )

macro addCommand*(): untyped =
    result = createCommand(definition())

macro addProcess*(): untyped =
    result = createProcess(definition())

proc mysql_user_allow*(username: string, database: string): void =
    var processBuilder: ProcessBuilder
    processBuilder = ProcessBuilder(binary: "mysql", arguments: @[
        "--execute",
        "GRANT ALL PRIVILEGES ON " & database & ".* '" & username & "'@'localhost'"
    ])

    if processBuilder.execute():
        info("MySQL User " & username & " created")
    else:
        error("Fail to create user " & username)
