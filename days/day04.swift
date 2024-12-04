public class day04 {
    class Position {
        var x: Int
        var y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        static func == (lhs: Position, rhs: Position) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
    }

    enum Direction {
        case North
        case NorthEast
        case East
        case SouthEast
        case South
        case SouthWest
        case West
        case NorthWest

        static let allCases: [Direction] = [
            .North, .NorthEast, .East, .SouthEast,
            .South, .SouthWest, .West, .NorthWest,
        ]

        func newPos(_ pos: Position) -> Position {
            switch self {
            case .North:  // Straight up
                return Position(pos.x, pos.y - 1)
            case .NorthEast:  // Up and to the right
                return Position(pos.x + 1, pos.y - 1)
            case .East:  // Straight right
                return Position(pos.x + 1, pos.y)
            case .SouthEast:  // Down and to the right
                return Position(pos.x + 1, pos.y + 1)
            case .South:  // Straight down
                return Position(pos.x, pos.y + 1)
            case .SouthWest:  // Down and to the left
                return Position(pos.x - 1, pos.y + 1)
            case .West:  // Straight left
                return Position(pos.x - 1, pos.y)
            case .NorthWest:  // Up and to the left
                return Position(pos.x - 1, pos.y - 1)
            }
        }
    }

    public class matrixParser {
        init(_ input: String, _ searchTerm: String) {
            self.matrix = day04.parseInput(input)
            self.searchTerm = searchTerm.split(separator: "")
        }

        let matrix: [[String.SubSequence]]
        let searchTerm: [String.SubSequence]
        var cursor: Position = Position(-1, -1)

        func advanceCursor() -> Bool {
            if cursor == Position(-1, -1) {
                cursor = Position(0, 0)
                return true
            }

            guard let row = matrix[safe: cursor.y] else {
                return false
            }

            if cursor.x == row.count - 1 {
                let newCursorPosition = Position(0, cursor.y + 1)
                if newCursorPosition.y == matrix.count {
                    return false
                }

                cursor = newCursorPosition
                return true
            }

            cursor = Position(cursor.x + 1, cursor.y)
            return true
        }

        func peek(_ pos: Position) -> String.SubSequence? {
            let row = matrix[safe: pos.y]
            let cell = row?[safe: pos.x]
            return cell
        }

        func searchDirection(_ direction: Direction, _ pos: Position, _ acc: [String.SubSequence])
            -> Bool
        {
            if acc.isEmpty {
                guard let firstCharacter = peek(pos) else {
                    return false
                }
                if firstCharacter != searchTerm.first {
                    return false
                }
                return searchDirection(direction, pos, [firstCharacter])
            }

            let nextPos = direction.newPos(pos)
            guard let nextCharacter = peek(nextPos) else {
                return false
            }

            if nextCharacter == searchTerm[acc.count] {
                if acc.count == searchTerm.count - 1 {
                    return true
                }
                return searchDirection(direction, nextPos, acc + [nextCharacter])
            }

            return false
        }

        func countInstances() -> Int {
            var count = 0
            while advanceCursor() {
                for direction in Direction.allCases {
                    if searchDirection(direction, cursor, []) {
                        count += 1
                    }
                }
            }
            return count
        }

        func isCrossedMAS() -> Bool {
            if peek(cursor) != "A" {
                return false
            }

            let nwPos = Direction.NorthWest.newPos(cursor)  // Up and to the left
            let nwPosResult = searchDirection(Direction.SouthEast, nwPos, [])  // From the top left to the bottom right
            let sePos = Direction.SouthEast.newPos(cursor)  // Down and to the right
            let sePosResult = searchDirection(Direction.NorthWest, sePos, [])  // From the bottom right to the top left

            if !(nwPosResult || sePosResult) {
                return false
            }

            let nePos = Direction.NorthEast.newPos(cursor)  // Up and to the right
            let nePosResult = searchDirection(Direction.SouthWest, nePos, [])  // From the top right to the bottom left
            let swPos = Direction.SouthWest.newPos(cursor)  // Down and to the left
            let swPosResult = searchDirection(Direction.NorthEast, swPos, [])  // From the bottom left to the top right

            return nePosResult || swPosResult
        }

        func countCrossedMAS() -> Int {
            if searchTerm.joined() != "MAS" {
                return 0
            }

            var count = 0
            while advanceCursor() {
                if isCrossedMAS() {
                    count += 1
                }
            }

            return count
        }
    }

    static func parseInput(_ input: String) -> [[String.SubSequence]] {
        return input.lines.map { line in
            return line.split(separator: "")
        }
    }

    public static func runPart1(_ input: String) -> Int {
        let parser = matrixParser(input, "XMAS")
        return parser.countInstances()
    }

    public static func runPart2(_ input: String) -> Int {
        let parser = matrixParser(input, "MAS")
        return parser.countCrossedMAS()
    }
}
