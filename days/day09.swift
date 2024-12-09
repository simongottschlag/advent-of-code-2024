typealias BlockInt = Int?
extension [BlockInt] {
    func toString() -> String {
        return self.map { value in
            if let value = value {
                return "\(value)"
            } else {
                return "."
            }
        }.joined()
    }
}

extension [day09.Block] {
    func toInt() -> [BlockInt] {
        return self.flatMap { $0.toInt() }
    }

    func toString() -> String {
        return self.map { $0.toString() }.joined()
    }
}

public class day09 {

    enum Block: Equatable {
        case File(index: Int, count: Int)
        case Free(count: Int)

        func toString() -> String {
            switch self {
            case .File(let index, let count):
                return (0..<count).map { _ in "\(index)" }.joined()
            case .Free(let count):
                return (0..<count).map { _ in "." }.joined()
            }
        }

        func toInt() -> [BlockInt] {
            switch self {
            case .File(let index, let count):
                return (0..<count).map { _ in index }
            case .Free(let count):
                return (0..<count).map { _ in nil }
            }
        }

        static func == (lhs: Block, rhs: Block) -> Bool {
            switch (lhs, rhs) {
            case (.File(let lIndex, let lCount), .File(let rIndex, let rCount)):
                return lIndex == rIndex && lCount == rCount
            case (.Free(let lCount), .Free(let rCount)):
                return lCount == rCount
            default:
                return false
            }
        }
    }

    class DiskMap {
        var blocks: [Block]

        init(_ blocks: [Block]) {
            self.blocks = blocks
        }

        func toString() -> String {
            return blocks.map { $0.toString() }.joined()
        }

        func toInt() -> [BlockInt] {
            return blocks.flatMap { $0.toInt() }
        }

        func compact() -> [BlockInt] {
            var intBlocks = toInt()
            var left = 0
            var right = intBlocks.count - 1

            while left < right {
                while left < right, intBlocks[left] != nil {
                    left += 1
                }

                while left < right, intBlocks[right] == nil {
                    right -= 1
                }

                if left < right {
                    intBlocks.swapAt(left, right)
                    left += 1
                    right -= 1
                }
            }

            return intBlocks
        }

        func compactPart2() -> [BlockInt] {
            var blocksCopy = blocks.map { $0 }
            for rhsPosition in (0..<blocksCopy.count).reversed() {
                let rhsBlock = blocksCopy[rhsPosition]
                guard case let .File(_, rhsCount) = rhsBlock else {
                    continue
                }

                for lhsPosition in 0..<blocksCopy.count {
                    if lhsPosition >= rhsPosition {
                        break
                    }

                    let lhsBlock = blocksCopy[lhsPosition]
                    guard case let .Free(freeCount) = lhsBlock else {
                        continue
                    }

                    if rhsCount <= freeCount {
                        if rhsCount == freeCount {
                            blocksCopy.swapAt(lhsPosition, rhsPosition)
                            break
                        }

                        let remainderFreeCount = freeCount - rhsCount
                        blocksCopy[lhsPosition] = .Free(count: remainderFreeCount)
                        blocksCopy[rhsPosition] = .Free(count: rhsCount)
                        blocksCopy.insert(rhsBlock, at: lhsPosition)
                        break
                    }
                }
            }

            return blocksCopy.toInt()
        }

        func compactedChecksum() -> Int {
            let intBlocks = compact()
            var sum = 0
            for (index, value) in intBlocks.enumerated() {
                if let value = value {
                    sum += index * value
                }
            }
            return sum
        }

        func compactedPart2Checksum() -> Int {
            let intBlocks = compactPart2()
            var sum = 0
            for (index, value) in intBlocks.enumerated() {
                if let value = value {
                    sum += index * value
                }
            }
            return sum
        }
    }

    static func parse(_ input: String) -> Result<DiskMap, dayError> {
        let lines = input.lines
        guard lines.count == 1 else {
            return .failure(dayError.notSingleLine)
        }

        let line = lines[0]
        var blocks: [Block] = []
        for (index, char) in line.enumerated() {
            guard let value = Int(String(char)) else {
                return .failure(dayError.notAnInteger)
            }

            if index % 2 == 0 {
                blocks.append(.File(index: index / 2, count: value))
                continue
            }

            blocks.append(.Free(count: value))
        }

        return .success(DiskMap(blocks))
    }

    public static func runPart1(_ input: String) -> Result<Int, dayError> {
        let result = parse(input)
        if case let .failure(error) = result {
            return .failure(error)
        }

        let diskmap = try! result.get()
        let checksum = diskmap.compactedChecksum()
        return .success(checksum)
    }

    public static func runPart2(_ input: String) -> Result<Int, dayError> {
        let result = parse(input)
        if case let .failure(error) = result {
            return .failure(error)
        }

        let diskmap = try! result.get()
        let checksum = diskmap.compactedPart2Checksum()
        return .success(checksum)
    }
}
