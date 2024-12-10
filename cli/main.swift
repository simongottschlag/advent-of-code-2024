import ArgumentParser
import days

struct cli: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A CLI to run the different days of Advent of Code"
    )

    @Option(help: "The day to run")
    public var day: Int

    public func run() throws {
        switch day {
        case 1:
            let fileContent = try String(contentsOfFile: "inputs/day01.txt", encoding: .utf8)
            let part1Result = day01.runPart1(fileContent)
            if case let .failure(error) = part1Result {
                print("Day 1, part 1, error: \(error)")
                throw error
            }

            let distance = try! part1Result.get()
            print("Day 1, part 1, answer. Distance: \(distance)")

            let part2Result = day01.runPart2(fileContent)
            if case let .failure(error) = part2Result {
                print("Day 1, part 2, error: \(error)")
                throw error
            }

            let similarityScore = try! part2Result.get()
            print("Day 1, part 2, answer. Similarity score: \(similarityScore)")
        case 2:
            let fileContent = try String(contentsOfFile: "inputs/day02.txt", encoding: .utf8)
            let part1Result = day02.runPart1(fileContent)
            if case let .failure(error) = part1Result {
                print("Day 2, part 1, error: \(error)")
                throw error
            }

            let safeReportCount = try! part1Result.get()
            print("Day 2, part 1, answer. Safe reports: \(safeReportCount)")

            let part2Result = day02.runPart2(fileContent)
            if case let .failure(error) = part2Result {
                print("Day 2, part 2, error: \(error)")
                throw error
            }

            let safeReportCountWithProblemDampening = try! part2Result.get()
            print(
                "Day 2, part 2, answer. Safe reports with problem dampening: \(safeReportCountWithProblemDampening)"
            )
        case 3:
            let fileContent = try String(contentsOfFile: "inputs/day03.txt", encoding: .utf8)
            let sum = day03.runPart1(fileContent)
            print("Day 3, part 1, answer. Sum: \(sum)")

            let part2Sum = day03Part2.runPart2(fileContent)
            print("Day 3, part 2, answer. Sum: \(part2Sum)")
        case 4:
            let fileContent = try String(contentsOfFile: "inputs/day04.txt", encoding: .utf8)
            let count = day04.runPart1(fileContent)
            print("Day 4, part 1, answer. Count: \(count)")

            let countCrossedMAS = day04.runPart2(fileContent)
            print("Day 4, part 2, answer. Count X-MAS: \(countCrossedMAS)")
        case 5:
            let fileContent = try String(contentsOfFile: "inputs/day05.txt", encoding: .utf8)
            let result = day05.runPart1(fileContent)
            if case let .failure(error) = result {
                print("Day 5, part 1, error: \(error)")
                throw error
            }
            let sum = try! result.get()
            print("Day 5, part 1, answer. Sum: \(sum)")

            let result2 = day05.runPart2(fileContent)
            if case let .failure(error) = result2 {
                print("Day 5, part 2, error: \(error)")
                throw error
            }

            let sum2 = try! result2.get()
            print("Day 5, part 2, answer. Sum: \(sum2)")
        case 6:
            let fileContent = try String(contentsOfFile: "inputs/day06.txt", encoding: .utf8)
            let result = day06.runPart1(fileContent)
            if case let .failure(error) = result {
                print("Day 6, part 1, error: \(error)")
                throw error
            }
            let distinctPositions = try! result.get()
            print("Day 6, part 1, answer. Distinct positions: \(distinctPositions)")

            let result2 = day06.runPart2(fileContent)
            if case let .failure(error) = result2 {
                print("Day 6, part 2, error: \(error)")
                throw error
            }
            let locationsWhereObstaclesCreateLoop = try! result2.get()
            print(
                "Day 6, part 2, answer. Locations where obstacles create loop: \(locationsWhereObstaclesCreateLoop)"
            )
        case 7:
            let fileContent = try String(contentsOfFile: "inputs/day07.txt", encoding: .utf8)
            let result = day07.runPart1(fileContent)
            if case let .failure(error) = result {
                print("Day 7, part 1, error: \(error)")
                throw error
            }
            let calibrationSum = try! result.get()
            print("Day 7, part 1, answer. Calibration sum: \(calibrationSum)")

            let result2 = day07.runPart2(fileContent)
            if case let .failure(error) = result2 {
                print("Day 7, part 2, error: \(error)")
                throw error
            }

            let calibrationSum2 = try! result2.get()
            print("Day 7, part 2, answer. Calibration sum: \(calibrationSum2)")
        case 8:
            let fileContent = try String(contentsOfFile: "inputs/day08.txt", encoding: .utf8)
            let result = day08Part1.run(fileContent)
            if case let .failure(error) = result {
                print("Day 8, part 1, error: \(error)")
                throw error
            }
            let antiNodeCount = try! result.get()
            print("Day 8, part 1, answer. Anti node count: \(antiNodeCount)")

            let result2 = day08Part2.run(fileContent)
            if case let .failure(error) = result2 {
                print("Day 8, part 2, error: \(error)")
                throw error
            }
            let antiNodeCount2 = try! result2.get()
            print("Day 8, part 2, answer. Anti node count: \(antiNodeCount2)")
        case 9:
            let fileContent = try String(contentsOfFile: "inputs/day09.txt", encoding: .utf8)
            let result = day09.runPart1(fileContent)
            if case let .failure(error) = result {
                print("Day 9, part 1, error: \(error)")
                throw error
            }
            let checksum = try! result.get()
            print("Day 9, part 1, answer. Checksum: \(checksum)")

            let result2 = day09.runPart2(fileContent)
            if case let .failure(error) = result2 {
                print("Day 9, part 2, error: \(error)")
                throw error
            }

            let checksum2 = try! result2.get()
            print("Day 9, part 2, answer. Checksum: \(checksum2)")
        case 10:
            let fileContent = try String(contentsOfFile: "inputs/day10.txt", encoding: .utf8)
            let result = day10.runPart1(fileContent)
            if case let .failure(error) = result {
                print("Day 10, part 1, error: \(error)")
                throw error
            }
            let value = try! result.get()
            print("Day 10, part 1, answer. Trail score: \(value)")
        default:
            print("Day \(day) not implemented")
        }
    }
}

cli.main()
