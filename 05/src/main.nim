import std/strutils
import std/sequtils

type
    Point = (int, int)
    Line = (Point, Point)

func parsePoint(input: string): Point =
    let parts = input.split(',')
    assert parts.len == 2

    (parts[0].parseInt, parts[1].parseInt)

func parseLine(input: string): Line =
    let parts = input.split(" -> ")
    assert parts.len == 2

    (parsePoint(parts[0]), parsePoint(parts[1]))

func parseLines(input: openArray[string]): seq[Line] =
    input.mapIt(parseLine(it))

func getResultPart1(input: seq[string]): int =
    let lines = parseLines(input)
    let maxX = lines.mapIt(max(it[0][0], it[1][0])).max+1
    let maxY = lines.mapIt(max(it[0][1], it[1][1])).max+1

    var field = newSeqWith(maxX, newSeqWith(maxY, 0))

    for (startP, endP) in lines:
        if startP[0] != endP[0] and startP[1] != endP[1]:
            continue

        let startX = min(startP[0], endP[0])
        let startY = min(startP[1], endP[1])

        let endX = max(startP[0], endP[0])
        let endY = max(startP[1], endP[1])
        for x in startX..endX:
            for y in startY..endY:
                field[x][y] = field[x][y] + 1

    field.mapIt(it.countIt(it > 1)).foldl(a+b)

func getResultPart2(input: seq[string]): int =
    let lines = parseLines(input)
    let maxX = lines.mapIt(max(it[0][0], it[1][0])).max+1
    let maxY = lines.mapIt(max(it[0][1], it[1][1])).max+1

    var field = newSeqWith(maxX, newSeqWith(maxY, 0))

    for (startP, endP) in lines:
        if startP[0] == endP[0] or startP[1] == endP[1]:
            let startX = min(startP[0], endP[0])
            let startY = min(startP[1], endP[1])

            let endX = max(startP[0], endP[0])
            let endY = max(startP[1], endP[1])
            for x in startX..endX:
                for y in startY..endY:
                    field[x][y] = field[x][y] + 1
        else:
            let startX = min(startP[0], endP[0])
            let endX = max(startP[0], endP[0])

            var startY: int
            var endY: int

            if(startX == startP[0]):
                startY = startP[1]
                endY = endP[1]
            else:
                startY = endP[1]
                endY = startP[1]

            var step: int
            if startY < endY:
                step = 1
            else:
                step = -1

            for x in startX..endX:
                let y = startY + step * (x-startX)
                field[x][y] = field[x][y] + 1

    field.mapIt(it.countIt(it > 1)).foldl(a+b)

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo "part1 result: " & $getResultPart1(lines)
    echo "part2 result: " & $getResultPart2(lines)
