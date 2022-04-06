proc echoSuccess*(text: string) =
    echo "\e[32m", text, "\e[0m"

proc echoError*(text: string) =
    echo "\e[31m", text, "\e[0m"

proc echoInfo*(text: string) =
    echo "\e[33m", text, "\e[0m"