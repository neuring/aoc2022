import XCTest
import Foundation
@testable import aoc2022


final class aoc2022Tests: XCTestCase {

    var projectPath: String = ".";

    override func setUpWithError() throws {
        let fm = FileManager.default

        // Traverse directory tree upwards to find Inputs folder which contains all input files.
        while true {
            let content = try fm.contentsOfDirectory(atPath: self.projectPath)

            if content.contains("Inputs") {
                break
            } else {
                self.projectPath += "/.."
            }
        }

        self.projectPath += "/Inputs"
    }

    func runTest(_ inputFile: String, _ solve: (String) throws -> String, expected: String) throws {
        let inputPath = "\(self.projectPath)/\(inputFile)"
        let content = try String(contentsOfFile: inputPath)
        let result = try solve(content)
        XCTAssertEqual(result, expected)
    }

    func testDay01Part1Example() throws { try runTest("01_example.txt",  day01_part1_solve, expected: "24000") }
    func testDay01Part1MyInput() throws { try runTest("01_my_input.txt", day01_part1_solve, expected: "72240") }
    func testDay01Part2Example() throws { try runTest("01_example.txt",  day01_part2_solve, expected: "45000") }
    func testDay01Part2MyInput() throws { try runTest("01_my_input.txt", day01_part2_solve, expected: "210957") }

    func testDay02Part1Example() throws { try runTest("02_example.txt",  day02_part1_solve, expected: "15") }
    func testDay02Part1MyInput() throws { try runTest("02_my_input.txt", day02_part1_solve, expected: "11150") }
    func testDay02Part2Example() throws { try runTest("02_example.txt",  day02_part2_solve, expected: "12") }
    func testDay02Part2MyInput() throws { try runTest("02_my_input.txt", day02_part2_solve, expected: "8295") }

    func testDay03Part1Example() throws { try runTest("03_example.txt",  day03_part1_solve, expected: "157") }
    func testDay03Part1MyInput() throws { try runTest("03_my_input.txt", day03_part1_solve, expected: "8072") }
    func testDay03Part2Example() throws { try runTest("03_example.txt",  day03_part2_solve, expected: "70") }
    func testDay03Part2MyInput() throws { try runTest("03_my_input.txt", day03_part2_solve, expected: "2567") }

    func testDay04Part1Example() throws { try runTest("04_example.txt",  day04_part1_solve, expected: "2") }
    func testDay04Part1MyInput() throws { try runTest("04_my_input.txt", day04_part1_solve, expected: "433") }
    func testDay04Part2Example() throws { try runTest("04_example.txt",  day04_part2_solve, expected: "4") }
    func testDay04Part2MyInput() throws { try runTest("04_my_input.txt", day04_part2_solve, expected: "852") }

    func testDay05Part1Example() throws { try runTest("05_example.txt",  day05_part1_solve, expected: "CMZ") }
    func testDay05Part1MyInput() throws { try runTest("05_my_input.txt", day05_part1_solve, expected: "TWSGQHNHL") }
    func testDay05Part2Example() throws { try runTest("05_example.txt",  day05_part2_solve, expected: "MCD") }
    func testDay05Part2MyInput() throws { try runTest("05_my_input.txt", day05_part2_solve, expected: "JNRSCDWPP") }

    func testDay06Part1Example0() throws { try runTest("06_example_0.txt", day06_part1_solve, expected: "7") }
    func testDay06Part1Example1() throws { try runTest("06_example_1.txt", day06_part1_solve, expected: "5") }
    func testDay06Part1Example2() throws { try runTest("06_example_2.txt", day06_part1_solve, expected: "6") }
    func testDay06Part1Example3() throws { try runTest("06_example_3.txt", day06_part1_solve, expected: "10") }
    func testDay06Part1Example4() throws { try runTest("06_example_4.txt", day06_part1_solve, expected: "11") }
    func testDay06Part1MyInput()  throws { try runTest("06_my_input.txt",  day06_part1_solve, expected: "1757") }
    func testDay06Part2Example0() throws { try runTest("06_example_0.txt", day06_part2_solve, expected: "19") }
    func testDay06Part2Example1() throws { try runTest("06_example_1.txt", day06_part2_solve, expected: "23") }
    func testDay06Part2Example2() throws { try runTest("06_example_2.txt", day06_part2_solve, expected: "23") }
    func testDay06Part2Example3() throws { try runTest("06_example_3.txt", day06_part2_solve, expected: "29") }
    func testDay06Part2Example4() throws { try runTest("06_example_4.txt", day06_part2_solve, expected: "26") }
    func testDay06Part2MyInput()  throws { try runTest("06_my_input.txt",  day06_part2_solve, expected: "2950") }

    func testDay07Part1Example() throws { try runTest("07_example.txt",  day07_part1_solve, expected: "95437") }
    func testDay07Part1MyInput() throws { try runTest("07_my_input.txt", day07_part1_solve, expected: "1232307") }
    func testDay07Part2Example() throws { try runTest("07_example.txt",  day07_part2_solve, expected: "24933642") }
    func testDay07Part2MyInput() throws { try runTest("07_my_input.txt", day07_part2_solve, expected: "7268994") }

    func testDay08Part1Example() throws { try runTest("08_example.txt",  day08_part1_solve, expected: "21") }
    func testDay08Part1MyInput() throws { try runTest("08_my_input.txt", day08_part1_solve, expected: "1823") }
    func testDay08Part2Example() throws { try runTest("08_example.txt",  day08_part2_solve, expected: "8") }
    func testDay08Part2MyInput() throws { try runTest("08_my_input.txt", day08_part2_solve, expected: "211680") }

    func testDay09Part1Example() throws { try runTest("09_example.txt",       day09_part1_solve, expected: "13") }
    func testDay09Part1MyInput() throws { try runTest("09_my_input.txt",      day09_part1_solve, expected: "6271") }
    func testDay09Part2Example() throws { try runTest("09_large_example.txt", day09_part2_solve, expected: "36") }
    func testDay09Part2MyInput() throws { try runTest("09_my_input.txt",      day09_part2_solve, expected: "2458") }

    func testDay10Part1Example() throws { try runTest("10_example.txt",  day10_part1_solve, expected: "13140") }
    func testDay10Part1MyInput() throws { try runTest("10_my_input.txt", day10_part1_solve, expected: "14160") }
    func testDay10Part2Example() throws { try runTest("10_example.txt",  day10_part2_solve, expected: """
    ##..##..##..##..##..##..##..##..##..##..
    ###...###...###...###...###...###...###.
    ####....####....####....####....####....
    #####.....#####.....#####.....#####.....
    ######......######......######......####
    #######.......#######.......#######.....
    """) }
    func testDay10Part2MyInput() throws { try runTest("10_my_input.txt", day10_part2_solve, expected: """
    ###....##.####.###..###..####.####..##..
    #..#....#.#....#..#.#..#.#....#....#..#.
    #..#....#.###..#..#.#..#.###..###..#....
    ###.....#.#....###..###..#....#....#....
    #.#..#..#.#....#.#..#....#....#....#..#.
    #..#..##..####.#..#.#....####.#.....##..
    """) }

    func testDay11Part1Example() throws { try runTest("11_example.txt",  day11_part1_solve, expected: "10605") }
    func testDay11Part1MyInput() throws { try runTest("11_my_input.txt", day11_part1_solve, expected: "55930") }
    func testDay11Part2Example() throws { try runTest("11_example.txt",  day11_part2_solve, expected: "2713310158") }
    func testDay11Part2MyInput() throws { try runTest("11_my_input.txt", day11_part2_solve, expected: "14636993466") }

    func testDay12Part1Example() throws { try runTest("12_example.txt",  day12_part1_solve, expected: "31") }
    func testDay12Part1MyInput() throws { try runTest("12_my_input.txt", day12_part1_solve, expected: "339") }
    func testDay12Part2Example() throws { try runTest("12_example.txt",  day12_part2_solve, expected: "29") }
    func testDay12Part2MyInput() throws { try runTest("12_my_input.txt", day12_part2_solve, expected: "332") }

    func testDay13Part1Example() throws { try runTest("13_example.txt",  day13_part1_solve, expected: "13") }
    func testDay13Part1MyInput() throws { try runTest("13_my_input.txt", day13_part1_solve, expected: "5580") }
    func testDay13Part2Example() throws { try runTest("13_example.txt",  day13_part2_solve, expected: "140") }
    func testDay13Part2MyInput() throws { try runTest("13_my_input.txt", day13_part2_solve, expected: "26200") }

    func testDay14Part1Example() throws { try runTest("14_example.txt",  day14_part1_solve, expected: "24") }
    func testDay14Part1MyInput() throws { try runTest("14_my_input.txt", day14_part1_solve, expected: "1330") }
    func testDay14Part2Example() throws { try runTest("14_example.txt",  day14_part2_solve, expected: "93") }
    func testDay14Part2MyInput() throws { try runTest("14_my_input.txt", day14_part2_solve, expected: "26139") }
}
