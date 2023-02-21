func day01_part1_solve(input: String) throws -> String {

    let blocks = input.split(separator: "\n\n")

    let result = blocks.map {
        $0.split(separator: "\n")
            .map{Int($0)!}
            .reduce(0, {$0 + $1})
    }.max()!

    return String(result)
}

func day01_part2_solve(input: String) throws -> String {

    let blocks = input.split(separator: "\n\n")

    var calories = blocks.map {
        $0.split(separator: "\n")
            .map{Int($0)!}
            .reduce(0, {$0 + $1})
    }

    calories.sort()
    let length = calories.count
    let result = calories[length-3..<length].reduce(0, {$0 + $1})

    return String(result)
}