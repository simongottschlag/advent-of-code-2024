import Testing

@testable import days

@Suite("parseLine")
struct parseLineTests {
    @Test func parseLineSucceeds() {
        let line: String.SubSequence = "3   4"
        let result = parseLine(line)
        guard case .success(let (a, b)) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(a == 3)
        #expect(b == 4)
    }

    @Test func parseLineFailsEmptyString() {
        let line: String.SubSequence = ""
        let result = parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == parseError.emptyInput)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsOneInt() {
        let line: String.SubSequence = "1"
        let result = parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == parseError.stringSplitNotTwoParts)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsThreeInts() {
        let line: String.SubSequence = "1 2 3"
        let result = parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == parseError.stringSplitNotTwoParts)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsOneIntOneString() {
        let line: String.SubSequence = "1 a"
        let result = parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == parseError.notAnUnsignedInteger)
        }

        Issue.record("should not be reached")
    }

    @Test func parseLineFailsOneStringOneInt() {
        let line: String.SubSequence = "a 1"
        let result = parseLine(line)
        if case let .failure(error) = result {
            return #expect(error == parseError.notAnUnsignedInteger)
        }

        Issue.record("should not be reached")
    }
}

@Suite("parseInput")
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
        let result = parseInput(input)
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
        let result = parseInput(input)
        if case let .failure(error) = result {
            return #expect(error == parseError.noInputLines)
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
        let result = parseInput(input)
        if case let .failure(error) = result {
            return #expect(error == parseError.stringSplitNotTwoParts)
        }

        Issue.record("should not be reached")
    }
}

@Suite("calculateDistance")
struct calculateDistanceTests {
    @Test func calculateDistancesSucceeds() async throws {
        let a = calculateDistance(1, 2)
        #expect(a == 1)

        let b = calculateDistance(2, 1)
        #expect(b == 1)

        let c = calculateDistance(0, 100)
        #expect(c == 100)

        let d = calculateDistance(100, 0)
        #expect(d == 100)
    }
}

@Suite("calculateDistances")
struct calculateDistancesTests {
    @Test func calculateDistancesSucceeds() {
        let aResult = calculateDistances([1], [2])
        guard case .success(let a) = aResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(a == 1)

        let bResult = calculateDistances([2], [1])
        guard case .success(let b) = bResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(b == 1)

        let cResult = calculateDistances([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3])
        guard case .success(let c) = cResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(c == 11)
    }
}

@Suite("runDay01Part1")
struct runDay01Part1Tests {
    @Test func runDay01Part1Succeeds() async throws {
        let input = try String(contentsOfFile: "inputs/day01.txt", encoding: .utf8)
        let result = runDay01Part1(input)
        guard case .success(let distance) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(distance == 2_344_935)
    }
}

@Suite("calculateSimilarity")
struct calculateSimilarityTests {
    @Test func calculateSimilaritySucceeds() {
        let aResult = calculateSimilarity([1], [2])
        guard case .success(let a) = aResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(a == 0)

        let bResult = calculateSimilarity([2], [1])
        guard case .success(let b) = bResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(b == 0)

        let cResult = calculateSimilarity([3, 4, 2, 1, 3, 3], [4, 3, 5, 3, 9, 3])
        guard case .success(let c) = cResult else {
            Issue.record("Should never be reached")
            return
        }
        #expect(c == 31)
    }
}

@Suite("runDay01Part2")
struct runDay01Part2Tests {
    @Test func runDay01Part2Succeeds() async throws {
        let input = try String(contentsOfFile: "inputs/day01.txt", encoding: .utf8)
        let result = runDay01Part2(input)
        guard case .success(let similarityScore) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(similarityScore == 27_647_262)
    }
}
