fileprivate indirect enum ListTree {
    case single(Int)
    case list([ListTree])
}

extension ListTree : CustomStringConvertible {
    var description: String {
        var result = ""

        switch self {
            case .single(let i): 
                result.append(i.description)
            case .list(let l):
                result.append("[")
                result.append(l.map { $0.description }.joined(separator: ","))
                result.append("]")
        }
        return result
    }
}

extension ListTree : Equatable {}
extension ListTree : Comparable {
    static func < (lhs: ListTree, rhs: ListTree) -> Bool {
        switch (lhs, rhs) {
        case (.single(let a), .single(let b)): 
            return a < b
        case (.single(let a), .list(let b)): 
            return Self.list([.single(a)]) < Self.list(b)
        case (.list(let a), .single(let b)): 
            return Self.list(a) < Self.list([.single(b)])
        case (.list(let a), .list(let b)):
            for i in 0..<min(a.count, b.count) {
                if a[i] < b[i] { return true }
                else if a[i] > b[i] { return false }
            }

            return a.count < b.count
        }
    }
}

extension ListTree : ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = ListTree

    init(arrayLiteral elements: ListTree...) {
        self = .list(elements)
    }
}

extension ListTree : ExpressibleByIntegerLiteral {
    typealias IntegerLiteralType = Int

    init(integerLiteral value: Int) {
        self = .single(value)
    }
}

fileprivate extension String.SubSequence {
    mutating func trimWhitespace() {
        try! self.trimPrefix { char in char.isWhitespace }
    }
}

fileprivate func parsePacket(_ str: String.SubSequence) -> (result: ListTree, remainder: String.SubSequence)? {
    var s = str
    s.trimWhitespace()
    switch s[s.startIndex] {
        case "[":
            var list: [ListTree] = []
            s.trimPrefix("[")
            while let (tree, remainder) = parsePacket(s) {
                list.append(tree)
                s = remainder
                s.trimWhitespace()
                if s.starts(with: ",") {
                    s.trimPrefix(",")
                    s.trimWhitespace()
                }
            }
            assert(s.starts(with: "]"))
            s.trimPrefix("]")
            return (result: .list(list), remainder: s)
        case "0"..."9": 
            var result = 0
            repeat {
                let char = s[s.startIndex]
                if ("0"..."9").contains(char) {
                    result *= 10
                    result += Int(String(s[s.startIndex]))!
                    s = s[s.index(after: s.startIndex)...]
                } else {
                    break
                }
            } while true
            return (result: .single(result), s)
        default: return nil
    }
}

fileprivate func parseInput(_ str: String) -> [(ListTree, ListTree)] {
    return str.split(separator: "\n\n").map{ (line: String.SubSequence) -> (ListTree, ListTree) in 
        let parts = line.split(separator: "\n")

        let (first, _) = parsePacket(parts[0])!
        let (second, _) = parsePacket(parts[1])!
        return (first, second)
    }
}

func day13_part1_solve(str: String) throws -> String {
    let input = parseInput(str)
    let result = input.enumerated()
        .filter { (_, pair: _) -> Bool in pair.0 < pair.1}
        .map { (idx, _) -> Int in idx + 1 }
        .reduce(0, +)
    return String(result)
}

func day13_part2_solve(str: String) throws -> String {
    let input = parseInput(str)
    var packets = input.flatMap{let (a, b) = $0; return [a, b]}
    packets.append([[2]])
    packets.append([[6]])
    packets.sort()

    let idx1 = packets.firstIndex(of: [[2]])! + 1
    let idx2 = packets.firstIndex(of: [[6]])! + 1

    return String(idx1 * idx2)
}