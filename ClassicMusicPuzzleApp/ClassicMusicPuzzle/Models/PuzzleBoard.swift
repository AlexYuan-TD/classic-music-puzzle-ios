import Foundation

struct PuzzleTile: Identifiable, Equatable {
    let id: Int
    let correctIndex: Int
    var currentIndex: Int
    let isBlank: Bool
}

struct PuzzleBoard: Equatable {
    private(set) var size: Int
    private(set) var tiles: [PuzzleTile]

    var isSolved: Bool {
        tiles.allSatisfy { $0.correctIndex == $0.currentIndex }
    }

    init(size: Int) {
        self.size = size
        self.tiles = (0..<(size * size)).map { index in
            PuzzleTile(
                id: index,
                correctIndex: index,
                currentIndex: index,
                isBlank: index == size * size - 1
            )
        }
        shuffle()
    }

    mutating func reset() {
        tiles = tiles.map {
            PuzzleTile(id: $0.id, correctIndex: $0.correctIndex, currentIndex: $0.correctIndex, isBlank: $0.isBlank)
        }
        shuffle()
    }

    mutating func move(tile: PuzzleTile) {
        guard let tilePosition = tiles.firstIndex(where: { $0.id == tile.id }),
              let blankPosition = tiles.firstIndex(where: { $0.isBlank }) else { return }

        let selectedIndex = tiles[tilePosition].currentIndex
        let blankIndex = tiles[blankPosition].currentIndex
        guard areAdjacent(selectedIndex, blankIndex) else { return }

        tiles[tilePosition].currentIndex = blankIndex
        tiles[blankPosition].currentIndex = selectedIndex
        tiles.sort { $0.currentIndex < $1.currentIndex }
    }

    private mutating func shuffle() {
        let totalMoves = size * size * 24
        for _ in 0..<totalMoves {
            guard let blank = tiles.first(where: { $0.isBlank }) else { continue }
            let choices = tiles.filter { !$0.isBlank && areAdjacent($0.currentIndex, blank.currentIndex) }
            if let choice = choices.randomElement() {
                move(tile: choice)
            }
        }

        if isSolved, let first = tiles.first(where: { !$0.isBlank && areAdjacent($0.currentIndex, size * size - 1) }) {
            move(tile: first)
        }
    }

    private func areAdjacent(_ lhs: Int, _ rhs: Int) -> Bool {
        let left = (row: lhs / size, col: lhs % size)
        let right = (row: rhs / size, col: rhs % size)
        return abs(left.row - right.row) + abs(left.col - right.col) == 1
    }
}

