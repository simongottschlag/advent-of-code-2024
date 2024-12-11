import Foundation
import Testing

@testable import days

let day11TestInput = "125 17"

@Suite("day11ParseInput")
struct day11ParseInputTests {
    @Test func parseTestInput() async throws {
        let result = day11.parse(day11TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let input = try! result.get()
        #expect(input == [125, 17])
    }
}

@Suite("day11SRule1")
struct day11Rule1Tests {
    @Test func rule1Test() async throws {
        let result = day11.parse("0 0 0")
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let stones = try! result.get()
        let ruleResult = stones.toTransformationResults().rule1().flatten()
        #expect(ruleResult == [1, 1, 1])
    }
}

@Suite("day11Rule2")
struct day11Rule2Tests {
    @Test func rule2Test() async throws {
        let result = day11.parse("0 1 9 10 11 20 200 2000 299 2999")
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let stones = try! result.get()
        let ruleResult = stones.toTransformationResults().rule2().flatten()
        #expect(ruleResult == [0, 1, 9, 1, 0, 1, 1, 2, 0, 200, 20, 0, 299, 29, 99])
    }
}

@Suite("day11Rule3")
struct day11Rule3Tests {
    @Test func rule3Test() async throws {
        let result = day11.parse("0 1 22")
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let stones = try! result.get()
        let ruleResult = stones.toTransformationResults().rule3().flatten()
        #expect(ruleResult == [0, 2024, 44528])
    }
}

@Suite("day11Blink")
struct day11BlinkTests {
    @Test func blinkTest() async throws {
        let result = day11.parse(day11TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let stones = try! result.get()

        let blinkResult1 = stones.blink(times: 1)
        #expect(blinkResult1 == [253000, 1, 7])

        let blink2Result = blinkResult1.blink(times: 1)
        #expect(blink2Result == [253, 0, 2024, 14168])
        #expect(blink2Result == stones.blink(times: 2))

        let blink3Result = blink2Result.blink(times: 1)
        #expect(blink3Result == [512072, 1, 20, 24, 28_676_032])
        #expect(blink3Result == stones.blink(times: 3))

        let blink4Result = blink3Result.blink(times: 1)
        #expect(blink4Result == [512, 72, 2024, 2, 0, 2, 4, 2867, 6032])
        #expect(blink4Result == stones.blink(times: 4))

        let blink5Result = blink4Result.blink(times: 1)
        #expect(blink5Result == [1_036_288, 7, 2, 20, 24, 4048, 1, 4048, 8096, 28, 67, 60, 32])
        #expect(blink5Result == stones.blink(times: 5))

        let blink6Result = blink5Result.blink(times: 1)
        #expect(
            blink6Result == [
                2_097_446_912, 14168, 4048, 2, 0, 2, 4, 40, 48, 2024, 40, 48, 80, 96, 2, 8, 6, 7, 6,
                0, 3, 2,
            ])
        #expect(blink6Result == stones.blink(times: 6))

        #expect(stones.blink(times: 6).count == 22)
        #expect(stones.blink(times: 25).count == 55312)
    }
}

@Suite("day11RunPart1")
struct day11RunPart1Tests {
    @Test func runPart1Test() async throws {
        let result = day11.runPart1(day11TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let numberOfStones = try! result.get()
        #expect(numberOfStones == 55312)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day11.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day11.txt", encoding: .utf8)
        let result = day11.runPart1(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }
        let numberOfStones = try! result.get()
        #expect(numberOfStones == 190865)
    }
}
