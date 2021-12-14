import std/strutils
import std/tables
import std/sets
import std/sugar

type
    Node = object
        name: string
        links: HashSet[string]
    Graph = Table[string, Node]

func parseGraph(entries: openArray[string]): Graph =
    var rawMappings = initTable[string, HashSet[string]]()

    for entry in entries:
        let parts = entry.split('-')
        let name = parts[0]
        let target = parts[1]

        var links = rawMappings.getOrDefault(name, initHashSet[string]())
        links.incl(target)
        rawMappings[name] = links

        var reverseLinks = rawMappings.getOrDefault(target, initHashSet[string]())
        reverseLinks.incl(name)
        rawMappings[target] = reverseLinks

    for k, v in rawMappings.pairs:
        result[k] = Node(name: k, links: v)

func getVisitableNodesPart1(nodes: HashSet[string], alreadyVisited: HashSet[
        string]): seq[string] =
    result = collect(newSeq):
        for n in nodes:
            if n in alreadyVisited and n[0].isLowerAscii:
                continue
            if n == "end":
                continue
            n

func getPathsToEndPart1(node: Node, alreadyVisited: HashSet[string],
        graph: Graph, path: seq[string]): seq[seq[string]] =
    let visitable = getVisitableNodesPart1(node.links, alreadyVisited)

    if "end" in node.links:
        result.add(path & "end")

    for n in visitable:
        let node = graph[n]
        var newVisited = alreadyVisited
        newVisited.incl(n)
        result = result & getPathsToEndPart1(node, newVisited, graph, path & n)

func getResultPart1(input: seq[string]): int =
    let graph = parseGraph(input)

    var paths: seq[seq[string]] = @[]

    for starter in graph["start"].links:
        let node = graph[starter]
        paths.add(getPathsToEndPart1(node, toHashSet(["start", starter]), graph,
                @["start", starter]))

    paths.len


func getVisitableNodesPart2(nodes: HashSet[string], alreadyVisited: CountTable[
        string]): seq[string] =
    var smallVisited = false

    for k, v in alreadyVisited.pairs:
        if k[0].isLowerAscii and v >= 2:
            smallVisited = true
            break

    result = collect(newSeq):
        for n in nodes:
            if n == "start":
                continue
            if n == "end":
                continue
            if smallVisited and alreadyVisited[n] >= 1 and n[0].isLowerAscii:
                continue
            n

func getPathsToEndPart2(node: Node, alreadyVisited: CountTable[string],
        graph: Graph, path: seq[string]): seq[seq[string]] =
    let visitable = getVisitableNodesPart2(node.links, alreadyVisited)

    if "end" in node.links:
        result.add(path & "end")

    for n in visitable:
        let node = graph[n]
        var newVisited = alreadyVisited
        newVisited.inc(n)
        result = result & getPathsToEndPart2(node, newVisited, graph, path & n)

func getResultPart2(input: seq[string]): int =
    let graph = parseGraph(input)

    var paths: seq[seq[string]] = @[]

    for starter in graph["start"].links:
        let node = graph[starter]
        paths.add(getPathsToEndPart2(node, toCountTable(["start", starter]),
                graph, @["start", starter]))

    paths.len

when isMainModule:
    let input = readFile("input.txt")
    let lines = splitLines(input)

    echo "part1 result: " & $getResultPart1(lines)
    echo "part2 result: " & $getResultPart2(lines)
