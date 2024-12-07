import Foundation

public class day07 {
    class Calibration {
        let target: Int
        let values: [Int]

        init(_ target: Int, _ values: [Int]) {
            self.target = target
            self.values = values
        }

        static func parse(_ input: String.SubSequence) -> Result<Calibration, dayError> {
            let targetSplitParts = input.split(separator: ":", maxSplits: 1)
            if targetSplitParts.count != 2 {
                return .failure(dayError.stringSplitNotTwoParts)
            }

            let targetStr = targetSplitParts[0]
            let valuesStr = targetSplitParts[1].trimmingPrefix(" ").split(
                whereSeparator: \.isWhitespace)
            if valuesStr.count == 0 {
                return .failure(dayError.listNotEnoughElements)
            }

            guard let target = Int(targetStr) else {
                return .failure(dayError.notAnInteger)
            }

            var values: [Int] = []
            for valueStr in valuesStr {
                guard let value = Int(valueStr) else {
                    return .failure(dayError.notAnInteger)
                }
                values.append(value)
            }

            return .success(Calibration(target, values))
        }

        static func parseInput(_ input: String) -> Result<[Calibration], dayError> {
            var calibrations: [Calibration] = []
            for line in input.lines {
                let calibrationResult = parse(line)
                if case let .failure(error) = calibrationResult {
                    return .failure(error)
                }
                let calibration = try! calibrationResult.get()
                calibrations.append(calibration)
            }
            return .success(calibrations)
        }

        enum MathOperator: String, CaseIterable {
            case Add = "+"
            case Multiply = "*"
            case Concatenate = "||"
        }

        static func cartesianProduct(_ values: [Int], _ operators: [MathOperator])
            -> [[MathOperator]]
        {
            let operatorCount = values.count - 1
            return generateCombinations(for: operatorCount, with: operators)
        }

        static func generateCombinations(for count: Int, with operators: [MathOperator])
            -> [[MathOperator]]
        {
            if count == 0 {
                return [[]]
            }

            var result: [[MathOperator]] = []
            let subCombinations = generateCombinations(for: count - 1, with: operators)

            for op in operators {
                for combination in subCombinations {
                    result.append([op] + combination)
                }
            }

            return result
        }

        func evaluateCartesianProduct(_ operators: [MathOperator]) -> Bool {
            let operatorCombinations = Calibration.cartesianProduct(
                values, operators)
            for operatorCombination in operatorCombinations {
                var combinationResult: Int = values[0]
                for (index, op) in operatorCombination.enumerated() {
                    let value = values[index + 1]
                    switch op {
                    case .Add:
                        combinationResult += value
                    case .Multiply:
                        combinationResult *= value
                    case .Concatenate:
                        combinationResult = Int(String(combinationResult) + String(value))!
                    }
                }
                if combinationResult == target {
                    return true
                }
            }
            return false
        }
    }

    public static func runPart1(_ input: String) -> Result<Int, dayError> {
        let calibrationResult = Calibration.parseInput(input)
        if case let .failure(error) = calibrationResult {
            return .failure(error)
        }

        let calibrations = try! calibrationResult.get()
        var validCalibrationsSum = 0
        for calibration in calibrations {
            if calibration.evaluateCartesianProduct([.Add, .Multiply]) {
                validCalibrationsSum += calibration.target
            }
        }

        return .success(validCalibrationsSum)
    }

    public static func runPart2(_ input: String) -> Result<Int, dayError> {
        let calibrationResult = Calibration.parseInput(input)
        if case let .failure(error) = calibrationResult {
            return .failure(error)
        }

        let calibrations = try! calibrationResult.get()
        var validCalibrationsSum = 0
        for calibration in calibrations {
            if calibration.evaluateCartesianProduct([.Add, .Multiply, .Concatenate]) {
                validCalibrationsSum += calibration.target
            }
        }

        return .success(validCalibrationsSum)
    }
}
