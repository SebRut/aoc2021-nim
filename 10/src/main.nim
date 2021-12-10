import std/strutils
import std/sequtils
import std/tables
import std/algorithm

let chunkers = {
    '(' : ')',
    '[' : ']',
    '{' : '}',
    '<' : '>'
}.toTable

func scoreError(error: char): int =
    return case error
        of ')': 3
        of ']': 57
        of '}': 1197
        of '>': 25137
        else: 0
    
proc getResultPart1(input: seq[string]): int =
    var illegalChars: seq[char] = @[]

    for line in input:
        var expectedChunks: seq[char] = @[]

        for i in countup(0,line.len-1):
            let currentChar = line[i]
            if currentChar in chunkers:
                expectedChunks.add(chunkers[currentChar])
            elif expectedChunks.len > 0 and currentChar == expectedChunks[expectedChunks.len-1]:
                discard expectedChunks.pop()
            else:
                illegalChars.add(currentChar)
                break
    
    illegalChars.map(scoreError).foldl(a + b, 0)
    
func scoreCompletion(completion: seq[char]): int =
    for c in completion.reversed:
        result = result * 5
        let score = case c:
        of ')': 1
        of ']': 2
        of '}': 3
        of '>': 4
        else: 0
        
        result += score

proc getResultPart2(input: seq[string]): int =
    var neededChars: seq[seq[char]] = @[]

    for line in input:
        block liner:
            var expectedChunks: seq[char] = @[]

            for i in countup(0,line.len-1):
                let currentChar = line[i]
                if currentChar in chunkers:
                    expectedChunks.add(chunkers[currentChar])
                elif expectedChunks.len > 0 and currentChar == expectedChunks[expectedChunks.len-1]:
                    discard expectedChunks.pop()
                else:
                    break liner
            
            if expectedChunks.len > 0:
                neededChars.add(expectedChunks)
        
    
    let scores = neededChars.map(scoreCompletion).sorted(system.cmp[int])
    scores[scores.len div 2]

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo "part1 result: " & $getResultPart1(lines)
    echo "part2 result: " & $getResultPart2(lines)
