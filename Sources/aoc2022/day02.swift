fileprivate enum Action {
    case rock, paper, scissor

    var score: Int {
        switch self {
            case .rock:    return 1
            case .paper:   return 2
            case .scissor: return 3
        }
    }

    static func fromOpponentLetter(_ c: Character) -> Action? {
        switch c {
            case "A": return .rock
            case "B": return .paper
            case "C": return .scissor
            default: return nil
        }
    }

    static func fromYouLetter(_ c: Character) -> Action? {
        switch c {
            case "X": return .rock
            case "Y": return .paper
            case "Z": return .scissor
            default: return nil
        }
    }
}

fileprivate enum Finish {
    case win, loose, draw

    var score: Int {
        switch self {
            case .win: return 6
            case .draw: return 3
            case .loose: return 0
        }
    }

    static func fromLetter(_ c: Character) -> Finish? {
        switch c {
            case "X": return .loose
            case "Y": return .draw
            case "Z": return .win
            default: return nil
        }
    }
}

fileprivate func roundResult(you: Action, opponent: Action) -> Finish {
    switch (you, opponent) {
        case (.rock, .paper): return Finish.loose
        case (.rock, .scissor): return Finish.win
        case (.paper, .rock): return Finish.win
        case (.paper, .scissor): return Finish.loose
        case (.scissor, .rock): return Finish.loose
        case (.scissor, .paper): return Finish.win
        default: return Finish.draw
    }
}

fileprivate func parseInput01(_ input: String) -> [(you: Action, opponent: Action)] {
    return input.split(separator: "\n")
        .map { line in 
            assert(line.count == 3)
            let opponentAction = Action.fromOpponentLetter(line[line.indices.startIndex + 0])!
            let yourAction = Action.fromYouLetter(line[line.indices.startIndex + 2])!
            return (yourAction, opponentAction)
        }
}

func day02_part1_solve(str: String) throws -> String {
    let input = parseInput01(str)
    let result = input.map { roundResult(you: $0.you, opponent: $0.opponent).score + $0.you.score }
                      .reduce(0, {$0 + $1})
    return String(result)
}

fileprivate func parseInput02(_ input: String) -> [(opponent: Action, result: Finish)] {
    return input.split(separator: "\n")
        .map { line in 
            assert(line.count == 3)
            let opponentAction = Action.fromOpponentLetter(line[line.indices.startIndex + 0])!
            let finish = Finish.fromLetter(line[line.indices.startIndex + 2])!
            return (opponentAction, finish)
        }
}


fileprivate func forceResult(opponent: Action, wanted: Finish) -> Action {
    switch (opponent, wanted) {
        case (.rock, .win): return .paper
        case (.scissor, .win): return .rock
        case (.paper, .win): return .scissor
        case (.rock, .loose): return .scissor
        case (.scissor, .loose): return .paper
        case (.paper, .loose): return .rock
        default: return opponent
    }
}

func day02_part2_solve(str: String) throws -> String {
    let input = parseInput02(str)
    let result = input.map { 
            let myAction = forceResult(opponent: $0.opponent, wanted: $0.result)
            return $0.result.score + myAction.score
        }
        .reduce(0, {$0 + $1})
    return String(result)
}

