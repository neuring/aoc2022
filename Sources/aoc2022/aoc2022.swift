import Foundation

struct Configuration {
    let day: Int
    let part: Int
    let content: String

    init?() {
        guard CommandLine.argc >= 4 else {
            return nil
        }

        let day_string = CommandLine.arguments[1]
        guard let day_int = Int(day_string, radix: 10) else { return nil }
        self.day = day_int;

        let part_string = CommandLine.arguments[2]
        guard let part_int = Int(part_string, radix: 10) else { return nil }
        self.part = part_int;

        let inputPath = CommandLine.arguments[3]
        guard let content = try? String(contentsOfFile: inputPath) else { return nil }
        self.content = content
    }
}

@main
class Main {
    static func main() {
        if let config = Configuration() {
            var solver_func: ((String) throws -> String)? = nil
            switch (config.day, config.part) {
                case (01, 1): solver_func = day01_part1_solve
                case (01, 2): solver_func = day01_part2_solve
                case (02, 1): solver_func = day02_part1_solve
                case (02, 2): solver_func = day02_part2_solve
                case (03, 1): solver_func = day03_part1_solve
                case (03, 2): solver_func = day03_part2_solve
                case (04, 1): solver_func = day04_part1_solve
                case (04, 2): solver_func = day04_part2_solve
                case (05, 1): solver_func = day05_part1_solve
                case (05, 2): solver_func = day05_part2_solve
                case (06, 1): solver_func = day06_part1_solve
                case (06, 2): solver_func = day06_part2_solve
                case (07, 1): solver_func = day07_part1_solve
                case (07, 2): solver_func = day07_part2_solve
                case (08, 1): solver_func = day08_part1_solve
                case (08, 2): solver_func = day08_part2_solve
                case (09, 1): solver_func = day09_part1_solve
                case (09, 2): solver_func = day09_part2_solve
                case (10, 1): solver_func = day10_part1_solve
                case (10, 2): solver_func = day10_part2_solve
                case (11, 1): solver_func = day11_part1_solve
                case (11, 2): solver_func = day11_part2_solve
                case (12, 1): solver_func = day12_part1_solve
                case (12, 2): solver_func = day12_part2_solve
                case (13, 1): solver_func = day13_part1_solve
                case (13, 2): solver_func = day13_part2_solve
                case (14, 1): solver_func = day14_part1_solve
                case (14, 2): solver_func = day14_part2_solve
                case (1...25, _): 
                    print("Day \(config.day) has not been solved yet.")
                default: 
                    print("Day \(config.day) out of bounds.")
            }

            guard let solver_func else { 
                return
            }

            do {
                let clock = SuspendingClock()
                var result: String? = nil
                let elapsed: Duration = try clock.measure {
                    result = try solver_func(config.content)
                };
                print("Finished successfully:")
                print("Result: \(result!)")
                print("Time: \(elapsed)")
            } catch let error {
                print("Error during solving: \(error)")
            }

        } else {
            print("Invalid input arguments or unable to read input file")
        }
    }
}