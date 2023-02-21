fileprivate func parseInput(_ str: String) -> [[Vector2]] {
    return str.split(separator: "\n").map{ line in
        line.split(separator: " -> ").map { 
            let parts = $0.split(separator: ",")
            let x = Int(parts[0])!
            let y = Int(parts[1])!
            return Vector2(x: x, y: y)
        }
    }
}

fileprivate enum Tile {
    case empty, wall, sand

    var symbol: Character { 
        switch self {
            case .empty: return "."
            case .wall: return "#"
            case .sand: return "o"
        }
    }
}

fileprivate extension Vector2 {
    static func interpolate(start: Vector2, end: Vector2) -> [Vector2] {
        assert(start.x == end.x || start.y == end.y)
        let dir = (end - start).signum()

        return (0...Vector2.manhattenDistanceBetween(start, end)).map { start + $0 * dir}
    }
}

fileprivate enum SimulationResult {
    case outOfBounds(Vector2)
    case landed(Vector2)
    case filled
}

fileprivate func simulateGrain(pos: Vector2, grid: Grid<Tile>) -> SimulationResult {
    if grid[pos] != .empty { return .filled }

    let NEXT_DIR = [Vector2(x: 0, y: 1), Vector2(x: -1, y: 1), Vector2(x: 1, y: 1)]

    var curPos = pos
    outer: while grid[curPos] == .empty {
        for dir in NEXT_DIR {
            let nextPos = curPos + dir
            if !grid.contains(vec2: nextPos) {
                return .outOfBounds(nextPos)
            } 

            if grid[nextPos] == .empty {
                curPos = nextPos
                continue outer
            }
        }
        return .landed(curPos)
    }

    assert(false)
}

func day14_part1_solve(str: String) throws -> String {
    let input = parseInput(str)
    let maxX = input.flatMap { $0 }.map{ $0.x }.max()!
    let maxY = input.flatMap { $0 }.map{ $0.y }.max()!
    let minX = input.flatMap { $0 }.map{ $0.x }.min()!

    let width = maxX - minX + 3
    let height = maxY + 2
    let offset = Vector2(x: minX - 1, y: 0)

    var grid = Grid(width: width, height: height, fill: Tile.empty)

    for path in input {
        for i in 1..<path.count {
            let p0 = path[i - 1]
            let p1 = path[i]
            for p in Vector2.interpolate(start: p0, end: p1) {
                grid[p - offset] = .wall
            }
        }
    }

    var counter = 0
    outer: while true {
        let landed = simulateGrain(pos: Vector2(x: 500 - offset.x, y: 0), grid: grid)
        switch landed {
            case .landed(let pos): 
                grid[pos] = .sand
                counter += 1
            default: 
                break outer
        }
    }

    return String(counter)
}

func day14_part2_solve(str: String) throws -> String {
    let input = parseInput(str)
    let maxX = input.flatMap { $0 }.map{ $0.x }.max()!
    let maxY = input.flatMap { $0 }.map{ $0.y }.max()!
    let minX = input.flatMap { $0 }.map{ $0.x }.min()!

    let width = maxX - minX + 3 + 400
    let height = maxY + 4
    let offset = Vector2(x: minX - 1 - 200, y: 0)

    let floor = maxY + 2

    var grid = Grid(width: width, height: height, fill: Tile.empty)

    for path in input {
        for i in 1..<path.count {
            let p0 = path[i - 1]
            let p1 = path[i]
            for p in Vector2.interpolate(start: p0, end: p1) {
                grid[p - offset] = .wall
            }
        }
    }

    for x in 0..<grid.width {
        grid[x, floor] = .wall
    }

    var counter = 0
    outer: while true {
        let landed = simulateGrain(pos: Vector2(x: 500 - offset.x, y: 0), grid: grid)
        switch landed {
            case .landed(let pos): 
                grid[pos] = .sand
                counter += 1
            default: 
                break outer
        }
    }

    return String(counter)
}