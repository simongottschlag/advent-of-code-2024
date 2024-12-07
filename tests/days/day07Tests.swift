import Foundation
import Testing

@testable import days

let day07TestInput = """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    """

@Suite("day07ParseCalibration")
struct day07Parse {
    @Test func parseCalibration1() async throws {
        let calibrationResult = day07.Calibration.parse("190: 10 19")
        if case let .failure(error) = calibrationResult {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let calibration = try! calibrationResult.get()
        #expect(calibration.target == 190)
        #expect(calibration.values == [10, 19])
    }
}

@Suite("day07ParseInput")
struct day07ParseInput {
    @Test func parseInput() async throws {
        let calibrationResult = day07.Calibration.parseInput(day07TestInput)
        if case let .failure(error) = calibrationResult {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let calibrations = try! calibrationResult.get()
        #expect(calibrations.count == 9)
        #expect(calibrations[0].target == 190)
        #expect(calibrations[0].values == [10, 19])
        #expect(calibrations[1].target == 3267)
        #expect(calibrations[1].values == [81, 40, 27])
        #expect(calibrations[2].target == 83)
        #expect(calibrations[2].values == [17, 5])
        #expect(calibrations[3].target == 156)
        #expect(calibrations[3].values == [15, 6])
        #expect(calibrations[4].target == 7290)
        #expect(calibrations[4].values == [6, 8, 6, 15])
        #expect(calibrations[5].target == 161011)
        #expect(calibrations[5].values == [16, 10, 13])
        #expect(calibrations[6].target == 192)
        #expect(calibrations[6].values == [17, 8, 14])
        #expect(calibrations[7].target == 21037)
        #expect(calibrations[7].values == [9, 7, 18, 13])
        #expect(calibrations[8].target == 292)
        #expect(calibrations[8].values == [11, 6, 16, 20])
    }
}

@Suite("day07CartesianProduct")
struct day07CartesianProduct {
    @Test func cartesianProduct1() async throws {
        let cartisianProduct = day07.Calibration.cartesianProduct(
            [1, 2], day07.Calibration.MathOperator.allCases)
        #expect(
            cartisianProduct == [
                [.Add],
                [.Multiply],
            ]
        )
    }

    @Test func cartesianProduct2() async throws {
        let cartisianProduct = day07.Calibration.cartesianProduct(
            [1, 2, 3], day07.Calibration.MathOperator.allCases)
        #expect(
            cartisianProduct == [
                [.Add, .Add],
                [.Add, .Multiply],
                [.Multiply, .Add],
                [.Multiply, .Multiply],
            ]
        )
    }

    @Test func cartesianProduct3() async throws {
        let cartisianProduct = day07.Calibration.cartesianProduct(
            [1, 2, 3, 4], day07.Calibration.MathOperator.allCases)
        #expect(
            cartisianProduct == [
                [.Add, .Add, .Add],
                [.Add, .Add, .Multiply],
                [.Add, .Multiply, .Add],
                [.Add, .Multiply, .Multiply],
                [.Multiply, .Add, .Add],
                [.Multiply, .Add, .Multiply],
                [.Multiply, .Multiply, .Add],
                [.Multiply, .Multiply, .Multiply],
            ]
        )
    }
}

@Suite("day07EvaluateCartesianProduct")
struct day07EvaluateCartesianProduct {
    @Test func evaluateCartesianProduct() async throws {
        let calibration = day07.Calibration(190, [10, 19])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == true)
    }

    @Test func evaluateCartesianProduct2() async throws {
        let calibration = day07.Calibration(3267, [81, 40, 27])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == true)
    }

    @Test func evaluateCartesianProduct3() async throws {
        let calibration = day07.Calibration(292, [11, 6, 16, 20])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == true)
    }

    @Test func evaluateCartesianProduct4() async throws {
        let calibration = day07.Calibration(83, [17, 5])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == false)
    }

    @Test func evaluateCartesianProduct5() async throws {
        let calibration = day07.Calibration(156, [15, 6])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == false)
    }

    @Test func evaluateCartesianProduct6() async throws {
        let calibration = day07.Calibration(7290, [6, 8, 6, 15])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == false)
    }

    @Test func evaluateCartesianProduct7() async throws {
        let calibration = day07.Calibration(161011, [16, 10, 13])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == false)
    }

    @Test func evaluateCartesianProduct8() async throws {
        let calibration = day07.Calibration(192, [17, 8, 14])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == false)
    }

    @Test func evaluateCartesianProduct9() async throws {
        let calibration = day07.Calibration(21037, [9, 7, 18, 13])
        let result = calibration.evaluateCartesianProduct()
        #expect(result == false)
    }
}

@Suite("day07RunPart1")
struct day07RunPart1Tests {
    @Test func runPart1TestInput() async throws {
        let result = day07.runPart1(day07TestInput)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let calibrationSum = try! result.get()
        #expect(calibrationSum == 3749)
    }

    @Test(
        .enabled(if: FileManager.default.fileExists(atPath: "inputs/day07.txt"))
    )
    func runPart1() {
        let fileContent = try! String(contentsOfFile: "inputs/day07.txt", encoding: .utf8)
        let result = day07.runPart1(fileContent)
        if case let .failure(error) = result {
            Issue.record("Should never be reached: \(error)")
            return
        }

        let calibrationSum = try! result.get()
        #expect(calibrationSum == 2_654_749_936_343)
    }
}
