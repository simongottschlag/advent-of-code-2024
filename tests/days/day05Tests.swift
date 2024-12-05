import Foundation
import Testing

@testable import days

let day05TestInput = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

let day05TestInputRules = [
    day05.Rule(47, 53),
    day05.Rule(97, 13),
    day05.Rule(97, 61),
    day05.Rule(97, 47),
    day05.Rule(75, 29),
    day05.Rule(61, 13),
    day05.Rule(75, 53),
    day05.Rule(29, 13),
    day05.Rule(97, 29),
    day05.Rule(53, 29),
    day05.Rule(61, 53),
    day05.Rule(97, 53),
    day05.Rule(61, 29),
    day05.Rule(47, 13),
    day05.Rule(75, 47),
    day05.Rule(97, 75),
    day05.Rule(47, 61),
    day05.Rule(75, 61),
    day05.Rule(47, 29),
    day05.Rule(75, 13),
    day05.Rule(53, 13),
]

let day05TestInputPages = [
    [75, 47, 61, 53, 29],
    [97, 61, 53, 29, 13],
    [75, 29, 13],
    [75, 97, 47, 61, 53],
    [61, 13, 29],
    [97, 13, 75, 29, 47],
]

final class day05TestCase: Sendable {
    init(pages: [Int], sorted: Bool) {
        self.pages = pages
        self.sorted = sorted
    }

    let pages: [Int]
    let sorted: Bool
}

let day05TestCases: [day05TestCase] = [
    day05TestCase(pages: day05TestInputPages[0], sorted: true),
    day05TestCase(pages: day05TestInputPages[1], sorted: true),
    day05TestCase(pages: day05TestInputPages[2], sorted: true),
    day05TestCase(pages: day05TestInputPages[3], sorted: false),
    day05TestCase(pages: day05TestInputPages[4], sorted: false),
    day05TestCase(pages: day05TestInputPages[5], sorted: false),
]

@Suite("day05ParseInput")
struct day05ParseInputTests {
    @Test func parseInputSucceeds() {
        let result = day05.parseInput(day05TestInput)
        guard case .success(let (rules, pagesList)) = result else {
            if case let .failure(error) = result {
                Issue.record(error)
            }
            Issue.record("Should never be reached")
            return
        }

        #expect(rules == day05TestInputRules)
        #expect(pagesList == day05TestInputPages)
    }
}

@Suite("day05SortPages")
struct day05SortPagesTests {
    @Test func sortPages() {
        for testCase in day05TestCases {
            let result = day05.sortPages(testCase.pages, day05TestInputRules)
            guard case .success(let sortedPages) = result else {
                Issue.record("Should never be reached")
                return
            }
            let sorted = sortedPages == testCase.pages
            #expect(sorted == testCase.sorted)
        }
    }
}

@Suite("day05IsSorted")
struct day05IsSortedTests {
    @Test func isSorted() {
        for testCase in day05TestCases {
            let sorted = day05.isSorted(testCase.pages, day05TestInputRules)
            #expect(sorted == testCase.sorted)
        }
    }
}

@Suite("day05MiddlePages")
struct day05MiddlePagesTests {
    @Test func middlePages() {
        let result = day05.middlePages(day05TestInputPages, day05TestInputRules)
        guard case .success(let middlePages) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(middlePages == [61, 53, 29])
    }
}

@Suite("day05SumMiddlePages")
struct day05SumMiddlePagesTests {
    @Test func sumMiddlePages() {
        let result = day05.sumMiddlePages(day05TestInputPages, day05TestInputRules)
        guard case .success(let sum) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(sum == 143)
    }
}

@Suite("day05RunPart1")
struct day05RunPart1Tests {
    @Test func runPart1TestInput() {
        let result = day05.runPart1(day05TestInput)
        guard case .success(let sum) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(sum == 143)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day05.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day05.txt", encoding: .utf8)
        let result = day05.runPart1(fileContent)
        guard case .success(let sum) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(sum == 4569)
    }
}

@Suite("day05UnsortedPages")
struct day05UnsortedPagesTests {
    @Test func unsortedPages() {
        var unsortedPagesList: [[Int]] = []
        for testCase in day05TestCases {
            if !testCase.sorted {
                unsortedPagesList.append(testCase.pages)
            }
        }

        let result = day05.unsortedPages(day05TestInputPages, day05TestInputRules)
        guard case .success(let unsportedPages) = result else {
            Issue.record("Should never be reached")
            return
        }

        #expect(unsportedPages == unsortedPagesList)
    }
}

@Suite("day05RunPart2")
struct day05RunPart2Tests {
    @Test func runPart2TestInput() {
        let result = day05.runPart2(day05TestInput)
        guard case .success(let sum) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(sum == 123)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day05.txt"))
    )
    func runPart2() {
        let fileContent = try! String(contentsOfFile: "inputs/day05.txt", encoding: .utf8)
        let result = day05.runPart2(fileContent)
        guard case .success(let sum) = result else {
            Issue.record("Should never be reached")
            return
        }
        #expect(sum == 6456)
    }
}
