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
                let trail = graph.findAllDfs(from: trailHead, goalTest: { $0.value == 9 }).flatMap {
                    $0
                }
                let foundTrails = graph.edgesToVertices(edges: trail).filter { $0.value == 9 }.count
                trails[trailHead] = foundTrails
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
}
