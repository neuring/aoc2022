fileprivate struct Monkey {
    let idx: Int
    let startingItems: [Int]
    let op: (Int) -> Int
    let divisibleBy: Int 
    let nextMonkey: (true: Int, false: Int)
}

fileprivate func parseInput(_ str: String) -> [Monkey] {
    let INPUT_REGEX = try! Regex("""
    Monkey (?P<id>\\d+):
      Starting items: (?P<start_items>(\\d+)(, \\d+)*)
      Operation: new = (?P<op_lhs>[^ ]+) (?P<op>[+*]) (?P<op_rhs>[^ ]+)
      Test: divisible by (?P<divisible_by>\\d+)
        If true: throw to monkey (?P<true_monkey>\\d+)
        If false: throw to monkey (?P<false_monkey>\\d+)
    """)

    return str.matches(of: INPUT_REGEX).map { 
        match in 
        let id = Int(match["id"]!.substring!)!
        let startItems = match["start_items"]!.substring!.split(separator: ", ").map{Int($0)!}
        let op = { switch match["op"]!.substring {
            case "+": return {(a, b: Int) -> Int in a + b}
            case "*": return {(a, b: Int) -> Int in a * b}
            default: precondition(false, "Illegal Operator")
        }}()
        let lhs = String(match["op_lhs"]!.substring!)
        let rhs = String(match["op_rhs"]!.substring!)
        let op_func = { old in switch (lhs, rhs) {
            case ("old", "old"): return op(old      , old)
            case ("old", _    ): return op(old      , Int(rhs)!)
            case (_    , "old"): return op(Int(lhs)!, old)
            case (_    , _    ): return op(Int(lhs)!, Int(rhs)!)
        }}
        let divisibleBy = Int(match["divisible_by"]!.substring!)!
        let trueMonkey = Int(match["true_monkey"]!.substring!)!
        assert(id != trueMonkey)
        let falseMonkey = Int(match["false_monkey"]!.substring!)!
        assert(id != falseMonkey)
        return Monkey(
            idx: id, 
            startingItems: startItems,
            op: op_func,
            divisibleBy: divisibleBy,
            nextMonkey: (true: trueMonkey, false: falseMonkey)
        )
    }
}

func day11_part1_solve(str: String) throws -> String {
    let monkeys = parseInput(str)
    
    var itemsHeld = monkeys.map { $0.startingItems }
    var monkeyActivity = Array(repeating: 0, count: monkeys.count)

    for _ in 1...20 {
        for monkey in monkeys {
            for item in itemsHeld[monkey.idx] {

                let newWorryLevel = monkey.op(item) / 3

                if newWorryLevel % monkey.divisibleBy == 0 {
                    itemsHeld[monkey.nextMonkey.true].append(newWorryLevel)
                } else {
                    itemsHeld[monkey.nextMonkey.false].append(newWorryLevel)
                }

            }

            monkeyActivity[monkey.idx] += itemsHeld[monkey.idx].count
            itemsHeld[monkey.idx] = []
        }
    }

    monkeyActivity.sort(by: >)
    return String(monkeyActivity[0] * monkeyActivity[1])
}

func day11_part2_solve(str: String) throws -> String {
    let monkeys = parseInput(str)
    
    var itemsHeld = monkeys.map { $0.startingItems }
    var monkeyActivity = Array(repeating: 0, count: monkeys.count)

    let mod = monkeys.map { $0.divisibleBy }.reduce(1, *)

    for _ in 1...10000 {
        for monkey in monkeys {
            for item in itemsHeld[monkey.idx] {

                let newWorryLevel = monkey.op(item) % mod

                if newWorryLevel % monkey.divisibleBy == 0 {
                    itemsHeld[monkey.nextMonkey.true].append(newWorryLevel)
                } else {
                    itemsHeld[monkey.nextMonkey.false].append(newWorryLevel)
                }

            }

            monkeyActivity[monkey.idx] += itemsHeld[monkey.idx].count
            itemsHeld[monkey.idx] = []
        }
    }

    monkeyActivity.sort(by: >)
    return String(monkeyActivity[0] * monkeyActivity[1])
}