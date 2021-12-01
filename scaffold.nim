import std/os

let baseName = paramStr(1)

let mainNimContent = """
import std/strutils

func getResult(input: seq[string]): int =
    0

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo getResult(lines)
"""

createDir(joinPath(baseName,"src"))
writeFile(joinPath(baseName, "src", "main.nim"), mainNimContent)
writeFile(joinPath(baseName, "input.txt"), "")