import Foundation
import Testing

@testable import days

let day09TestInput = "2333133121414131402"

@Suite("day09Parse")
struct day09ParseTests {
    @Test("day09Parse with test input")
    func parseTestInput() {
        let result = day09.parse(day09TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let diskmap = try! result.get()
        #expect(diskmap.blocks.count == 19)
        #expect(
            diskmap.blocks == [
                .File(index: 0, count: 2),
                .Free(count: 3),
                .File(index: 1, count: 3),
                .Free(count: 3),
                .File(index: 2, count: 1),
                .Free(count: 3),
                .File(index: 3, count: 3),
                .Free(count: 1),
                .File(index: 4, count: 2),
                .Free(count: 1),
                .File(index: 5, count: 4),
                .Free(count: 1),
                .File(index: 6, count: 4),
                .Free(count: 1),
                .File(index: 7, count: 3),
                .Free(count: 1),
                .File(index: 8, count: 4),
                .Free(count: 0),
                .File(index: 9, count: 2),
            ])
        #expect(diskmap.toString() == "00...111...2...333.44.5555.6666.777.888899")
        #expect(
            diskmap.toInt() == [
                Optional(0),
                Optional(0),
                nil,
                nil,
                nil,
                Optional(1),
                Optional(1),
                Optional(1),
                nil,
                nil,
                nil,
                Optional(2),
                nil,
                nil,
                nil,
                Optional(3),
                Optional(3),
                Optional(3),
                nil,
                Optional(4),
                Optional(4),
                nil,
                Optional(5),
                Optional(5),
                Optional(5),
                Optional(5),
                nil,
                Optional(6),
                Optional(6),
                Optional(6),
                Optional(6),
                nil,
                Optional(7),
                Optional(7),
                Optional(7),
                nil,
                Optional(8),
                Optional(8),
                Optional(8),
                Optional(8),
                Optional(9),
                Optional(9),
            ])
    }
}

@Suite("day08Compact")
struct day08CompactTests {
    @Test("day08Compact with test input")
    func compactTestInput() {
        let result = day09.parse(day09TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let diskmap = try! result.get()
        let compacted = diskmap.compact()
        #expect(compacted.toString() == "0099811188827773336446555566..............")
    }
}

@Suite("day08CompactedChecksum")
struct day08CompactedChecksumTests {
    @Test("day08CompactedChecksum with test input")
    func compactedChecksumTestInput() {
        let result = day09.parse(day09TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let diskmap = try! result.get()
        let checksum = diskmap.compactedChecksum()
        #expect(checksum == 1928)
    }
}

@Suite("day09RunPart1")
struct day09RunPart1Tests {
    @Test("day09Part1 with test input")
    func test1() {
        let result = day09.runPart1(day09TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let checksum = try! result.get()
        #expect(checksum == 1928)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day09.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day09.txt", encoding: .utf8)
        let result = day09.runPart1(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let checksum = try! result.get()
        #expect(checksum == 6_259_790_630_969)
    }

}
