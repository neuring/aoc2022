fileprivate enum Instruction {
    case noop, addx(Int)
}

fileprivate func parseInput(_ str: String) -> [Instruction] {
    str.split(separator: "\n")
        .map { line in
            if line == "noop" { return .noop }
            else {
                assert(line.starts(with: "addx"))
                let parts = line.split(separator: " ")
                let arg = Int(parts[1])!
                return .addx(arg)
            }
        }
}

func day10_part1_solve(str: String) throws -> String {
    let program = parseInput(str)

    var cycle = 0
    var register = 1

    let measurePoints = [20, 60, 100, 140, 180, 220]
    var result = 0

    for i in program {
        switch i {
        case .noop:
            cycle += 1    
            if measurePoints.contains(cycle) { 
                result += cycle * register 
            }
        case .addx(let arg):
            cycle += 1
            if measurePoints.contains(cycle) { 
                result += cycle * register 
            }
            cycle += 1
            if measurePoints.contains(cycle) { 
                result += cycle * register 
            }
            register += arg
        }
    }

    return String(result)
}

func day10_part2_solve(str: String) throws -> String {
    let program = parseInput(str)

    var cycle = 0
    var register = 1

    var row = Array(repeating: false, count: 40)
    let measurePoints = Array((1...6).map{ $0 * 40})
    var result = ""

    let drawpixel = { (cycle: Int) -> Void in 
        if abs(((cycle - 1) % 40 - register)) <= 1 {
            row[(cycle - 1) % 40] = true
        }

        if measurePoints.contains(cycle) {
            let line = String(row.map { $0 ? "#" : "."})
            result.append(line + "\n")
            row = Array(repeating: false, count: 40)
        }
    }

    for i in program {
        switch i {
        case .noop:
            cycle += 1    
            drawpixel(cycle)
        case .addx(let arg):
            cycle += 1
            drawpixel(cycle)
            cycle += 1
            drawpixel(cycle)
            register += arg
        }
    }

    return result.trimmingCharacters(in: ["\n"])
}