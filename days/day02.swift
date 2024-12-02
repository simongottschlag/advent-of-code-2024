import Foundation

public class day02 {
    static func parseInput(_ input: String) -> Result<[[UInt]], dayError> {
        if input.isEmpty {
            return .failure(dayError.emptyInput)
        }

        var reports: [[UInt]] = []
        for line in input.lines {
            let result = parseLine(line)
            if case let .failure(error) = result {
                return .failure(error)
            }
            let report = try! result.get()
            reports.append(report)
        }

        return .success(reports)
    }

    static func parseLine(_ input: String.SubSequence) -> Result<[UInt], dayError> {
        if input.isEmpty {
            return .failure(dayError.emptyInput)
        }

        let parts = input.split(whereSeparator: \.isWhitespace)

        var result: [UInt] = []
        for part in parts {
            let v = UInt(part)
            guard let v = v else {
                return .failure(dayError.notAnUnsignedInteger)
            }
            result.append(v)
        }

        return .success(result)
    }

    enum levelDirection {
        case increasing
        case decreasing
        case initializing
    }

    static func isReportSafe(_ levels: [UInt]) -> Result<
        Bool, dayError
    > {
        if levels.isEmpty {
            return .failure(dayError.emptyInput)
        }

        var direction = levelDirection.initializing
        for i in levels.indices {
            if i == levels.count - 1 {
                break
            }

            let distance: Int = Int(levels[i]) - Int(levels[i + 1])
            if distance == 0 {
                return .success(false)
            }

            if distance > 0 {
                if direction == levelDirection.initializing {
                    direction = levelDirection.decreasing
                } else if direction == levelDirection.increasing {
                    return .success(false)
                }
            }

            if distance < 0 {
                if direction == levelDirection.initializing {
                    direction = levelDirection.increasing
                } else if direction == levelDirection.decreasing {
                    return .success(false)
                }
            }

            if direction == levelDirection.decreasing {
                if distance > 3 || distance <= 0 {
                    return .success(false)
                }

            }

            if direction == levelDirection.increasing {
                if distance < -3 || distance >= 0 {
                    return .success(false)
                }
            }
        }

        return .success(true)
    }

    static func countSafeReports(_ reports: [[UInt]]) -> Result<
        Int, dayError
    > {
        var safeReports = 0
        for report in reports {
            let result = isReportSafe(report)
            if case let .failure(error) = result {
                return .failure(error)
            }
            if try! result.get() {
                safeReports += 1
            }
        }
        return .success(safeReports)
    }

    static func isReportSafeWithProblemDampening(_ levels: [UInt]) -> Result<
        Bool, dayError
    > {
        let reportFailuresResult = isReportSafe(levels)
        if case let .failure(error) = reportFailuresResult {
            return .failure(error)
        }

        if try! reportFailuresResult.get() {
            return .success(true)
        }

        for i in levels.indices {
            var newLevels = levels
            newLevels.remove(at: i)
            let result = isReportSafe(newLevels)
            if case let .failure(error) = result {
                return .failure(error)
            }
            if try! result.get() {
                return .success(true)
            }
        }

        return .success(false)
    }

    static func countSafeReportsWithProblemDampening(_ reports: [[UInt]]) -> Result<
        Int, dayError
    > {
        var safeReports = 0
        for report in reports {
            let result = isReportSafeWithProblemDampening(report)
            if case let .failure(error) = result {
                return .failure(error)
            }
            if try! result.get() {
                safeReports += 1
            }
        }
        return .success(safeReports)
    }

    public static func runPart1(_ input: String) -> Result<Int, dayError> {
        let reportsResult = parseInput(input)
        if case let .failure(error) = reportsResult {
            return .failure(error)
        }

        let reports = try! reportsResult.get()
        let safeReportCountResult = countSafeReports(reports)
        if case let .failure(error) = safeReportCountResult {
            return .failure(error)
        }

        let safeReportCount = try! safeReportCountResult.get()
        return .success(safeReportCount)
    }

    public static func runPart2(_ input: String) -> Result<Int, dayError> {
        let reportsResult = parseInput(input)
        if case let .failure(error) = reportsResult {
            return .failure(error)
        }

        let reports = try! reportsResult.get()
        let safeReportCountResult = countSafeReportsWithProblemDampening(reports)
        if case let .failure(error) = safeReportCountResult {
            return .failure(error)
        }

        let safeReportCount = try! safeReportCountResult.get()
        return .success(safeReportCount)
    }
}
