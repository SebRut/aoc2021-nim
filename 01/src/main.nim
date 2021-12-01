import std/strutils
import std/sequtils

func getResultPart01(input: seq[string]): int =
    let depths = input.mapIt(it.parseInt)

    var lastDepth = depths[0]
    var increases = 0

    for depth in depths.toOpenArray(1, depths.len-1):
        if depth > lastDepth:
            increases = increases + 1
        lastDepth = depth

    increases

proc getResultPart02(input: seq[string]): int =
    let depths = input.mapIt(it.parseInt)

    var windows: seq[int] = @[]

    for i in countup(0, depths.len-3):
        windows.add(depths[i]+depths[i+1]+depths[i+2])

    var lastWindow = windows[0]
    var increases = 0

    for window in windows.toOpenArray(1, windows.len-1):
        if window > lastWindow:
            increases = increases + 1
        lastWindow = window

    increases

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo getResultPart01(lines)
    echo getResultPart02(lines)

