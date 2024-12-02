import Foundation
import Testing

@testable import days

@Suite("day01ParseLine")
struct parseLineTests {
    @Test func parseLineSucceeds() {
        let line: String.SubSequence = "3   4"
        let result = day01.parseLine(line)
        guard case .success(let (a, b)) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(a == 3)
        #expect(b == 4)
    }

    @Test func parseLineFailsEmptyString() {
        let line: String.SubSequence = ""
        let result = day01.parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.emptyInput)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsOneInt() {
        let line: String.SubSequence = "1"
        let result = day01.parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.stringSplitNotTwoParts)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsThreeInts() {
        let line: String.SubSequence = "1 2 3"
        let result = day01.parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.stringSplitNotTwoParts)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsOneIntOneString() {
        let line: String.SubSequence = "1 a"
        let result = day01.parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.notAnUnsignedInteger)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsOneStringOneInt() {
        let line: String.SubSequence = "a 1"
        let result = day01.parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.notAnUnsignedInteger)
        }

        Issue.record("should not be reached")
    }
}

@Suite("day01ParseInput")
struct parseInputTests {
    @Test func parseInputSucceeds() {
        let input = """
            3   4
            4   3
            2   5
            1   3
            3   9
            3   3
            """
        let result = day01.parseInput(input)
        guard case .success(let (x, y)) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(x.count == 6)
        #expect(y.count == 6)
        #expect(x[0] == 3)
        #expect(y[0] == 4)
        #expect(x[1] == 4)
        #expect(y[1] == 3)
        #expect(x[2] == 2)
        #expect(y[2] == 5)
        #expect(x[3] == 1)
        #expect(y[3] == 3)
        #expect(x[4] == 3)
        #expect(y[4] == 9)
        #expect(x[5] == 3)
        #expect(y[5] == 3)
    }

    @Test func parseInputFailsNoInput() {
        let input = ""
        let result = day01.parseInput(input)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.noInputLines)
        }

        Issue.record("should not be reached")
    }

    @Test func parseInputFailsDifferentLength() {
        let input = """
            3   4
            4   3
            2   5
            1   3
            3   9
            3   3
            5
            """
        let result = day01.parseInput(input)
        if case let .failure(error) = result {
            return #expect(error == day01.parseError.stringSplitNotTwoParts)
        }

        Issue.record("should not be reached")
    }
}

@Suite("day01CalculateDistance")
struct calculateDistanceTests {
    @Test func calculateDistancesSucceeds() async throws {
        let a = day01.calculateDistance(1, 2)
        #expect(a == 1)

        let b = day01.calculateDistance(2, 1)
        #expect(b == 1)

        let c = day01.calculateDistance(0, 100)
        #expect(c == 100)

        let d = day01.calculateDistance(100, 0)
        #expect(d == 100)
    }
}

@Suite("day01CalculateDistances")
struct calculateDistancesTests {
    @Test func calculateDistancesSucceeds() {
        let aResult = day01.calculateDistances([1], [2])
        guard case .success(let a) = aResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(a == 1)

        let bResult = day01.calculateDistances([2], [1])
        guard case .success(let b) = bResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(b == 1)

        let cResult = day01.calculateDistances([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3])
        guard case .success(let c) = cResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(c == 11)
    }
}

@Suite("day01RunPart1")
struct runDay01Part1Tests {
    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day01.txt"))
    )
    func runDay01Part1Succeeds() async throws {
        let input = try String(contentsOfFile: "inputs/day01.txt", encoding: .utf8)
        let result = day01.runPart1(input)
        guard case .success(let distance) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(distance == 2_344_935)
    }
}

@Suite("day01CalculateSimilarity")
struct calculateSimilarityTests {
    @Test func calculateSimilaritySucceeds() {
        let aResult = day01.calculateSimilarity([1], [2])
        guard case .success(let a) = aResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(a == 0)

        let bResult = day01.calculateSimilarity([2], [1])
        guard case .success(let b) = bResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(b == 0)

        let cResult = day01.calculateSimilarity([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3])
        guard case .success(let c) = cResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(c == 31)
    }
}

@Suite("day01RunPart2")
struct runDay01Part2Tests {
    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day01.txt"))
    )
    func runDay01Part2Succeeds() async throws {
        let input = try String(contentsOfFile: "inputs/day01.txt", encoding: .utf8)
        let result = day01.runPart2(input)
        guard case .success(let similarityScore) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(similarityScore == 27_647_262)
    }
}
