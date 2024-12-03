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
        default:
            print("Day \(day) not implemented")
        }
    }
}

cli.main()
