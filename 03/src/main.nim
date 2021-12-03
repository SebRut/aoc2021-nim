import std/strutils
import std/sequtils
import sugar

func getResultPart1(input: seq[string]): int =
    let binLen = input[0].len
    let chars = input.join("")

    var gammaBits: string
    var epsilonBits: string

    for i in countup(0, binLen-1):
        var bits: seq[char] = @[]
        for offset in countup(0, input.len-1):
            bits.add(chars[i+offset*binLen])

        if bits.count('1') >= input.len div 2:
            gammaBits.add('1')
            epsilonBits.add('0')
        else:
            gammaBits.add('0')
            epsilonBits.add('1')

    let gamma = fromBin[int](gammaBits)
    let epsilon = fromBin[int](epsilonBits)

    gamma * epsilon

type
    Input = tuple
        number: string
        processedNum: string

func bitFilter(inputs: seq[Input], predicate: proc (bits: seq[char], bit: char): bool): seq[Input] =
    if inputs.len == 1 or inputs[0].processedNum.len == 1:
        return inputs

    let bits = inputs.mapIt(it.processedNum[0])

    let filtered = inputs.filterIt(predicate(bits, it.processedNum[0]))
    let newOnes = filtered.mapIt((it.number, it.processedNum.substr(1)))

    bitFilter(newOnes, predicate)

func getResultPart2(input: seq[string]): int =
    let typedInputs: seq[Input] = input.mapIt((it, it))

    let oxyNumBin = bitFilter(typedInputs, (bits, bit) => bits.count(bit).toFloat-bits.len/2>0 or (bits.count(bit).toFloat-bits.len/2==0 and bit == '1'))[0].number
    let oxyNum = fromBin[int](oxyNumBin)

    let co2NumBin = bitFilter(typedInputs, (bits, bit) => bits.count(bit).toFloat-bits.len/2<0 or (bits.count(bit).toFloat-bits.len/2==0 and bit == '0'))[0].number
    let co2Num = fromBin[int](co2NumBin)

    oxyNum * co2Num

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo "part1 result: " & $getResultPart1(lines)
    echo "part2 result: " & $getResultPart2(lines)
