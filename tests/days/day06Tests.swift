import Foundation
import Testing

@testable import days

let day06TestInput = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

@Suite("day06RunPart1")
struct day06RunPart1Tests {
    @Test func runPart1TestInput() async throws {
        let result = day06.runPart1(day06TestInput)
        if case let .failure(error) = result {
            if case let day06.GridError.NotACell(position) = error {
                Issue.record("Should never be reached: \(position.x), \(position.y)")
            } else {
                Issue.record("Should never be reached: \(error)")
            }
            return
        }

        let distinctPositions = try! result.get()
        #expect(distinctPositions == 41)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day06.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day06.txt", encoding: .utf8)
        let result = day06.runPart1(fileContent)
        if case let .failure(error) = result {
            if case let day06.GridError.NotACell(position) = error {
                Issue.record("Should never be reached: \(position.x), \(position.y)")
            } else {
                Issue.record("Should never be reached: \(error)")
            }
            return
        }

        let distinctPositions = try! result.get()
        #expect(distinctPositions == 5145)
    }
}
