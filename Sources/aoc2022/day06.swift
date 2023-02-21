func day06_part1_solve(str: String) throws -> String {
    for i in 0..<str.count {
        let start = str.index(str.startIndex, offsetBy: i)
        let end = str.index(start, offsetBy: 4)
        let substr = str[start..<end]

        if Set(substr).count == 4 {
            return String(i + 4)
        }

    }
    assert(false)
}

func day06_part2_solve(str: String) throws -> String {
    for i in 0..<str.count {
        let start = str.index(str.startIndex, offsetBy: i)
        let end = str.index(start, offsetBy: 14)
        let substr = str[start..<end]

        if Set(substr).count == 14 {
            return String(i + 14)
        }

    }
    assert(false)
}