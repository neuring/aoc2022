
fileprivate func parseInput(_ str: String) -> Grid<Int> {
    let lines = str.split(separator: "\n")
    let maxWidth = lines.map { $0.count }.max()!
    let minWidth = lines.map { $0.count }.min()!
    assert(maxWidth == minWidth)

    let height = lines.count
    let width = maxWidth

    var grid = Grid(width: width, height: height, fill: -1)

    for y in 0..<height {
        for (x, h) in lines[y].enumerated() {
            grid[x, y] = Int(String(h))!
        }
    }

    return grid
}

func day08_part1_solve(str: String) throws -> String {
    let grid = parseInput(str)

    var invisible = Grid(width: grid.width, height: grid.height, fill: true)

    let dirConfigurations = [
        (dir: Vector2(x:  0, y: +1), start: { c in Vector2(x: c,              y: 0              )}, length: grid.height, width: grid.width),
        (dir: Vector2(x: +1, y:  0), start: { c in Vector2(x: 0,              y: c              )}, length: grid.width,  width: grid.height),
        (dir: Vector2(x:  0, y: -1), start: { c in Vector2(x: c,              y: grid.height - 1)}, length: grid.height, width: grid.width),
        (dir: Vector2(x: -1, y:  0), start: { c in Vector2(x: grid.width - 1, y: c              )}, length: grid.width,  width: grid.height),
    ]

    for dirConf in dirConfigurations {
        let dir = dirConf.dir
        var gridCopy = grid
        for x in 0..<dirConf.width {
            let p = dirConf.start(x)
            invisible[p] = false
            for y in 1..<dirConf.length {
                let newPoint = p + dir * y
                let oldPoint = p + dir * (y - 1)
                if gridCopy[newPoint] > gridCopy[oldPoint] {
                    invisible[newPoint] = false
                } else {
                    gridCopy[newPoint] = gridCopy[oldPoint]
                }
            }
        }
    }

    let result = invisible.data.reduce(0, { $0 + ($1 ? 0 : 1)})

    return String(result)
}

func day08_part2_solve(str: String) throws -> String {
    let grid = parseInput(str)

    let dirConfigurations = [
        (dir: Vector2(x:  0, y: +1), start: { c in Vector2(x: c,              y: grid.height - 1)}, length: grid.height, width: grid.width),
        (dir: Vector2(x: +1, y:  0), start: { c in Vector2(x: grid.width - 1, y: c              )}, length: grid.width,  width: grid.height),
        (dir: Vector2(x:  0, y: -1), start: { c in Vector2(x: c,              y: 0              )}, length: grid.height, width: grid.width),
        (dir: Vector2(x: -1, y:  0), start: { c in Vector2(x: 0,              y: c              )}, length: grid.width,  width: grid.height),
    ]

    var scenicScore = Grid(width: grid.width, height: grid.height, fill: 1)

    for dirConf in dirConfigurations {
        let dir = dirConf.dir
        var visibleInDirection = Grid(width: grid.width, height: grid.height, fill: 0)
        for x in 0..<dirConf.width {
            let p = dirConf.start(x)

            for y in 1..<dirConf.length {
                var prevTreePos = p - dir * y + dir * 1 
                let curTreePos  = p - dir * y

                while visibleInDirection[prevTreePos] > 0 && grid[curTreePos] > grid[prevTreePos] {
                    visibleInDirection[curTreePos] += visibleInDirection[prevTreePos]
                    prevTreePos = prevTreePos + dir * visibleInDirection[prevTreePos]
                }
                visibleInDirection[curTreePos] += 1
            }
        }

        for (x, y, val) in visibleInDirection.cells() {
            scenicScore[x, y] *= val
        }
    }

    let result = scenicScore.data.max()!

    return String(result)
}