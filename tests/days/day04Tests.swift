import Foundation
import Testing

@testable import days

let day04Part1TestInput = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

@Suite("day04ParseInput")
struct day04ParseInput {
    @Test func parseInput() {
        let result = day04.parseInput(day04Part1TestInput)
        #expect(
            result == [
                ["M", "M", "M", "S", "X", "X", "M", "A", "S", "M"],
                ["M", "S", "A", "M", "X", "M", "S", "M", "S", "A"],
                ["A", "M", "X", "S", "X", "M", "A", "A", "M", "M"],
                ["M", "S", "A", "M", "A", "S", "M", "S", "M", "X"],
                ["X", "M", "A", "S", "A", "M", "X", "A", "M", "M"],
                ["X", "X", "A", "M", "M", "X", "X", "A", "M", "A"],
                ["S", "M", "S", "M", "S", "A", "S", "X", "S", "S"],
                ["S", "A", "X", "A", "M", "A", "S", "A", "A", "A"],
                ["M", "A", "M", "M", "M", "X", "M", "M", "M", "M"],
                ["M", "X", "M", "X", "A", "X", "M", "A", "S", "X"],
            ])
    }
}

@Suite("day04SearchDirection")
struct day04SearchDirection {
    @Test func searchDirectionNorth() {
        let input = """
            S
            A
            M
            X
            """
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.North, day04.Position(0, 3), [])
        #expect(result == true)
    }

    @Test func searchDirectionNorthEast() {
        let input = """
            ...S
            ..A.
            .M..
            X...
            """
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.NorthEast, day04.Position(0, 3), [])
        #expect(result == true)
    }

    @Test func searchDirectionEast() {
        let input = "XMAS"
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.East, day04.Position(0, 0), [])
        #expect(result == true)
    }

    @Test func searchDirectionSouthEast() {
        let input = """
            X...
            .M..
            ..A.
            ...S
            """
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.SouthEast, day04.Position(0, 0), [])
        #expect(result == true)
    }

    @Test func searchDirectionSouth() {
        let input = """
            X
            M
            A
            S
            """
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.South, day04.Position(0, 0), [])
        #expect(result == true)
    }

    @Test func searchDirectionSouthWest() {
        let input = """
            ...X
            ..M.
            .A..
            S...
            """
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.SouthWest, day04.Position(3, 0), [])
        #expect(result == true)
    }

    @Test func searchDirectionWest() {
        let input = "SAMX"
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.West, day04.Position(3, 0), [])
        #expect(result == true)
    }

    @Test func searchDirectionNorthWest() {
        let input = """
            S...
            .A..
            ..M.
            ...X
            """
        let matrixParser = day04.matrixParser(input, "XMAS")
        let result = matrixParser.searchDirection(.NorthWest, day04.Position(3, 3), [])
        #expect(result == true)
    }

}

@Suite("day04RunPart1")
struct day04RunPart1 {
    @Test func runPart1Simple1() {
        let input = """
            S...
            .A..
            ..M.
            ...X
            """
        let result = day04.runPart1(input)
        #expect(result == 1)
    }

    @Test func runPart1Simple2() {
        let input = """
            S..S
            .AA.
            .MM.
            X..X
            """
        let result = day04.runPart1(input)
        #expect(result == 2)
    }

    @Test func runPart1TestInput() {
        let result = day04.runPart1(day04Part1TestInput)
        #expect(result == 18)
    }

    @Test func runPart1TestInput2() {
        let input = """
            ....XXMAS.
            .SAMXMS...
            ...S..A...
            ..A.A.MS.X
            XMASAMX.MM
            X.....XA.A
            S.S.S.S.SS
            .A.A.A.A.A
            ..M.M.M.MM
            .X.X.XMASX
            """
        let result = day04.runPart1(input)
        #expect(result == 18)
    }

    @Test func runPart1TestInput3() {
        let input = """
            .........A
            ........S.
            .......A..
            ......M...
            .....X....
            """
        let result = day04.runPart1(input)
        #expect(result == 1)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day04.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day04.txt", encoding: .utf8)
        let result = day04.runPart1(fileContent)
        #expect(result == 2571)
    }
}
