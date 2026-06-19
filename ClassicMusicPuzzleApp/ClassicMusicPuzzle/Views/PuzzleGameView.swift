import SwiftUI

struct PuzzleGameView: View {
    let composer: Composer
    let level: Int
    @Binding var board: PuzzleBoard
    let onReplay: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Level \(level) - \(board.size)x\(board.size)")
                    .font(.headline)
                Spacer()
                Text(board.isSolved ? "Complete" : "Arrange the portrait")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            GeometryReader { proxy in
                let gap: CGFloat = 5
                let tileSize = (proxy.size.width - gap * CGFloat(board.size - 1)) / CGFloat(board.size)

                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(composer.color.opacity(0.10))

                    ForEach(board.tiles) { tile in
                        TileView(tile: tile, size: board.size, composer: composer)
                            .frame(width: tileSize, height: tileSize)
                            .position(position(for: tile.currentIndex, tileSize: tileSize, gap: gap))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                    board.move(tile: tile)
                                }
                            }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)

            if board.isSolved {
                CompletionBar(onStay: {}, onReplay: onReplay, onNext: onNext)
            } else {
                Text("Listen to \(composer.theme.title) while you solve the puzzle.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(20)
    }

    private func position(for index: Int, tileSize: CGFloat, gap: CGFloat) -> CGPoint {
        let row = index / board.size
        let col = index % board.size
        return CGPoint(
            x: CGFloat(col) * (tileSize + gap) + tileSize / 2,
            y: CGFloat(row) * (tileSize + gap) + tileSize / 2
        )
    }
}

private struct TileView: View {
    let tile: PuzzleTile
    let size: Int
    let composer: Composer

    var body: some View {
        if tile.isBlank {
            RoundedRectangle(cornerRadius: 6)
                .fill(.clear)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(tileGradient)
                    .shadow(color: .black.opacity(0.08), radius: 3, y: 2)

                VStack(spacing: 4) {
                    Text(initials)
                        .font(.system(size: size == 3 ? 28 : 20, weight: .bold, design: .serif))
                    Text("\(tile.correctIndex + 1)")
                        .font(.caption2.weight(.bold))
                }
                .foregroundStyle(.white)
            }
        }
    }

    private var initials: String {
        composer.name
            .split(separator: " ")
            .compactMap(\.first)
            .map(String.init)
            .joined()
    }

    private var tileGradient: LinearGradient {
        LinearGradient(
            colors: [composer.color, composer.color.opacity(0.68)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct CompletionBar: View {
    let onStay: () -> Void
    let onReplay: () -> Void
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text("Beautifully done. Stay with the music, replay, or continue.")
                .font(.callout.weight(.medium))
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Button("Stay", action: onStay)
                    .buttonStyle(.bordered)
                Button("Replay", action: onReplay)
                    .buttonStyle(.bordered)
                Button("Next Level", action: onNext)
                    .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

