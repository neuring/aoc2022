fileprivate struct Range {
    let start: Int
    let end: Int // inclusive

    func subset(of other: Range) -> Bool {
        other.start <= self.start && self.end <= other.end
    }

    func overlap(with other: Range) -> Bool {
        var firstRange = other;
        var secondRange = self

        if self.start <= other.start {
            firstRange = self
            secondRange = other
        } else {
            firstRange = other
            secondRange = self 
        }

        return secondRange.start <= firstRange.end
    }
}

fileprivate func parseSingleRange(_ str: String.SubSequence) -> Range {
    let parts = str.split(separator: "-")
    let startStr = parts[0]
    let endStr = parts[1]
    return Range(start: Int(startStr)!, end: Int(endStr)!)
}

fileprivate func parseInput(_ str: String) -> [(Range, Range)] {
    return str.split(separator: "\n")
        .map { line in
            let parts = line.split(separator: ",")
            let firstRange = parseSingleRange(parts[0])
            let secondRange = parseSingleRange(parts[1])
            return (firstRange, secondRange)
        }
}

func day04_part1_solve(str: String) throws -> String {
    let input = parseInput(str)
    let result = input.filter { $0.subset(of: $1) || $1.subset(of: $0)}.count
    return String(result)
}

func day04_part2_solve(str: String) throws -> String {
    let input = parseInput(str)
    let result = input.filter { $0.overlap(with: $1) }.count
    return String(result)
}