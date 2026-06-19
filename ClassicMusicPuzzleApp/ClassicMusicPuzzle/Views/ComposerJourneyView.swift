import SwiftUI

struct ComposerJourneyView: View {
    @StateObject private var player = ThemePlayer()
    @State private var composerIndex = 0
    @State private var level = 0
    private var composer: Composer { Composer.catalog[composerIndex] }

    var body: some View {
        NavigationStack {
            ZStack {
                PortraitBackgroundView(composer: composer)

                VStack(spacing: 0) {
                    ComposerHeaderView(composer: composer)

                    RhythmGameView(
                        composer: composer,
                        level: level + 1,
                        onReplay: replay,
                        onNext: nextLevel
                    )
                }
            }
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
        level = max(0, level)
    }

    private func nextLevel() {
        if level < 2 {
            level += 1
        } else {
            level = 0
            composerIndex = (composerIndex + 1) % Composer.catalog.count
            player.play(theme: composer.theme)
        }
    }
}

private struct PortraitBackgroundView: View {
    let composer: Composer

    var body: some View {
        ZStack {
            Image(composer.portraitAssetName)
                .resizable()
                .scaledToFill()
                .blur(radius: 22)
                .scaleEffect(1.12)
                .opacity(0.58)

            LinearGradient(
                colors: [
                    Color(red: 0.98, green: 0.97, blue: 0.94).opacity(0.88),
                    composer.color.opacity(0.32),
                    Color(red: 0.10, green: 0.11, blue: 0.13).opacity(0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            Color(red: 0.98, green: 0.97, blue: 0.94).opacity(0.36)
        }
        .ignoresSafeArea()
    }
}

private struct ComposerHeaderView: View {
    let composer: Composer

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                HStack(alignment: .center, spacing: 14) {
                    ComposerPortraitView(composer: composer)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(composer.name)
                            .font(.title2.weight(.bold))
                        Text("\(composer.years) - \(composer.country)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
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
                .font(.system(size: 24, weight: .bold, design: .serif))
                .lineSpacing(4)
                .foregroundStyle(.primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(composer.color.opacity(0.14))
                )
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(composer.color)
                        .frame(width: 4)
                        .clipShape(Capsule())
                        .padding(.vertical, 10)
                }
                .padding(.top, 6)
        }
        .padding(20)
        .background(.ultraThinMaterial)
    }
}

private struct ComposerPortraitView: View {
    let composer: Composer

    var body: some View {
        Image(composer.portraitAssetName)
            .resizable()
            .scaledToFill()
            .frame(width: 78, height: 78)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(0.78), lineWidth: 2)
            }
            .shadow(color: composer.color.opacity(0.32), radius: 10, y: 4)
            .accessibilityLabel(Text("\(composer.name) portrait"))
    }
}
