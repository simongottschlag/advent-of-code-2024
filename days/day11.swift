public typealias Stone = Int

enum StoneTransformationResult {
    case Unchanged(Stone)
    case Changed(Stone)
    case Replaced([Stone])

    func toString() -> String {
        switch self {
        case .Unchanged(let stone):
            return "Unchanged: \(stone)"
        case .Changed(let stone):
            return "Changed: \(stone)"
        case .Replaced(let stones):
            return "Replaced: \(stones)"
        }
    }
}

extension Stone {
    func digitCount() -> Int {
        return String(abs(self)).count
    }

    func splitInHalf() -> [Int]? {
        guard self.digitCount() % 2 == 0 else {
            return nil
        }

        let digits = String(abs(self))
        return Int(digits.prefix(digits.count / 2)).flatMap { left in
            Int(digits.suffix(digits.count / 2)).map { right in
                [left, right]
            }
        }
    }
}

extension [Stone] {
    func toTransformationResults() -> [StoneTransformationResult] {
        return self.map { .Unchanged($0) }
    }

    func blink(times: Int) -> [Stone] {
        return self.toTransformationResults().blink(times: times)
    }
}

extension Array where Element == StoneTransformationResult {
    func transformResults(_ transform: (Stone) -> StoneTransformationResult)
        -> [StoneTransformationResult]
    {
        var result: [StoneTransformationResult] = []
        for element in self {
            switch element {
            case .Unchanged(let stone):
                let transformed = transform(stone)
                result.append(transformed)
            case .Changed, .Replaced:
                result.append(element)
            }
        }
        return result
    }

    func flatten() -> [Stone] {
        var stones: [Stone] = []
        for element in self {
            switch element {
            case .Unchanged(let value):
                stones.append(value)
            case .Changed(let value):
                stones.append(value)
            case .Replaced(let values):
                stones.append(contentsOf: values)
            }
        }
        return stones
    }
}

extension Array where Element == StoneTransformationResult {
    func rule1() -> [StoneTransformationResult] {
        return self.transformResults { stone in
            if stone == 0 {
                return .Changed(1)
            }

            return .Unchanged(stone)
        }
    }

    func rule2() -> [StoneTransformationResult] {
        return self.transformResults { stone in
            if let values = stone.splitInHalf() {
                return .Replaced(values)
            }

            return .Unchanged(stone)
        }
    }

    func rule3() -> [StoneTransformationResult] {
        return self.transformResults { stone in
            return .Changed(stone * 2024)
        }
    }

    func reset() -> [StoneTransformationResult] {
        return self.flatten().toTransformationResults()
    }

    func blink(times: Int) -> [Stone] {
        var results: [StoneTransformationResult] = self
        for _ in 0..<times {
            results = results.rule1().rule2().rule3().reset()
        }
        return results.flatten()
    }
}

public class day11 {
    static func parse(_ input: String) -> Result<[Stone], dayError> {
        guard let line = input.lines.first, input.lines.count == 1 else {
            return .failure(.notSingleLine)
        }

        let parts = line.split(whereSeparator: \.isWhitespace)
        let integers = parts.compactMap { Int($0) }

        return integers.count == parts.count
            ? .success(integers)
            : .failure(.notAnInteger)
    }

    public static func runPart1(_ input: String) -> Result<Int, dayError> {
        let result = parse(input)
        if case let .failure(error) = result {
            return .failure(error)
        }
        let stones = try! result.get()
        return .success(stones.blink(times: 25).count)
    }

    public static func runPart2(_ input: String) -> Result<Int, dayError> {
        let result = parse(input)
        if case let .failure(error) = result {
            return .failure(error)
        }
        let stones = try! result.get()
        return .success(stones.blink(times: 75).count)
    }
}
