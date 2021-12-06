import std/strutils
import std/sequtils
import std/sugar
import std/tables

func progressFish(fish: int): seq[int] =
    if fish > 0:
        return @[fish-1]
    else:
        return @[6,8]

func progressDay(fishes: openArray[int]): seq[int] =
    collect(newSeq):
        for fish in fishes:
            for newFish in progressFish(fish):
                newFish

func getResultPart1(input: openArray[int]): int =
    var fishes: seq[int] = input.toSeq
    for x in countup(1,80):
        fishes = progressDay(fishes)

    fishes.len

func getResultPart2(input: openArray[int]): int =
    var fishes = initTable[int,int]()
    for fish in input.deduplicate:
        fishes[fish] = input.count(fish)

    for x in countup(1,256):
        let newCount = fishes.getOrDefault(0,0)
        fishes[0] = fishes.getOrDefault(1,0)
        for timer in countup(1,7):
            fishes[timer] = fishes.getOrDefault(timer+1,0)
        fishes[8] = newCount
        fishes[6] = fishes[6] + newCount

    for v in fishes.values:
        result = result + v

when isMainModule:
    let input = readFile("input.txt")
    let base = input.split(",").mapIt(it.parseint)

    echo "part1 result: " & $getResultPart1(base)
    echo "part2 result: " & $getResultPart2(base)
