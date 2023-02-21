
fileprivate func letterScore(_ c: Character) -> Int {
    switch c {
        case "a"..."z": return 1 + Int(c.asciiValue! - Character("a").asciiValue!)
        case "A"..."Z": return 27 + Int(c.asciiValue! - Character("A").asciiValue!)
        default: return 0
    }
}

func day03_part1_solve(str: String) throws -> String {
    let result = str.split(separator: "\n")
        .map({ (line: String.SubSequence) -> Character in 
            assert(line.count % 2 == 0)
            let mid = String.Index(utf16Offset: line.count / 2, in: line)
            let firstHalf = line[..<mid]
            let secondHalf = line[mid..<line.endIndex]
            assert(firstHalf.count == secondHalf.count)

            let s0 = Set(firstHalf)
            let s1 = Set(secondHalf)
            var s2 = Set(s0.intersection(s1))
            assert(s2.count == 1)
            return s2.removeFirst()
        })
        .map(letterScore)
        .reduce(0, {$0 + $1})
    return String(result)
}

func day03_part2_solve(str: String) throws -> String {
    let bags = str.split(separator: "\n")
    assert(bags.count % 3 == 0)

    var result = 0

    for i in 0..<bags.count / 3 {
        var inter: Set<String.Element>? = nil
        for j in 0..<3 {
            let curBag: Set<String.Element> = Set(bags[3 * i + j])
            inter = curBag.intersection(inter ?? curBag)
        }

        assert(inter!.count == 1)
        result += letterScore(inter!.removeFirst())
    }

    return String(result)
}