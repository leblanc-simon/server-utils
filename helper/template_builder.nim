import std/json
import std/os
import std/strutils

type TemplateBuilder* = ref object of RootObj
    templatePath*: string
    parameters*: JsonNode

method render*(this: TemplateBuilder): string {.base.} =
    var content: string = readFile(os.getAppDir() & "/templates/" & this.templatePath)

    for key, value in this.parameters:
        content = content.replace("{" & key & "}", value.getStr())

    return content