import Foundation
import Testing

@testable import days

let day03TestInput = """
    xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
    """

let day03TestInputTokens: [day03.Token] = [
    .mul, .roundBracketLeft, .number(2), .comma, .number(4), .roundBracketRight,
    .mul, .number(3), .comma,
    .mul, .roundBracketLeft, .number(5), .comma, .number(5), .roundBracketRight,
    .mul, .roundBracketLeft, .number(32), .comma, .roundBracketLeft,
    .mul, .roundBracketLeft, .number(11), .comma, .number(8), .roundBracketRight,
    .mul, .roundBracketLeft, .number(8), .comma, .number(5), .roundBracketRight,
    .roundBracketRight,
]

@Suite("day03Tokenize")
struct day03Tokenize {
    @Test func tokenize() {
        let tokens = day03.tokenize(day03TestInput)
        let filteredTokens = tokens.filter { $0 != .invalid }
        #expect(
            filteredTokens == day03TestInputTokens)
    }
}

@Suite("day03ParseTokens")
struct day03ParseTokens {
    @Test func parseTokens() {
        let tokens = day03.tokenize(day03TestInput)
        let result = day03.parseTokens(tokens)
        #expect(
            result == [
                .mul(2, 4),
                .mul(5, 5),
                .mul(11, 8),
                .mul(8, 5),
            ])
    }
}

@Suite("day03SumSequence")
struct day03SumSequence {
    @Test func sumSequence() {
        let tokens = day03.tokenize(day03TestInput)
        let sequences = day03.parseTokens(tokens)
        let result = day03.sumSequences(sequences)
        #expect(result == 161)
    }
}

@Suite("day03RunPart1")
struct day03RunPart1 {
    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day03.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day03.txt", encoding: .utf8)
        let result = day03.runPart1(fileContent)
        #expect(result == 174_103_751)
    }
}