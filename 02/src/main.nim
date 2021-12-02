import std/strutils
import std/sequtils

type
    Position = tuple[horizontal: int, vertical: int]
    PosWithAim = tuple[horizontal: int, vertical: int, aim: int]

func applyCommand(currentPos: Position, command: string): Position =
    let splits = command.split(' ')
    assert splits.len == 2

    let change = splits[1].parseInt()
    let (hori,vert) = currentPos

    case splits[0]:
        of "forward":
            return (hori+change, vert)
        of "down":
            return (hori, vert+change)
        of "up":
            return (hori, vert-change)

    return currentPos

proc getResultPart1(input: seq[string]): int =
    let (hori, vert) = input.foldl(applyCommand(a, b), (0, 0))

    hori * vert

func applyCommandWithAim(currentPos: PosWithAim, command: string): PosWithAim =
    let splits = command.split(' ')
    assert splits.len == 2

    let change = splits[1].parseInt()
    let (hori, vert, aim) = currentPos

    case splits[0]:
        of "forward":
            return (hori+change, vert+aim*change, aim)
        of "down":
            return (hori, vert, aim+change)
        of "up":
            return (hori, vert, aim-change)

    currentPos

proc getResultPart2(input: seq[string]): int =
    let (hori, vert, _) = input.foldl(applyCommandWithAim(a, b), (0, 0, 0))

    hori * vert

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo getResultPart1(lines)
    echo getResultPart2(lines)