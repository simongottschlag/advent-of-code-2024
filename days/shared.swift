extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
