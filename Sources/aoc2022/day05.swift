fileprivate struct CargoConfiguration {
    var pillars: [Array<Character>]

    func prettyPrint() {
        guard let maxHeight = self.pillars.map({ $0.count }).max() else { return }

        for height in (0..<maxHeight).reversed() {
            for pillar in self.pillars {
                if pillar.count <= height {
                    print("    ", terminator: "")
                } else {
                    print("[\(pillar[height])] ", terminator: "")
                }
            }
            print()
        }
    }

    mutating func moveCrates(instruction: Instruction) {
        for _ in 0..<instruction.repetition {
            guard let letter = self.pillars[instruction.from - 1].popLast() else { continue }
            self.pillars[instruction.to - 1].append(letter)
        }
    }

    mutating func moveCratesBulk(instruction: Instruction) {
        // instead of repeating we move the entire stack at once.

        let from = instruction.from - 1
        let to = instruction.to - 1

        let crates = self.pillars[from].suffix(instruction.repetition)
        self.pillars[from].removeLast(instruction.repetition)
        self.pillars[to].append(contentsOf: crates)
    }

    func topLetters() -> String {
        var result = ""

        for pillar in self.pillars {
            guard let topLetter = pillar.last else { continue }
            result.append(topLetter)
        }

        return result
    }
}

fileprivate struct Instruction {
    let from: Int
    let to: Int
    let repetition: Int
}

fileprivate func parseCargoConf(_ str: String.SubSequence) -> CargoConfiguration {
    var rows = str.split(separator: "\n")

    let indices = rows.popLast()! // This lowest row should denote the index of each pillar
    assert(indices.split(separator: " ").allSatisfy { Int($0) != nil })

    let numPillars = rows.map { line in (line.count + 1) / 4}.max()!

    var data: [Array<Character>] = Array(repeating: [], count: numPillars)

    while let row = rows.popLast() {
        var currentPos = row
        for i in 0..<numPillars {
            if currentPos.starts(with: "   ") {
                currentPos = currentPos.suffix(max(currentPos.count - 4, 0))
            } else if currentPos.starts(with: "["){
                let letter = currentPos[currentPos.index(after: currentPos.startIndex)]
                data[i].append(letter)
                currentPos = currentPos.suffix(max(currentPos.count - 4, 0))
            } else {
                assert(false)
            }
        }
    }

    return CargoConfiguration(pillars: data)
}

fileprivate func parseInstructions(_ str: String.SubSequence) -> [Instruction] {
    let regex = try! Regex("move (?P<repetition>\\d+) from (?P<from>\\d+) to (?P<to>\\d+)")

    return str.split(separator: "\n").map { line in
        let match = line.firstMatch(of: regex)!
        let repetiton = Int(match["repetition"]!.substring!)!
        let from = Int(match["from"]!.substring!)!
        let to = Int(match["to"]!.substring!)!
        return Instruction(from: from, to: to, repetition: repetiton)
    }
}

fileprivate func parseInput(_ str: String) -> (intial: CargoConfiguration, instructions: [Instruction]) {
    let parts = str.split(separator: "\n\n")
    let cargoStr = parts[0]
    let instructionStr = parts[1]

    return (parseCargoConf(cargoStr), parseInstructions(instructionStr))
}

func day05_part1_solve(str: String) throws -> String {
    var (cargo, instructions) = parseInput(str)

    for instruction in instructions {
        cargo.moveCrates(instruction: instruction)
    }
    return cargo.topLetters()
}

func day05_part2_solve(str: String) throws -> String {
    var (cargo, instructions) = parseInput(str)

    for instruction in instructions {
        cargo.moveCratesBulk(instruction: instruction)
    }
    return cargo.topLetters()
}