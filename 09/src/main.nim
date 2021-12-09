import std/strutils
import std/sequtils
import std/sugar
import std/sets
import std/algorithm

type
    Field = seq[seq[uint]]
    Entry = (int,int,uint)

func parseInput(input: string): Field =
    let lines = splitLines(input)
    result = newSeqWith(lines[0].len, newSeqUninitialized[uint](lines.len))

    for i in countup(0, lines.len-1):
        let line = lines[i]
        for j in countup(0, line.len-1):
            let c = $line[j]
            result[j][i] = parseUInt(c)

func getLowestPoints(field: Field): seq[Entry] =
    result = collect(newSeq):
        for x in countup(0,field.len-1):
            for y in countup(0,field[0].len-1):
                let p = field[x][y]
                let leftB = if x > 0: field[x-1][y] > p else: true
                let rightB = if x < field.len-1: field[x+1][y] > p else: true
                let topB = if y > 0: field[x][y-1] > p else: true
                let bottomB = if y < field[0].len-1: field[x][y+1] > p else: true

                if leftB and rightB and topB and bottomB: (x,y,p)

func getBasinEntries(entry: Entry, field: Field): HashSet[Entry] =
    let x = entry[0]
    let y = entry[1]
    let val = entry[2]

    if val == 9:
        return

    result.incl(entry)

    if x > 0 and field[x-1][y] > val:
        result.incl(getBasinEntries((x-1,y,field[x-1][y]),field))
    if x < field.len-1 and field[x+1][y] > val:
        result.incl(getBasinEntries((x+1,y,field[x+1][y]),field))
    if y > 0 and field[x][y-1] > val:
        result.incl(getBasinEntries((x,y-1,field[x][y-1]),field))
    if y < field[0].len-1 and field[x][y+1] > val:
        result.incl(getBasinEntries((x,y+1,field[x][y+1]),field))


func getResultPart1(input: Field): uint =
    let lowest = getLowestPoints(input)

    lowest.mapIt(it[2])
        .mapIt(it+1)
        .foldl(a + b, 0'u)

func getResultPart2(input: Field): int =
    let lowest = getLowestPoints(input)
    
    lowest.mapIt(getBasinEntries(it, input))
        .mapIt(it.len)
        .toSeq
        .sorted(system.cmp[int], Descending)
        .toOpenArray(0,2)
        .foldl(a * b, 1)


when isMainModule:
    let input = readFile("input.txt")
    let parsed = parseInput(input)

    echo "part1 result: " & $getResultPart1(parsed)
    echo "part2 result: " & $getResultPart2(parsed)
