import SwiftGraph

public class day10 {
    class Point: Equatable, Encodable, Decodable, Hashable {
        let value: Int
        let position: Position

        init(_ value: Int, _ position: Position) {
            self.value = value
            self.position = position
        }

        public static func == (_ lhs: Point, _ rhs: Point) -> Bool {
            return lhs.value == rhs.value && lhs.position == rhs.position
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(value)
            hasher.combine(position)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(value, forKey: .value)
            try container.encode(position, forKey: .position)
        }
    }

    enum Direction: CaseIterable {
        case Up
        case Down
        case Left
        case Right

        func move(_ position: Position) -> Position {
            switch self {
            case .Up:
                return Position(position.x, position.y - 1)
            case .Down:
                return Position(position.x, position.y + 1)
            case .Left:
                return Position(position.x - 1, position.y)
            case .Right:
                return Position(position.x + 1, position.y)
            }
        }
    }

    public enum MapError: Error {
        case NotAnInteger(Position)
    }

    class Map {
        let grid: [[Point]]

        init(_ grid: [[Point]]) {
            self.grid = grid
        }

        static func parse(_ input: String) -> Result<Map, MapError> {
            var grid: [[Point]] = []
            for (y, lineStr) in input.lines.enumerated() {
                var points: [Point] = []
                for (x, char) in lineStr.enumerated() {
                    guard let value = char.wholeNumberValue else {
                        return .failure(.NotAnInteger(Position(x, y)))
                    }
                    points.append(Point(value, Position(x, y)))
                }
                grid.append(points)
            }

            return .success(Map(grid))
        }

        func inGrid(_ position: Position) -> Bool {
            return position.x >= 0 && position.y >= 0 && position.x < grid[0].count
                && position.y < grid.count
        }

        func findNeighbors(_ point: Point) -> [Point] {
            var neighbors: [Point] = []
            for direction in Direction.allCases {
                let position = direction.move(point.position)
                if !inGrid(position) {
                    continue
                }
                neighbors.append(grid[position.y][position.x])
            }
            return neighbors
        }

        func buildGraph() -> UnweightedGraph<Point> {
            let graph = UnweightedGraph<Point>()

            _ = grid.map { $0.map { _ = graph.addVertex($0) } }
            _ = grid.map {
                $0.map { point in
                    findNeighbors(point).filter {
                        $0.value == point.value + 1
                    }.map { graph.addEdge(from: point, to: $0, directed: true) }
                }
            }

            return graph
        }

        func findTrails() -> [Point: Int] {
            let graph = buildGraph()
            let trailHeads = graph.filter({ $0.value == 0 })
            var trails: [Point: Int] = [:]
            for trailHead in trailHeads {
                let paths = graph.findAllDfs(from: trailHead, goalTest: { $0.value == 9 })
                trails[trailHead] = paths.count
            }
            return trails
        }

        func findTrailsPart2() -> [Point: Int] {
            let graph = buildGraph()
            var memo: [Point: Int] = [:]

            func distinctPaths(from point: Point) -> Int {
                if point.value == 9 {
                    return 1
                }

                if let cached = memo[point] {
                    return cached
                }

                var ways = 0
                guard let edges = graph.edgesForVertex(point) else {
                    return 0
                }

                for edge in edges {
                    let successor = graph.vertexAtIndex(edge.v)
                    if successor.value == point.value + 1 {
                        ways += distinctPaths(from: successor)
                    }
                }

                memo[point] = ways
                return ways
            }

            let trailHeads = graph.filter({ $0.value == 0 })
            var trails: [Point: Int] = [:]
            for trailHead in trailHeads {
                let pathsCount = distinctPaths(from: trailHead)
                trails[trailHead] = pathsCount
            }

            return trails
        }
    }

    public static func runPart1(_ input: String) -> Result<Int, MapError> {
        let mapResult = Map.parse(input)
        if case let .failure(error) = mapResult {
            return .failure(error)
        }
        let map = try! mapResult.get()
        let trailScores = map.findTrails().reduce(0) { $0 + $1.value }
        return .success(trailScores)
    }

    public static func runPart2(_ input: String) -> Result<Int, MapError> {
        let mapResult = Map.parse(input)
        if case let .failure(error) = mapResult {
            return .failure(error)
        }
        let map = try! mapResult.get()
        let trailScores = map.findTrailsPart2().reduce(0) { $0 + $1.value }
        return .success(trailScores)
    }
}
