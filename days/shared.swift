extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

public enum dayError: Error {
    case emptyInput
    case noInputLines
    case stringSplitNotTwoParts
    case notAnUnsignedInteger
    case notAnInteger
    case listCountNotEqual
    case arrayOutOfBounds
    case listNotEnoughElements
    case shouldNotBeReached
    case topologicalSortFailed
    case listCountEven
    case notImplemented
    case pointsNotAligened
}

public final class Position: Equatable, Sendable, Hashable {
    let x: Int
    let y: Int

    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }

    public static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public func toString() -> String {
        return "Position(\(x), \(y))"
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

func greatestCommonDivisor(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    if r != 0 {
        return greatestCommonDivisor(b, r)
    } else {
        return b
    }
}
