import std/strutils
import std/sequtils
import std/sets

type
    Field = seq[seq[uint]]
    Entry = (int,int)

func parseInput(input: string): Field =
    let lines = splitLines(input)
    result = newSeqWith(lines[0].len, newSeqUninitialized[uint](lines.len))

    for i in countup(0, lines.len-1):
        let line = lines[i]
        for j in countup(0, line.len-1):
            let c = $line[j]
            result[j][i] = parseUInt(c)

func processStep(input: Field): (Field, int) =
    let width = input.len
    let height = input[0].len

    var rField: Field = newSeqWith(width, newSeqUninitialized[uint](height))

    var toVisit = initHashSet[Entry]()

    for x in countup(0,width-1):
        for y in countup(0, height-1):
            rField[x][y] = input[x][y]+1
            if rField[x][y] > 9:
                toVisit.incl((x,y))

    var flashed = initHashSet[Entry]()

    while toVisit.len > 0:
        let target: Entry = toVisit.pop()
        flashed.incl(target)
        let (x,y) = target

        for tX in countup(max(0,x-1), min(width,x+2)-1):
            for tY in countup(max(0,y-1), min(height,y+2)-1):
                if tX == x and tY == y:
                    continue

                let tVal = rField[tX][tY]
                rField[tX][tY] = tVal + 1

                if tVal >= 9 and not flashed.contains((tX,tY)):
                    toVisit.incl((tX,tY))

    for entry in flashed:
        let (x,y) = entry
        rField[x][y] = 0

    (rField, flashed.len)

func getResultPart1(input: Field): int =
    var field = input
    for i in countup(1,100):
        let (newField, newFlashes) = processStep(field)
        field = newField
        result += newFlashes

func getResultPart2(input: Field): int =
    var field = input
    for i in countup(1,high(int)):
        let (newField, newFlashes) = processStep(field)
        if newFlashes == input.len * input[0].len:
            return i
        field = newField

    return -1

when isMainModule:
    let input = readFile("input.txt")
    let field = parseInput(input)

    echo "part1 result: " & $getResultPart1(field)
    echo "part2 result: " & $getResultPart2(field)
