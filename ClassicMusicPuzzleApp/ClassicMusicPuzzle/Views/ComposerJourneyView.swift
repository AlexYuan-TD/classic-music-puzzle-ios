import SwiftUI

struct ComposerJourneyView: View {
    @StateObject private var player = ThemePlayer()
    @State private var composerIndex = 0
    @State private var level = 0
    @State private var board = PuzzleBoard(size: 3)

    private let sizes = [3, 4, 5]
    private var composer: Composer { Composer.catalog[composerIndex] }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ComposerHeaderView(composer: composer)

                PuzzleGameView(
                    composer: composer,
                    level: level + 1,
                    board: $board,
                    onReplay: replay,
                    onNext: nextLevel
                )
            }
            .background(Color(red: 0.98, green: 0.97, blue: 0.94))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(player.isPlaying ? "Pause" : "Play") {
                        player.isPlaying ? player.stop() : player.play(theme: composer.theme)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Composer") {
                        ForEach(Array(Composer.catalog.enumerated()), id: \.element.id) { index, item in
                            Button(item.name) {
                                composerIndex = index
                                replay()
                                player.play(theme: item.theme)
                            }
                        }
                    }
                }
            }
            .onAppear {
                player.play(theme: composer.theme)
            }
            .onChange(of: composerIndex) { _, _ in
                player.play(theme: composer.theme)
            }
        }
    }

    private func replay() {
        board = PuzzleBoard(size: sizes[level])
    }

    private func nextLevel() {
        if level < sizes.count - 1 {
            level += 1
        } else {
            level = 0
            composerIndex = (composerIndex + 1) % Composer.catalog.count
            player.play(theme: composer.theme)
        }
        board = PuzzleBoard(size: sizes[level])
    }
}

private struct ComposerHeaderView: View {
    let composer: Composer

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(composer.name)
                        .font(.title2.weight(.bold))
                    Text("\(composer.years) - \(composer.country)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(composer.famousWork)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(composer.color.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(composer.introduction)
                .font(.body)
                .foregroundStyle(.primary)

            Text(composer.inspiration)
                .font(.callout.weight(.semibold))
                .foregroundStyle(composer.color)
                .padding(.top, 2)
        }
        .padding(20)
    }
}

