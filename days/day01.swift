import Foundation

public class day01 {
    static func parseLine(_ line: String.SubSequence) -> (Result<(UInt, UInt), dayError>) {
        if line.isEmpty {
            return .failure(dayError.emptyInput)
        }

        let parts = line.split(whereSeparator: \.isWhitespace)
        if parts.count != 2 {
            return .failure(dayError.stringSplitNotTwoParts)
        }

        guard let a = UInt(parts[0]) else {
            return .failure(dayError.notAnUnsignedInteger)
        }

        guard let b = UInt(parts[1]) else {
            return .failure(dayError.notAnUnsignedInteger)
        }

        return .success((a, b))
    }

    static func parseInput(_ input: String) -> Result<([UInt], [UInt]), dayError> {
        if input.lines.count == 0 {
            return .failure(dayError.noInputLines)
        }

        var x: [UInt] = []
        var y: [UInt] = []

        for line in input.lines {
            let result = parseLine(line)

            if case let .failure(error) = result {
                return .failure(error)
            }

            let (a, b) = try! result.get()

            x.append(a)
            y.append(b)
        }

        return .success((x, y))
    }

    static func calculateDistance(_ a: UInt, _ b: UInt) -> UInt {
        if a > b {
            return a - b
        }
        return b - a
    }

    static func calculateDistances(_ x: [UInt], _ y: [UInt]) -> Result<UInt, Error> {
        if x.count != y.count {
            return .failure(dayError.listCountNotEqual)
        }

        var sortedX = x
        sortedX.sort()
        var sortedY = y
        sortedY.sort()

        var sum: UInt = 0
        for i in x.indices {
            guard let a = sortedX[safe: i] else {
                return .failure(dayError.arrayOutOfBounds)
            }
            guard let b = sortedY[safe: i] else {
                return .failure(dayError.arrayOutOfBounds)
            }

            let distance = calculateDistance(a, b)
            sum += distance
        }

        return .success(sum)
    }

    static func calculateSimilarity(_ x: [UInt], _ y: [UInt]) -> Result<UInt, Error> {
        if x.count != y.count {
            return .failure(dayError.listCountNotEqual)
        }

        var sum: UInt = 0
        for a in x {
            var count: UInt = 0
            for b in y {
                if a == b {
                    count += 1
                }
            }
            sum += a * count
        }

        return .success(sum)
    }

    static public func runPart1(_ input: String) -> Result<UInt, Error> {
        switch parseInput(input) {
        case .failure(let error):
            return .failure(error)
        case .success(let (a, b)):
            return calculateDistances(a, b)
        }
    }

    static public func runPart2(_ input: String) -> Result<UInt, Error> {
        let parsedInputResult = parseInput(input)
        if case let .failure(error) = parsedInputResult {
            return .failure(error)
        }

        let (x, y) = try! parsedInputResult.get()
        return calculateSimilarity(x, y)
    }
}
