import std/os
import std/sequtils

let baseName = paramStr(1)

let mainNimContent = """
import std/strutils

func getResultPart1(input: seq[string]): int =
    0

func getResultPart2(input: seq[string]): int =
    0

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo "part1 result: " & $getResultPart1(lines)
    echo "part2 result: " & $getResultPart2(lines)
"""

createDir(joinPath(baseName,"src"))
writeFile(joinPath(baseName, "src", "main.nim"), mainNimContent)
writeFile(joinPath(baseName, "input.txt"), "")