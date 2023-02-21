fileprivate enum Direction {
    case right, left, up, down

    var vector: Vector2 {
        switch self {
        case .right: return Vector2(x: +1, y:  0)
        case .left:  return Vector2(x: -1, y:  0)
        case .up:    return Vector2(x:  0, y: -1)
        case .down:  return Vector2(x:  0, y: +1)
        }
    }

    static func fromCharacter(c: String.SubSequence) -> Direction? {
        switch c {
            case "U": return .up
            case "D": return .down
            case "L": return .left
            case "R": return .right
            default: return nil
        }
    }
}

fileprivate struct Move {
    let dir: Direction
    let distance: Int
}

fileprivate func parseInput(_ str: String) -> [Move] {
    str.split(separator: "\n").map { 
        let parts = $0.split(separator: " ")
        let dir = Direction.fromCharacter(c: parts[0])!
        let length = Int(parts[1])!
        return Move(dir: dir, distance: length)
    }
}

fileprivate func solve(str: String, length: Int) -> String {
    let moves = parseInput(str)
    var rope = Array(repeating: Vector2.zero, count: length)

    var visited: Set<Vector2> = []
    visited.insert(rope.last!)

    for move in moves {
        for _ in 0..<move.distance {

            rope[0] += move.dir.vector

            for i in 1..<rope.count {
                if Vector2.euclidDistanceBetween(rope[i - 1], rope[i]) >= 1.9 {
                    rope[i] += (rope[i - 1] - rope[i]).signum()
                }
            }

            visited.insert(rope.last!)
        }
    }

    return String(visited.count)
}

func day09_part1_solve(str: String) throws -> String {
    return solve(str: str, length: 2)
}

func day09_part2_solve(str: String) throws -> String {
    return solve(str: str, length: 10)
}