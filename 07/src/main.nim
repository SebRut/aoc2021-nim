import std/strutils
import std/sequtils

func getResultPart1(input: seq[int]): int =
    let min = input.min
    let max = input.max

    result = high(int)

    for target in countup(min,max):
        let cost = input
            .mapIt(abs(it-target))
            .foldl(a+b)
        if cost < result:
            result = cost

func getResultPart2(input: seq[int]): int =
    let min = input.min
    let max = input.max

    result = high(int)

    for target in countup(min,max):
        let cost = input
            .mapIt(abs(it-target))
            .mapIt((it*(it+1))/2)
            .mapIt(it.toInt)
            .foldl(a+b)
        if cost < result:
            result = cost

when isMainModule:
    let input = readFile("input.txt")
    let lines = input.split(',').mapIt(it.parseInt)

    echo "part1 result: " & $getResultPart1(lines)
    echo "part2 result: " & $getResultPart2(lines)
