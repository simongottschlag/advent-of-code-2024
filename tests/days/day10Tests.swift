import Foundation
import Testing

@testable import days

let day10TestInput = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

@Suite("day10ParseMap")
struct day10ParseMapTests {
    @Test func parseTestInput() async throws {
        let result = day10.Map.parse(day10TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let map = try! result.get()
        #expect(
            map.grid[0] == [
                day10.Point(8, Position(0, 0)),
                day10.Point(9, Position(1, 0)),
                day10.Point(0, Position(2, 0)),
                day10.Point(1, Position(3, 0)),
                day10.Point(0, Position(4, 0)),
                day10.Point(1, Position(5, 0)),
                day10.Point(2, Position(6, 0)),
                day10.Point(3, Position(7, 0)),
            ])
    }
}

@Suite("day10RunPart1")
struct day10RunPart1Tests {
    @Test func runPart1TestInput() async throws {
        let result = day10.runPart1(day10TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let value = try! result.get()
        #expect(value == 36)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day10.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day10.txt", encoding: .utf8)
        let result = day10.runPart1(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let value = try! result.get()
        #expect(value == 646)
    }
}

@Suite("day10RunPart2")
struct day10RunPart2Tests {
    @Test func runPart2TestInput() async throws {
        let result = day10.runPart2(day10TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let value = try! result.get()
        #expect(value == 81)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day10.txt"))
    )
    func runPart2() {
        let fileContent = try! String(contentsOfFile: "inputs/day10.txt", encoding: .utf8)
        let result = day10.runPart2(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let value = try! result.get()
        #expect(value == 1494)
    }
}
