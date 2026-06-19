import SwiftUI

struct ComposerJourneyView: View {
    @StateObject private var player = ThemePlayer()
    @AppStorage("app.language") private var languageRawValue = AppLanguage.simplifiedChinese.rawValue
    @State private var composerIndex = 0
    private var composer: Composer { Composer.catalog[composerIndex] }
    private var language: AppLanguage {
        AppLanguage(rawValue: languageRawValue) ?? .simplifiedChinese
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PortraitBackgroundView(composer: composer)

                ScrollView {
                    VStack(spacing: 0) {
                        ComposerHeaderView(composer: composer, language: language)

                        RhythmGameView(
                            composer: composer,
                            language: language
                        )

                        ReflectionNoteView(composer: composer, language: language)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 40)
                    .onEnded { value in
                        if value.translation.width < -60 {
                            moveComposer(by: 1)
                        } else if value.translation.width > 60 {
                            moveComposer(by: -1)
                        }
                    }
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(player.isPlaying ? localized("Pause", "暂停") : localized("Play", "播放")) {
                        player.isPlaying ? player.stop() : player.play(theme: composer.theme)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(localized("Composer", "音乐家")) {
                        ForEach(Array(Composer.catalog.enumerated()), id: \.element.id) { index, item in
                            Button(item.name.text(for: language)) {
                                composerIndex = index
                                player.play(theme: item.theme)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(language.displayName) {
                        ForEach(AppLanguage.allCases) { item in
                            Button(item.displayName) {
                                languageRawValue = item.rawValue
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

    private func moveComposer(by offset: Int) {
        let count = Composer.catalog.count
        composerIndex = (composerIndex + offset + count) % count
        player.play(theme: composer.theme)
    }

    private func localized(_ english: String, _ simplifiedChinese: String) -> String {
        language == .english ? english : simplifiedChinese
    }
}

private struct PortraitBackgroundView: View {
    let composer: Composer

    var body: some View {
        ZStack {
            if let portraitAssetName = composer.portraitAssetName {
                Image(portraitAssetName)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 22)
                    .scaleEffect(1.12)
                    .opacity(0.58)
            } else {
                LinearGradient(
                    colors: [
                        composer.color.opacity(0.58),
                        Color(red: 0.98, green: 0.95, blue: 0.86),
                        composer.color.opacity(0.22)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }

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
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                HStack(alignment: .center, spacing: 14) {
                    ComposerPortraitView(composer: composer)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(composer.name.text(for: language))
                            .font(.title2.weight(.bold))
                        Text("\(composer.years) - \(composer.country.text(for: language))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Text(composer.famousWork.text(for: language))
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(composer.color.opacity(0.12))
                    .clipShape(Capsule())
            }

            Text(composer.introduction.text(for: language))
                .font(.body)
                .foregroundStyle(.primary)

            Text(composer.inspiration.text(for: language))
                .font(.system(size: 30, weight: .heavy, design: .serif))
                .italic()
                .lineSpacing(6)
                .foregroundStyle(
                    LinearGradient(
                        colors: [composer.color, .primary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.white.opacity(0.58))
                        RoundedRectangle(cornerRadius: 8)
                            .fill(composer.color.opacity(0.10))
                    }
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

private struct ReflectionNoteView: View {
    let composer: Composer
    let language: AppLanguage
    @AppStorage private var note: String

    init(composer: Composer, language: AppLanguage) {
        self.composer = composer
        self.language = language
        _note = AppStorage(wrappedValue: "", "reflection.\(composer.id)")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localized("What did this music bring to mind?", "听到这段音乐，你想到了什么？"))
                .font(.headline)

            TextEditor(text: $note)
                .frame(minHeight: 108)
                .padding(10)
                .scrollContentBackground(.hidden)
                .background(.white.opacity(0.66))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(composer.color.opacity(0.22), lineWidth: 1)
                }
                .overlay(alignment: .topLeading) {
                    if note.isEmpty {
                        Text(localized("Write a feeling, image, memory, or color...", "写下一个画面、回忆、颜色或心情..."))
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }
                }
        }
        .padding(20)
        .background(.ultraThinMaterial)
    }

    private func localized(_ english: String, _ simplifiedChinese: String) -> String {
        language == .english ? english : simplifiedChinese
    }
}

private struct ComposerPortraitView: View {
    let composer: Composer

    var body: some View {
        Group {
            if let portraitAssetName = composer.portraitAssetName {
                Image(portraitAssetName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(
                        colors: [composer.color, composer.color.opacity(0.58)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    Text(initials)
                        .font(.system(size: 24, weight: .heavy, design: .serif))
                        .foregroundStyle(.white)
                }
            }
        }
        .frame(width: 78, height: 78)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.78), lineWidth: 2)
        }
        .shadow(color: composer.color.opacity(0.32), radius: 10, y: 4)
        .accessibilityLabel(Text(composer.name.english))
    }

    private var initials: String {
        composer.name.english
            .split(separator: " ")
            .compactMap(\.first)
            .prefix(2)
            .map(String.init)
            .joined()
    }
}
