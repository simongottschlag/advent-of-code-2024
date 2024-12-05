import SwiftGraph

public class day05 {
    final class Rule: Equatable, Sendable {
        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        let x: Int
        let y: Int

        static func == (lhs: Rule, rhs: Rule) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
    }

    static func parseRule(_ input: String.SubSequence) -> Result<Rule, dayError> {
        let parts = input.split(separator: "|")
        if parts.count != 2 {
            return .failure(dayError.listNotEnoughElements)
        }

        guard let x = Int(parts[0]) else {
            return .failure(dayError.notAnInteger)
        }

        guard let y = Int(parts[1]) else {
            return .failure(dayError.notAnInteger)
        }

        return .success(Rule(x, y))
    }

    static func parsePages(_ input: String.SubSequence) -> Result<[Int], dayError> {
        let parts = input.split(separator: ",")
        if parts.isEmpty {
            return .failure(dayError.emptyInput)
        }

        var pages: [Int] = []
        for part in parts {
            guard let page = Int(part) else {
                return .failure(dayError.notAnInteger)
            }

            pages.append(page)
        }

        return .success(pages)
    }

    static func parseInput(_ input: String) -> Result<([Rule], [[Int]]), dayError> {
        var rules: [Rule] = []
        var pagesList: [[Int]] = []
        let parts = input.split(separator: "\n\n")
        if parts.count != 2 {
            return .failure(dayError.listNotEnoughElements)
        }

        for line in parts[0].lines {
            let result = parseRule(line)
            if case let .failure(error) = result {
                return .failure(error)
            }
            let rule = try! result.get()
            rules.append(rule)
        }

        for line in parts[1].lines {
            let result = parsePages(line)
            if case let .failure(error) = result {
                return .failure(error)
            }
            let pages = try! result.get()
            pagesList.append(pages)

        }

        return .success((rules, pagesList))
    }

    static func sortPages(_ pages: [Int], _ rules: [Rule]) -> Result<[Int], dayError> {
        let graph = UnweightedGraph<Int>(vertices: pages)
        for rule in rules {
            graph.addEdge(from: rule.x, to: rule.y, directed: true)
        }
        guard let sorted = graph.topologicalSort() else {
            return .failure(dayError.topologicalSortFailed)
        }
        return .success(sorted)
    }

    static func isSorted(_ pages: [Int], _ rules: [Rule]) -> Bool {
        let sorted = sortPages(pages, rules)
        guard case let .success(sortedPages) = sorted else {
            return false
        }
        return sortedPages == pages
    }

    static func middlePages(_ pagesList: [[Int]], _ rules: [Rule]) -> Result<[Int], dayError> {
        var middlePages: [Int] = []
        for pages in pagesList {
            if pages.count % 2 == 0 {
                return .failure(dayError.listCountEven)
            }

            guard isSorted(pages, rules) else {
                continue
            }

            let middlePage = pages[pages.count / 2]
            middlePages.append(middlePage)
        }

        return .success(middlePages)
    }

    static func unsortedPages(_ pagesList: [[Int]], _ rules: [Rule]) -> Result<[[Int]], dayError> {
        var unsortedPagesList: [[Int]] = []
        for pages in pagesList {
            if pages.count % 2 == 0 {
                return .failure(dayError.listCountEven)
            }

            guard !isSorted(pages, rules) else {
                continue
            }

            unsortedPagesList.append(pages)
        }

        return .success(unsortedPagesList)
    }

    static func sumMiddlePages(_ pagesList: [[Int]], _ rules: [Rule]) -> Result<Int, dayError> {
        let result = middlePages(pagesList, rules)
        if case let .failure(error) = result {
            return .failure(error)
        }

        let middlePages = try! result.get()
        var sum = 0
        for page in middlePages {
            sum += page
        }

        return .success(sum)
    }

    public static func runPart1(_ input: String) -> Result<Int, dayError> {
        let result = parseInput(input)
        if case let .failure(error) = result {
            return .failure(error)
        }

        let (rules, pagesList) = try! result.get()
        return sumMiddlePages(pagesList, rules)
    }

    public static func runPart2(_ input: String) -> Result<Int, dayError> {
        let result = parseInput(input)
        if case let .failure(error) = result {
            return .failure(error)
        }

        let (rules, pagesList) = try! result.get()
        let unsortedPagesResult = unsortedPages(pagesList, rules)
        if case let .failure(error) = result {
            return .failure(error)
        }

        let unsortedPagesList = try! unsortedPagesResult.get()
        var sortedPagesList: [[Int]] = []
        for pages in unsortedPagesList {
            let sortedResult = sortPages(pages, rules)
            if case let .failure(error) = sortedResult {
                return .failure(error)
            }

            let sortedPages = try! sortedResult.get()
            sortedPagesList.append(sortedPages)
        }

        let sumResult = sumMiddlePages(sortedPagesList, rules)
        if case let .failure(error) = sumResult {
            return .failure(error)
        }

        let sum = try! sumResult.get()

        return .success(sum)
    }
}
