import Foundation
import Testing

@testable import days

let day08TestInput = """
    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............
    """

let day08TestInput2 = """
    ..........
    ..........
    ..........
    ....a.....
    ..........
    .....a....
    ..........
    ..........
    ..........
    ..........
    """

let day08TestInput3 = """
    ..........
    ..........
    ..........
    ....a.....
    ........a.
    .....a....
    ..........
    ..........
    ..........
    ..........
    """

let day08Part2TestInput = """
    T.........
    ...T......
    .T........
    ..........
    ..........
    ..........
    ..........
    ..........
    ..........
    ..........
    """

@Suite("day08ParseLine")
struct day08ParseLine {
    @Test func parseLine() async throws {
        let result = day08Part1.parseLine(".A.b.0.", 0)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let points = try! result.get()
        #expect(points.count == 7)
        #expect(points[0].position == Position(0, 0))
        #expect(points[0].pointType == .Empty)
        #expect(points[1].position == Position(1, 0))
        #expect(points[1].pointType == .Antenna("A"))
        #expect(points[2].position == Position(2, 0))
        #expect(points[2].pointType == .Empty)
        #expect(points[3].position == Position(3, 0))
        #expect(points[3].pointType == .Antenna("b"))
        #expect(points[4].position == Position(4, 0))
        #expect(points[4].pointType == .Empty)
        #expect(points[5].position == Position(5, 0))
        #expect(points[5].pointType == .Antenna("0"))
        #expect(points[6].position == Position(6, 0))
        #expect(points[6].pointType == .Empty)
    }
}

@Suite("day08PointAlignment")
struct day08PointAlignment {
    @Test func pointAlignmentDiagonal() async throws {
        let point = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let other = day08Part1.Point(Position(1, 1), .Antenna("A"))
        let result = point.aligned(other)
        #expect(result == .Aligned(.Diagonal))
    }

    @Test func pointAlignmentSame() async throws {
        let point = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let other = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let result = point.aligned(other)
        #expect(result == .NotAligned)
    }

    @Test func pointAlignmentHorizontal() async throws {
        let point = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let other = day08Part1.Point(Position(1, 0), .Antenna("A"))
        let result = point.aligned(other)
        #expect(result == .Aligned(.Horizontal))
    }

    @Test func pointAlignmentVertical() async throws {
        let point = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let other = day08Part1.Point(Position(0, 1), .Antenna("A"))
        let result = point.aligned(other)
        #expect(result == .Aligned(.Vertical))
    }

    @Test func pointAlignmentNone() async throws {
        let point = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let other = day08Part1.Point(Position(1, 2), .Antenna("A"))
        let result = point.aligned(other)
        #expect(result == .NotAligned)
    }

    @Test func pointAlignmentDifferentTypes() async throws {
        let point = day08Part1.Point(Position(0, 0), .Antenna("A"))
        let other = day08Part1.Point(Position(0, 1), .Antenna("B"))
        let result = point.aligned(other)
        #expect(result == .Aligned(.Vertical))
    }
}

@Suite("day08FindAntiNodes")
struct day08FindAntiNodes {
    @Test func findAntiNodesTestInput() async throws {
        let gridResult = day08Part1.parseInput(day08TestInput)
        if case let .failure(error) = gridResult {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let grid = try! gridResult.get()
        let result = grid.findAntiNodes()
        #expect(result.count == 14)
    }

    @Test func findAntiNodesTestInput2() async throws {
        let gridResult = day08Part1.parseInput(day08TestInput2)
        if case let .failure(error) = gridResult {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let grid = try! gridResult.get()
        let result = grid.findAntiNodes()
        #expect(result.count == 2)
    }

    @Test func findAntiNodesTestInput3() async throws {
        let gridResult = day08Part1.parseInput(day08TestInput3)
        if case let .failure(error) = gridResult {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let grid = try! gridResult.get()
        let result = grid.findAntiNodes()
        #expect(result.count == 4)
    }
}

@Suite("day08ParseInput")
struct day08ParseInput {
    @Test func parseInput() async throws {
        let result = day08Part1.parseInput(day08TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let grid = try! result.get()
        #expect(grid.grid.count == 12)
        let antennaCount = grid.grid.flatMap { $0 }.filter { $0.pointType ~= .Antenna("_") }.count
        #expect(antennaCount == 7)
        let emptyCount = grid.grid.flatMap { $0 }.filter { $0.pointType == .Empty }.count
        #expect(emptyCount == 137)
    }
}

@Suite("day08RunPart1")
struct day08RunPart1Tests {
    @Test func runPart1TestInput() async throws {
        let result = day08Part1.run(day08TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let antinodeCount = try! result.get()
        #expect(antinodeCount == 14)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day08.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day08.txt", encoding: .utf8)
        let result = day08Part1.run(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let antinodeCount = try! result.get()
        #expect(antinodeCount == 313)
    }
}

@Suite("day08RunPart2")
struct day08RunPart2Tests {
    @Test func runPart2TestInput() async throws {
        let result = day08Part2.run(day08Part2TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let antinodeCount = try! result.get()
        #expect(antinodeCount == 9)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day08.txt"))
    )
    func runPart2() {
        let fileContent = try! String(contentsOfFile: "inputs/day08.txt", encoding: .utf8)
        let result = day08Part2.run(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let antinodeCount = try! result.get()
        #expect(antinodeCount == 1064)
    }
}
