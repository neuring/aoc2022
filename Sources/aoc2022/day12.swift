fileprivate func parseInput(_ str: String) -> (start: Vector2, goal: Vector2, grid: Grid<Int>){
    var start: Vector2? = nil
    var goal: Vector2? = nil
    let gridData = str.split(separator: "\n").enumerated().map {
        let (y, line) = $0
        return line.enumerated().map {
            let (x, symbol) = $0

            var height: Int? = nil
            switch symbol {
            case "a"..."z": height = Int(symbol.asciiValue!) - Int(Character("a").asciiValue!)
            case "S": 
                height = 0
                start = Vector2(x: x, y: y)
            case "E": 
                height = 25
                goal = Vector2(x: x, y:y)
            default: assert(false, "Invalid symbol in input grid")
            }
            return height!
        }
    }

    let grid = Grid(rowMajor: gridData)

    return (start: start!, goal: goal!, grid: grid)
}

fileprivate let CARDINAL_DIR = [Vector2(x: 1, y: 0), Vector2(x: 0, y: 1), Vector2(x: -1, y:0), Vector2(x: 0, y: -1)]

fileprivate func shortestPath(from: Vector2, grid: Grid<Int>, edgeIf: (Int, Int) -> Bool) -> Grid<Int?> {
    var queue: BinaryHeap = BinaryHeap(withCmpByKey: {(n: (distance: Int, pos: Vector2))->Int in  n.distance} )

    queue.push((distance: 0, pos: from))
    var visited = Grid<Int?>(width: grid.width, height: grid.height, fill: nil)
    visited[from] = 0

    while let node = queue.pop() {
        if visited[node.pos]! < node.distance { continue }

        for dir in CARDINAL_DIR {
            let adjacentNode = node.pos + dir

            if !grid.contains(vec2: adjacentNode) { continue }

            let curHeight = grid[node.pos]
            let nextHeight = grid[adjacentNode]

            if edgeIf(curHeight, nextHeight) {
                let dist = node.distance + 1
                if dist < (visited[adjacentNode] ?? Int.max) {
                    visited[adjacentNode] = dist
                    queue.push((distance: dist, pos: adjacentNode))
                }
            }
        }
    }

    return visited
}

func day12_part1_solve(str: String) throws -> String {
    let (start, end, grid) = parseInput(str)

    let distances = shortestPath(from: start, grid: grid, edgeIf: { curHeight, nextHeight in nextHeight - curHeight <= 1})

    return String(distances[end]!)
}

func day12_part2_solve(str: String) throws -> String {
    let (_, end, grid) = parseInput(str)

    let distances = shortestPath(from: end, grid: grid, edgeIf: { curHeight, nextHeight in curHeight - nextHeight <= 1 })

    let result = zip(distances.data, grid.data).filter { distance, height in distance != nil && height == 0 }.map { distance, _ in distance! }.min()!;

    return String(result)
}