import std/os
import std/parsecfg
import std/sequtils
import std/strutils

type GeneralConfiguration* = ref object of RootObj
    username*: string
    home*: string
    domain*: string
    description*: string

type PhpConfiguration* = ref object of RootObj
    active*: bool
    version*: string
    port*: int

type SymfonyConfiguration* = ref object of RootObj
    active*: bool
    version*: string

type PrestashopConfiguration* = ref object of RootObj
    active*: bool

type WordpressConfiguration* = ref object of RootObj
    active*: bool

type MySQLConfiguration* = ref object of RootObj
    active*: bool
    password*: string
    schemas*: seq[string]

type PostgreSQLConfiguration* = ref object of RootObj
    active*: bool
    password*: string
    schemas*: seq[string]

type RabbitMQConfiguration* = ref object of RootObj
    active*: bool
    password*: string
    vhost*: string
    queues*: seq[string]

type ConsumersConfiguration* = ref object of RootObj
    names*: seq[string]

type ServicesConfiguration* = ref object of RootObj
    names*: seq[string]

type CrontabConfiguration* = ref object of RootObj
    names*: seq[string]

type Configuration* = ref object of RootObj
    general*: GeneralConfiguration
    php*: PhpConfiguration
    symfony*: SymfonyConfiguration
    prestashop*: PrestashopConfiguration
    wordpress*: WordpressConfiguration
    mysql*: MySQLConfiguration
    postgresql*: PostgreSQLConfiguration
    rabbitmq*: RabbitMQConfiguration
    consumers*: ConsumersConfiguration
    services*: ServicesConfiguration
    crontab*: CrontabConfiguration

method toBool(this: Configuration, value: string): bool {.base.} =
    const trueValues = @["true", "True", "on", "On", "1"]
    return value in trueValues

method toInt(this: Configuration, value: string): int {.base.} =
    if "" == value:
        return 0
    return parseInt(value)

method toStringSeq(this: Configuration, value: string): seq[string] {.base.} =
    var seqValues: seq[string]
    seqValues.add(value)

    return seqValues

method parse*(this: Configuration, filename: string): bool {.base.} =
    let dict = loadConfig(os.getAppDir() & "/config/" & filename)

    this.general = GeneralConfiguration(
        username: dict.getSectionValue("general", "username"),
        home: dict.getSectionValue("general", "home"),
        domain: dict.getSectionValue("general", "domain"),
        description: dict.getSectionValue("general", "description")
    )

    this.php = PhpConfiguration(
        active: this.toBool(dict.getSectionValue("php", "active")),
        version: dict.getSectionValue("php", "version"),
        port: this.toInt(dict.getSectionValue("php", "port"))
    )

    this.symfony = SymfonyConfiguration(
        active: this.toBool(dict.getSectionValue("symfony", "active")),
        version: dict.getSectionValue("symfony", "version")
    )

    this.prestashop = PrestashopConfiguration(
        active: this.toBool(dict.getSectionValue("prestashop", "active"))
    )

    this.wordpress = WordpressConfiguration(
        active: this.toBool(dict.getSectionValue("wordpress", "active"))
    )

    this.mysql = MySQLConfiguration(
        active: this.toBool(dict.getSectionValue("mysql", "active")),
        password: dict.getSectionValue("mysql", "password"),
        schemas: this.toStringSeq(dict.getSectionValue("mysql", "schema"))
    )

    this.postgresql = PostgreSQLConfiguration(
        active: this.toBool(dict.getSectionValue("postgresql", "active")),
        password: dict.getSectionValue("postgresql", "password"),
        schemas: this.toStringSeq(dict.getSectionValue("postgresql", "schema"))
    )

    this.rabbitmq = RabbitMQConfiguration(
        active: this.toBool(dict.getSectionValue("rabbitmq", "active")),
        password: dict.getSectionValue("rabbitmq", "password"),
        vhost: dict.getSectionValue("rabbitmq", "vhost"),
        queues: this.toStringSeq(dict.getSectionValue("rabbitmq", "queue"))
    )

    return true