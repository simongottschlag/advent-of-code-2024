public class day08Part1 {
    enum PointType: Equatable {
        case Antenna(Character)
        case AntiNode(Point, Point)
        case Empty

        static func == (lhs: PointType, rhs: PointType) -> Bool {
            switch (lhs, rhs) {
            case (let .Antenna(lhsChar), let .Antenna(rhsChar)):
                return lhsChar == rhsChar
            case (let .AntiNode(lhsA, lhsB), let .AntiNode(rhsA, rhsB)):
                return lhsA == rhsA && lhsB == rhsB
            case (.Empty, .Empty):
                return true
            default:
                return false
            }
        }

        static func ~= (lhs: PointType, rhs: PointType) -> Bool {
            switch (lhs, rhs) {
            case (.Antenna(_), .Antenna(_)):
                return true
            case (.AntiNode(_, _), .AntiNode(_, _)):
                return true
            case (.Empty, .Empty):
                return true
            default:
                return false
            }
        }
    }

    enum PointAlignmentType {
        case Horizontal
        case Vertical
        case Diagonal
    }

    enum PointAlignment: Equatable {
        case Aligned(PointAlignmentType)
        case NotAligned

        static func == (lhs: PointAlignment, rhs: PointAlignment) -> Bool {
            switch (lhs, rhs) {
            case (let .Aligned(lhs), let .Aligned(rhs)):
                return lhs == rhs
            case (.NotAligned, .NotAligned):
                return true
            default:
                return false
            }
        }

        static func ~= (lhs: PointAlignment, rhs: PointAlignment) -> Bool {
            switch (lhs, rhs) {
            case (.Aligned(_), .Aligned(_)):
                return true
            case (.NotAligned, .NotAligned):
                return true
            default:
                return false
            }
        }
    }

    class Point {
        let position: Position
        let pointType: PointType

        init(_ position: Position, _ pointType: PointType) {
            self.position = position
            self.pointType = pointType
        }

        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.position == rhs.position && lhs.pointType == rhs.pointType
        }

        func aligned(_ rhs: Point) -> PointAlignment {
            if self == rhs {
                return .NotAligned
            }

            switch (lhs: self, rhs: rhs) {
            case (let lhs, let rhs) where lhs.position.x == rhs.position.x:
                return .Aligned(.Vertical)
            case (let lhs, let rhs) where lhs.position.y == rhs.position.y:
                return .Aligned(.Horizontal)
            case (let lhs, let rhs)
            where abs(lhs.position.x - rhs.position.x) == abs(lhs.position.y - rhs.position.y):
                return .Aligned(.Diagonal)
            default:
                return .NotAligned
            }
        }

        func antiNode(_ input: Point) -> AntiNodePoint {
            let x = (2 * input.position.x) - self.position.x
            let y = (2 * input.position.y) - self.position.y

            return AntiNodePoint(Position(x, y), self, input)
        }
    }

    class AntiNodePoint: Hashable {
        let position: Position
        let lhsValue: Point
        let rhsValue: Point

        init(_ position: Position, _ lhs: Point, _ rhs: Point) {
            self.position = position
            self.lhsValue = lhs
            self.rhsValue = rhs
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(position.x)
            hasher.combine(position.y)
        }

        static func == (lhs: AntiNodePoint, rhs: AntiNodePoint) -> Bool {
            return lhs.position == rhs.position
        }
    }

    class Grid {
        var grid: [[Point]]

        init(_ grid: [[Point]]) {
            self.grid = grid
        }

        func points() -> [Point] {
            return grid.flatMap { $0.map { $0 } }
        }

        func inGrid(_ position: Position) -> Bool {
            return position.y >= 0 && position.y < grid.count && position.x >= 0
                && position.x < grid[position.y].count
        }

        func findAntiNodesForPoint(_ lhs: Point) -> Set<AntiNodePoint>? {
            guard case let .Antenna(lhsPointType) = lhs.pointType else {
                return nil
            }

            var antiNodes: Set<AntiNodePoint> = []
            for rhs in points() {
                guard case let .Antenna(rhsPointType) = rhs.pointType else {
                    continue
                }

                if lhs == rhs {
                    continue
                }

                if lhsPointType != rhsPointType {
                    continue
                }

                let antiNode = lhs.antiNode(rhs)
                guard inGrid(antiNode.position) else {
                    continue
                }

                antiNodes.insert(antiNode)
            }

            if antiNodes.isEmpty {
                return nil
            }

            return antiNodes
        }

        func findAntiNodes() -> Set<AntiNodePoint> {
            var antiNodes: Set<AntiNodePoint> = []
            for point in points() {
                guard case .Antenna = point.pointType else {
                    continue
                }

                guard let alignedAntiNodes = findAntiNodesForPoint(point) else {
                    continue
                }

                for antiNode in alignedAntiNodes {
                    antiNodes.insert(antiNode)
                }
            }

            return antiNodes
        }
    }

    static func parseLine(_ line: String.SubSequence, _ y: Int) -> Result<[Point], dayError> {
        let points = line.enumerated().map { (x, point) in
            switch point {
            case ".":
                return Point(Position(x, y), .Empty)
            default:
                return Point(Position(x, y), .Antenna(point))
            }
        }
        return .success(points)
    }

    static func parseInput(_ input: String) -> Result<Grid, dayError> {
        var grid: [[Point]] = []
        for (y, line) in input.lines.enumerated() {
            let lineResult = parseLine(line, y)
            if case let .failure(error) = lineResult {
                return .failure(error)
            }
            let line = try! lineResult.get()
            grid.append(line)
        }
        return .success(Grid(grid))
    }

    public static func run(_ input: String) -> Result<Int, dayError> {
        let gridResult = parseInput(input)
        if case let .failure(error) = gridResult {
            return .failure(error)
        }
        let grid = try! gridResult.get()

        let antiNodes = grid.findAntiNodes()
        return .success(antiNodes.count)
    }
}

public class day08Part2 {
    enum PointType: Equatable, Hashable {
        case Antenna(Character)
        case Empty

        static func == (lhs: PointType, rhs: PointType) -> Bool {
            switch (lhs, rhs) {
            case (let .Antenna(lhsChar), let .Antenna(rhsChar)):
                return lhsChar == rhsChar
            case (.Empty, .Empty):
                return true
            default:
                return false
            }
        }

        static func ~= (lhs: PointType, rhs: PointType) -> Bool {
            switch (lhs, rhs) {
            case (.Antenna(_), .Antenna(_)):
                return true
            case (.Empty, .Empty):
                return true
            default:
                return false
            }
        }

        func hash(into hasher: inout Hasher) {
            switch self {
            case let .Antenna(char):
                hasher.combine(char)
            case .Empty:
                hasher.combine(0)
            }
        }
    }

    class Point {
        let position: Position
        let pointType: PointType

        init(_ position: Position, _ pointType: PointType) {
            self.position = position
            self.pointType = pointType
        }

        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.position == rhs.position && lhs.pointType == rhs.pointType
        }
    }

    class Grid {
        var grid: [[Point]]

        init(_ grid: [[Point]]) {
            self.grid = grid
        }

        func inGrid(_ position: Position) -> Bool {
            return grid[safe: position.y]?[safe: position.x] != nil
        }

        func points() -> [Point] {
            return grid.flatMap { $0.map { $0 } }
        }

        func pointsMap() -> [PointType: [Point]] {
            return Dictionary(grouping: points(), by: { $0.pointType })
        }

        func generateCombinations(_ points: [Point]) -> [(Point, Point)] {
            var pairs: [(Point, Point)] = []
            for (index, lhs) in points.enumerated() {
                for rhs in points.suffix(from: index + 1) {
                    pairs.append((lhs, rhs))
                }
            }
            return pairs
        }

        func walkLineForward(_ lhs: Point, stepX: Int, stepY: Int) -> Set<Position> {
            var positions: Set<Position> = []
            var position = lhs.position
            while inGrid(position) {
                positions.insert(position)
                position = Position(position.x + stepX, position.y + stepY)
            }
            return positions
        }

        func walkLineBackward(_ lhs: Point, stepX: Int, stepY: Int) -> Set<Position> {
            var positions: Set<Position> = []
            var position = lhs.position
            while inGrid(position) {
                positions.insert(position)
                position = Position(position.x - stepX, position.y - stepY)
            }
            return positions
        }

        func walkLine(_ lhs: Point, _ rhs: Point) -> Set<Position> {
            let dx = rhs.position.x - lhs.position.x
            let dy = rhs.position.y - lhs.position.y
            let g = greatestCommonDivisor(dx, dy)
            let stepX = dx / g
            let stepY = dy / g

            var positions: Set<Position> = [lhs.position, rhs.position]

            for forwardPosition in walkLineForward(lhs, stepX: stepX, stepY: stepY) {
                if inGrid(forwardPosition) {
                    positions.insert(forwardPosition)
                }
            }

            for backwardPosition in walkLineBackward(lhs, stepX: stepX, stepY: stepY) {
                if inGrid(backwardPosition) {
                    positions.insert(backwardPosition)
                }
            }

            return positions

        }

        func walkPointType(_ pointType: PointType) -> Set<Position> {
            let points = pointsMap().filter { $0.key == pointType }.values.first ?? []
            if points.count < 2 {
                return []
            }

            var positions: Set<Position> = []
            for (lhs, rhs) in generateCombinations(points) {
                for position in walkLine(lhs, rhs) {
                    positions.insert(position)
                }
            }

            return positions
        }

        func findAntiNodes() -> Set<Position> {
            var positions: Set<Position> = []
            for (pointType, _) in pointsMap() {
                if case .Antenna = pointType {
                    let pointTypePositions = walkPointType(pointType)
                    for position in pointTypePositions {
                        if inGrid(position) {
                            positions.insert(position)
                        }
                    }
                }
            }

            return positions
        }
    }

    static func parseLine(_ line: String.SubSequence, _ y: Int) -> Result<[Point], dayError> {
        let points = line.enumerated().map { (x, point) in
            switch point {
            case ".":
                return Point(Position(x, y), .Empty)
            default:
                return Point(Position(x, y), .Antenna(point))
            }
        }
        return .success(points)
    }

    static func parseInput(_ input: String) -> Result<Grid, dayError> {
        var grid: [[Point]] = []
        for (y, line) in input.lines.enumerated() {
            let lineResult = parseLine(line, y)
            if case let .failure(error) = lineResult {
                return .failure(error)
            }
            let line = try! lineResult.get()
            grid.append(line)
        }
        return .success(Grid(grid))
    }

    public static func run(_ input: String) -> Result<Int, dayError> {
        let gridResult = parseInput(input)
        if case let .failure(error) = gridResult {
            return .failure(error)
        }
        let grid = try! gridResult.get()

        let antiNodes = grid.findAntiNodes()
        return .success(antiNodes.count)
    }
}
