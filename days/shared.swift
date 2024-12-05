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
}
