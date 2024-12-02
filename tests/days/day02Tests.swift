import Foundation
import Testing

@testable import days

struct day02ParseLineTestCase {
    var input: String.SubSequence
    var output: [UInt]
    var isSafe: Bool
}

let day02TestCases: [day02ParseLineTestCase] = [
    day02ParseLineTestCase(input: "7 6 4 2 1", output: [7, 6, 4, 2, 1], isSafe: true),
    day02ParseLineTestCase(input: "1 2 7 8 9", output: [1, 2, 7, 8, 9], isSafe: false),
    day02ParseLineTestCase(input: "9 7 6 2 1", output: [9, 7, 6, 2, 1], isSafe: false),
    day02ParseLineTestCase(input: "1 3 2 4 5", output: [1, 3, 2, 4, 5], isSafe: false),
    day02ParseLineTestCase(input: "8 6 4 4 1", output: [8, 6, 4, 4, 1], isSafe: false),
    day02ParseLineTestCase(input: "1 3 6 7 9", output: [1, 3, 6, 7, 9], isSafe: true),
]

let day02TestInput = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

@Suite("day02ParseInput")
struct day02ParseInputTests {
    @Test func parseInputSucceeds() {
        let result = day02.parseInput(day02TestInput)
        guard case .success(let output) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(output == day02TestCases.map { $0.output })
    }
}

@Suite("day02ParseLine")
struct day02ParseLineTests {
    @Test func parseLineSucceeds() {
        for testCase in day02TestCases {
            let result = day02.parseLine(testCase.input)
            guard case .success(let output) = result else {
                Issue.record("Should never be reached")
                return
            }
            #expect(output == testCase.output)
        }
    }
}

@Suite("day02IsReportSafe")
struct day02IsReportSafeTests {
    @Test func isReportSafe() {
        for testCase in day02TestCases {
            let result = day02.isReportSafe(testCase.output)
            guard case .success(let reportIsSafe) = result else {
                Issue.record("Should never be reached")
                return
            }
            #expect(
                reportIsSafe == testCase.isSafe,
                "\(testCase.output) expected to be \(testCase.isSafe)")
        }
    }
}

@Suite("day02CountSafeReports")
struct day02CountSafeReportsTests {
    @Test func countSafeReports() {
        let reports = day02TestCases.map { $0.output }
        let result = day02.countSafeReports(reports)
        guard case .success(let count) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(count == 2)
    }
}

@Suite("day02RunPart1")
struct day02RunPart1Tests {
    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day02.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day02.txt", encoding: .utf8)
        let result = day02.runPart1(fileContent)
        guard case .success(let count) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(count == 472)
    }
}
