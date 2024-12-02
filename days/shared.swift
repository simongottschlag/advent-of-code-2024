extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

enum dayError: Error {
    case emptyInput
    case noInputLines
    case stringSplitNotTwoParts
    case notAnUnsignedInteger
    case listCountNotEqual
    case arrayOutOfBounds
}
