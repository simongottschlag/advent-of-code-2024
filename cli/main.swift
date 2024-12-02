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
            let part1Result = runDay01Part1(fileContent)
            if case let .failure(error) = part1Result {
                print("Day 1, part 1, error: \(error)")
                throw error
            }

            let distance = try! part1Result.get()
            print("Day one, part 1, answer. Distance: \(distance)")

            let part2Result = runDay01Part2(fileContent)
            if case let .failure(error) = part2Result {
                print("Day 1, part 2, error: \(error)")
                throw error
            }

            let similarityScore = try! part2Result.get()
            print("Day one, part 2, answer. Similarity score: \(similarityScore)")
        default:
            print("Day \(day) not implemented")
        }
    }
}

cli.main()
