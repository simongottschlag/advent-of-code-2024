public class day06 {
    enum GameCharacterDirection: Character, CaseIterable {
        case North = "^"
        case East = ">"
        case South = "v"
        case West = "<"

        init?(_ rawCell: Character) {
            switch rawCell {
            case "^":
                self = .North
            case ">":
                self = .East
            case "v":
                self = .South
            case "<":
                self = .West
            default:
                return nil
            }
        }
    }

    class GameCharacter {
        var direction: GameCharacterDirection
        var position: Position

        func peek() -> Position {
            switch direction {
            case .North:
                return Position(position.x, position.y - 1)
            case .East:
                return Position(position.x + 1, position.y)
            case .South:
                return Position(position.x, position.y + 1)
            case .West:
                return Position(position.x - 1, position.y)
            }
        }

        init(_ direction: GameCharacterDirection, _ position: Position) {
            self.direction = direction
            self.position = position
        }

        static func parse(_ rawCell: Character, _ position: Position) -> GameCharacter? {
            guard let direction = GameCharacterDirection(rawValue: rawCell) else {
                return nil
            }

            return GameCharacter(direction, position)
        }

        func toString() -> String {
            return String(direction.rawValue)
        }
    }

    enum CellType {
        case Obstruction
        case Path
        case UnmappedArea

        static func getCellType(_ rawCell: Character, _ postion: Position) -> (
            CellType?, GameCharacter?
        ) {
            if let gameCharacter = GameCharacter.parse(rawCell, postion) {
                return (.Path, gameCharacter)
            }

            switch rawCell {
            case "#":
                return (Obstruction, nil)
            case ".":
                return (Path, nil)
            default:
                return (nil, nil)
            }
        }
    }

    class Cell {
        let cellType: CellType
        let position: Position
        var visited: Int = 0

        init(_ cellType: CellType, _ position: Position, _ visited: Int) {
            self.cellType = cellType
            self.position = position
            self.visited = visited
        }

        static func parse(_ rawCell: Character, _ position: Position) -> (Cell?, GameCharacter?) {
            let (cellType, gameCharacter) = CellType.getCellType(rawCell, position)
            if let cellType = cellType {
                let visited: Int = gameCharacter != nil ? 1 : 0
                return (Cell(cellType, position, visited), gameCharacter)
            }

            return (nil, nil)
        }

        func visit() {
            visited += 1
        }

        func toString() -> String {
            switch cellType {
            case .Obstruction:
                return "#"
            case .Path:
                if visited > 0 {
                    return "X"
                }

                return "."
            default:
                return "-"
            }

        }
    }

    public enum GridError: Error {
        case NotACell(Position)
        case MoreThanOneGameCharacter(Position)
        case NoGameCharacter
        case GridLoop
    }

    class Grid {
        init(_ grid: [[Cell]], _ gameCharacter: GameCharacter) {
            self.grid = grid
            self.gameCharacter = gameCharacter
            self.startPosition = gameCharacter.position
            self.startDirection = gameCharacter.direction
        }

        var grid: [[Cell]]
        var gameCharacter: GameCharacter
        let startPosition: Position
        let startDirection: GameCharacterDirection
        var visitedStates: Set<String> = []

        static func parse(_ input: String) -> Result<Grid, GridError> {
            var grid: [[Cell]] = []
            var gameChar: GameCharacter? = nil
            for (y, line) in input.lines.enumerated() {
                var cells: [Cell] = []
                for (x, rawCell) in line.enumerated() {
                    let (cell, gameCharacter) = Cell.parse(rawCell, Position(x, y))
                    guard let cell = cell else {
                        return .failure(GridError.NotACell(Position(x, y)))
                    }

                    if let gameCharacter = gameCharacter {
                        if gameChar != nil {
                            return .failure(GridError.MoreThanOneGameCharacter(Position(x, y)))
                        }

                        gameChar = gameCharacter
                    }

                    cells.append(cell)
                }
                grid.append(cells)
            }

            guard let gameCharacter = gameChar else {
                return .failure(GridError.NoGameCharacter)
            }

            return .success(Grid(grid, gameCharacter))
        }

        func toString() -> String {
            var result = ""
            for line in grid {
                for cell in line {
                    if cell.position == gameCharacter.position {
                        result += gameCharacter.toString()
                        continue
                    }
                    result += cell.toString()
                }
                result += "\n"
            }
            return result
        }

        func peek(_ position: Position) -> CellType {
            guard let cell = grid[safe: position.y]?[safe: position.x] else {
                return .UnmappedArea
            }
            return cell.cellType
        }

        func getCell(_ position: Position) -> Cell? {
            return grid[safe: position.y]?[safe: position.x]
        }

        func move() {
            let nextPosition = gameCharacter.peek()
            guard let cell = getCell(nextPosition) else {
                gameCharacter.position = Position(-1, -1)
                return
            }

            cell.visit()
            gameCharacter.position = nextPosition
        }

        func turnRight() {
            switch gameCharacter.direction {
            case .North:
                gameCharacter.direction = .East
            case .East:
                gameCharacter.direction = .South
            case .South:
                gameCharacter.direction = .West
            case .West:
                gameCharacter.direction = .North
            }
        }

        func play() -> Bool {
            while true {
                let state =
                    "\(gameCharacter.position.x),\(gameCharacter.position.y),\(gameCharacter.direction)"
                if visitedStates.contains(state) {
                    return true  // Loop detected
                }
                visitedStates.insert(state)

                let nextPosition = gameCharacter.peek()
                let nextCellType = peek(nextPosition)

                switch nextCellType {
                case .Obstruction:
                    turnRight()
                case .Path:
                    move()
                default:
                    move()
                    return false
                }
            }
        }

        func countDistinctVisitedCells() -> Int {
            var count = 0
            for line in grid {
                for cell in line {
                    if cell.visited > 0 {
                        count += 1
                    }
                }
            }
            return count
        }

        func findWhereObstaclesCreateLoop() -> Int {
            var positions: [Position] = []
            for line in grid {
                for cell in line {
                    if cell.position == startPosition {
                        continue
                    }

                    if cell.cellType != .Path {
                        continue
                    }

                    var newLine = grid[cell.position.y].map { $0 }
                    newLine[cell.position.x] = Cell(.Obstruction, cell.position, 0)
                    var newGridMatrix = grid.map { $0 }
                    newGridMatrix[cell.position.y] = newLine
                    let newGameCharacter = GameCharacter(startDirection, startPosition)
                    let newGrid = Grid(newGridMatrix, newGameCharacter)
                    let isLoop = newGrid.play()
                    if isLoop {
                        positions.append(cell.position)
                    }
                }
            }

            return positions.count
        }
    }

    public static func runPart1(_ input: String) -> Result<Int, GridError> {
        let gridResult = Grid.parse(input)
        if case let .failure(error) = gridResult {
            return .failure(error)
        }

        let grid = try! gridResult.get()
        let isLoop = grid.play()
        if isLoop {
            return .failure(GridError.GridLoop)
        }
        return .success(grid.countDistinctVisitedCells())
    }

    public static func runPart2(_ input: String) -> Result<Int, GridError> {
        let gridResult = Grid.parse(input)
        if case let .failure(error) = gridResult {
            return .failure(error)
        }

        let grid = try! gridResult.get()
        let locationsWhereObstaclesCreateLoop = grid.findWhereObstaclesCreateLoop()

        return .success(locationsWhereObstaclesCreateLoop)
    }
}
