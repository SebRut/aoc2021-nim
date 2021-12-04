import std/strutils
import std/sequtils

type
    Field = tuple[value: int, marked: bool]
    Board = seq[Field]

func parseDraws(input: string): seq[int] =
    input.split(',').mapIt(it.strip.parseInt)

func parseBoard(input: string): Board =
    input.replace("\n", " ").strip
        .split(" ")
        .filterIt(it.strip.len > 0)
        .mapIt((value: it.parseInt, marked: false))

func parseBoards(input: openArray[string]): seq[Board] =
    input.mapIt(parseBoard(it))

func markBoard(board: Board, draw: int): Board =
    board.mapIt((value: it.value, marked: it.marked or it.value == draw))

func checkBoard(board: Board): bool =
    for row in board.distribute(5):
        if row.allIt(it.marked):
            return true

    for i in countup(0, 4):
        if toSeq(0..4).mapIt(board[it*5+i]).allIt(it.marked):
            return true

    false

iterator validBoards(boards: openArray[Board]): Board =
    for board in boards:
        if checkBoard(board):
            yield board

func getResultPart1(input: string): int =
    let parts = input.split("\n\n")
    let draws = parseDraws(parts[0])
    var boards = parseBoards(parts.toOpenArray(1, parts.len-1))

    for d in draws:
        boards = boards.mapIt(markBoard(it, d))

        for winningBoard in validBoards(boards):
            let unmarkedSum = winningBoard
                .filterIt(not it.marked)
                .mapIt(it.value)
                .foldl(a + b, 0)

            return unmarkedSum * d

    return -1

func getResultPart2(input: string): int =
    let parts = input.split("\n\n")
    let draws = parseDraws(parts[0])
    var boards = parseBoards(parts.toOpenArray(1, parts.len-1))
    var score: int

    for d in draws:
        if boards.len == 0:
            continue
        boards = boards.mapIt(markBoard(it, d))

        let cBoards = boards
        for winningBoard in validBoards(cBoards):
            let unmarkedSum = winningBoard
                .filterIt(not it.marked)
                .mapIt(it.value)
                .foldl(a + b, 0)
            score = unmarkedSum * d
            boards = boards.filterIt(it != winningBoard)

    return score


when isMainModule:
    let input = readFile("input.txt")

    echo "part1 result: " & $getResultPart1(input)
    echo "part2 result: " & $getResultPart2(input)
