import SwiftUI

struct ComposerJourneyView: View {
    @StateObject private var player = ThemePlayer()
    @AppStorage("app.language") private var languageRawValue = AppLanguage.simplifiedChinese.rawValue
    @State private var composerIndex = 0
    @State private var isAssistantPresented = false
    @State private var reflections: [ListenerReflection] = []

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
                        ArtQuoteView(composer: composer, language: language)
                        ImmersivePoemView(composer: composer, language: language)
                        ListenerReflectionView(composer: composer, language: language, reflections: $reflections)
                        AboutJamesView(composer: composer, language: language)
                    }
                    .frame(maxWidth: .infinity)
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ComposerAssistantButton(composer: composer, language: language) {
                            isAssistantPresented = true
                        }
                    }
                    .padding(.trailing, 18)
                    .padding(.bottom, 22)
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
            .sheet(isPresented: $isAssistantPresented) {
                ComposerAssistantSheet(composer: composer, language: language)
                    .presentationDetents([.medium, .large])
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

private struct ComposerAssistantButton: View {
    let composer: Composer
    let language: AppLanguage
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ComposerAssistantMascot(composer: composer, size: 42)

                VStack(alignment: .leading, spacing: 2) {
                    Text(language == .english ? "Ask Maestro" : "问问 Maestro")
                        .font(.caption.weight(.heavy))
                    Text(language == .english ? composer.name.english : "当前音乐家")
                        .font(.caption2.weight(.semibold))
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(composer.color.opacity(0.28), lineWidth: 1)
            }
            .shadow(color: composer.color.opacity(0.22), radius: 14, y: 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(language == .english ? "Open composer assistant" : "打开音乐家助手"))
    }
}

private struct ComposerAssistantMascot: View {
    let composer: Composer
    var size: CGFloat = 54

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [composer.color, composer.color.opacity(0.52)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: size * 0.72, height: size * 0.72)
                .offset(x: -size * 0.12, y: -size * 0.14)

            Image(systemName: "music.note")
                .font(.system(size: size * 0.40, weight: .black))
                .foregroundStyle(.white)
                .offset(y: -size * 0.04)

            Image(systemName: "person.fill")
                .font(.system(size: size * 0.26, weight: .bold))
                .foregroundStyle(.white.opacity(0.88))
                .offset(y: size * 0.18)
        }
        .frame(width: size, height: size)
        .overlay {
            Circle()
                .stroke(.white.opacity(0.78), lineWidth: 2)
        }
    }
}

private struct ComposerAssistantSheet: View {
    let composer: Composer
    let language: AppLanguage
    @State private var draft = ""
    @State private var messages: [AssistantChatMessage] = []

    var body: some View {
        NavigationStack {
            ZStack {
                PortraitBackgroundView(composer: composer)

                VStack(spacing: 0) {
                    VStack(spacing: 10) {
                        ComposerAssistantMascot(composer: composer, size: 62)

                        Text(title)
                            .font(.system(size: 24, weight: .black, design: .serif))
                            .multilineTextAlignment(.center)

                        Text(subtitle)
                            .font(.footnote)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 14)

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(activeMessages) { message in
                                AssistantMessageBubble(message: message, composer: composer)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }

                    HStack(spacing: 10) {
                        TextField(inputPlaceholder, text: $draft, axis: .vertical)
                            .textFieldStyle(.plain)
                            .lineLimit(1...3)
                            .padding(12)
                            .background(.white.opacity(0.45))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(composer.color.opacity(0.18), lineWidth: 1)
                            }

                        Button(language == .english ? "Send" : "发送") {
                            send()
                        }
                        .font(.footnote.weight(.bold))
                        .buttonStyle(.borderedProminent)
                        .tint(composer.color)
                        .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                }
            }
            .navigationTitle(language == .english ? "Composer Chat" : "音乐家对话")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if messages.isEmpty {
                    messages = [welcomeMessage]
                }
            }
        }
    }

    private var activeMessages: [AssistantChatMessage] {
        messages.isEmpty ? [welcomeMessage] : messages
    }

    private var title: String {
        language == .english ? "Maestro speaks for \(composer.name.english)" : "Maestro 代表\(composer.name.simplifiedChinese)与你对话"
    }

    private var subtitle: String {
        language == .english
            ? "Ask about the music, the composer, or what to listen for in this moment."
            : "可以问这段音乐、这位音乐家，或现在应该听见什么。"
    }

    private var inputPlaceholder: String {
        language == .english ? "What would you like to ask?" : "你想问这位音乐家什么？"
    }

    private var welcomeMessage: AssistantChatMessage {
        AssistantChatMessage(
            isUser: false,
            text: language == .english
                ? "I am listening with you. Ask me why \(composer.famousWork.english) still feels alive today."
                : "我正在和你一起听。你可以问我：为什么\(composer.famousWork.simplifiedChinese)今天仍然打动人？"
        )
    }

    private func send() {
        let question = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !question.isEmpty else { return }

        messages.append(AssistantChatMessage(isUser: true, text: question))
        messages.append(AssistantChatMessage(isUser: false, text: ComposerAssistant.reply(to: question, composer: composer, language: language)))
        draft = ""
    }
}

private struct AssistantMessageBubble: View {
    let message: AssistantChatMessage
    let composer: Composer

    var body: some View {
        HStack {
            if message.isUser {
                Spacer(minLength: 40)
            }

            Text(message.text)
                .font(.body)
                .lineSpacing(4)
                .padding(13)
                .foregroundStyle(message.isUser ? .white : .primary)
                .background(message.isUser ? composer.color.opacity(0.86) : .white.opacity(0.48))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(message.isUser ? .clear : composer.color.opacity(0.18), lineWidth: 1)
                }

            if !message.isUser {
                Spacer(minLength: 40)
            }
        }
    }
}

private struct AssistantChatMessage: Identifiable, Equatable {
    let id = UUID()
    let isUser: Bool
    let text: String
}

private enum ComposerAssistant {
    static func reply(to question: String, composer: Composer, language: AppLanguage) -> String {
        if language == .english {
            return "If \(composer.name.english) could answer, the first clue might be this: \(composer.inspiration.english) In \(composer.famousWork.english), listen for how a small musical idea becomes a feeling you can carry."
        }

        return "如果\(composer.name.simplifiedChinese)来回答，也许会先说：\(composer.inspiration.simplifiedChinese) 听\(composer.famousWork.simplifiedChinese)时，可以留意一个很小的音乐动机，如何慢慢变成可以带走的情绪。"
    }
}

private struct ListenerReflectionView: View {
    let composer: Composer
    let language: AppLanguage
    @Binding var reflections: [ListenerReflection]
    @State private var draft = ""
    @State private var visibility = ReflectionVisibility.privateOnly

    private var composerReflections: [ListenerReflection] {
        reflections.filter { $0.composerID == composer.id }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(localized("What did the music awaken?", "这段音乐让你想到了什么？"))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(composer.color)

                    Text(localized(
                        "Leave a private note, or mark it public for the future community wall.",
                        "写一段只给自己看的听后感，或标记为公开，未来进入公共留言墙。"
                    ))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }

                Spacer()
            }

            TextField(localized("A memory, an image, a sentence...", "一段记忆、一个画面、一句话……"), text: $draft, axis: .vertical)
                .textFieldStyle(.plain)
                .lineLimit(3...6)
                .padding(14)
                .background(.white.opacity(0.42))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(composer.color.opacity(0.18), lineWidth: 1)
                }

            Picker(localized("Visibility", "可见范围"), selection: $visibility) {
                ForEach(ReflectionVisibility.allCases) { item in
                    Text(item.title(for: language)).tag(item)
                }
            }
            .pickerStyle(.segmented)

            HStack {
                Text(visibility.description(for: language))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Button(localized("Save", "保存")) {
                    save()
                }
                .font(.footnote.weight(.bold))
                .buttonStyle(.borderedProminent)
                .tint(composer.color)
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if !composerReflections.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text(localized("Your reflections", "你的留言"))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    ForEach(composerReflections) { reflection in
                        ReflectionRow(reflection: reflection, composer: composer, language: language)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [
                    .white.opacity(0.22),
                    composer.color.opacity(0.08),
                    .white.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(classicalLineGradient)
                .frame(height: 1)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(classicalLineGradient)
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 22)
    }

    private func save() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        reflections.insert(
            ListenerReflection(composerID: composer.id, text: text, visibility: visibility),
            at: 0
        )
        draft = ""
    }

    private func localized(_ english: String, _ simplifiedChinese: String) -> String {
        language == .english ? english : simplifiedChinese
    }

    private var classicalLineGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, composer.color.opacity(0.28), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

private struct ReflectionRow: View {
    let reflection: ListenerReflection
    let composer: Composer
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(reflection.visibility.title(for: language))
                    .font(.caption2.weight(.heavy))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .foregroundStyle(reflection.visibility == .publicWall ? composer.color : .secondary)
                    .background(.white.opacity(0.38))
                    .clipShape(Capsule())

                Spacer()
            }

            Text(reflection.text)
                .font(.footnote)
                .lineSpacing(4)
                .foregroundStyle(.primary.opacity(0.9))
        }
        .padding(12)
        .background(.white.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(composer.color.opacity(0.14), lineWidth: 1)
        }
    }
}

private struct ListenerReflection: Identifiable, Equatable {
    let id = UUID()
    let composerID: String
    let text: String
    let visibility: ReflectionVisibility
}

private enum ReflectionVisibility: String, CaseIterable, Identifiable {
    case privateOnly
    case publicWall

    var id: String { rawValue }

    func title(for language: AppLanguage) -> String {
        switch (self, language) {
        case (.privateOnly, .english): return "Only me"
        case (.privateOnly, .simplifiedChinese): return "仅自己可见"
        case (.publicWall, .english): return "Public"
        case (.publicWall, .simplifiedChinese): return "公开"
        }
    }

    func description(for language: AppLanguage) -> String {
        switch (self, language) {
        case (.privateOnly, .english):
            return "Saved on this device."
        case (.privateOnly, .simplifiedChinese):
            return "只保存在本机。"
        case (.publicWall, .english):
            return "Will appear on the public wall after online sync and moderation are enabled."
        case (.publicWall, .simplifiedChinese):
            return "后续接入同步和审核后，可进入公共留言墙。"
        }
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
                    .blur(radius: 24)
                    .scaleEffect(1.14)
                    .opacity(0.62)
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
                    Color(red: 0.98, green: 0.97, blue: 0.94).opacity(0.78),
                    composer.color.opacity(0.26),
                    Color(red: 0.10, green: 0.11, blue: 0.13).opacity(0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            PaperTextureView(accentColor: composer.color)
        }
        .ignoresSafeArea()
    }
}

private struct PaperTextureView: View {
    let accentColor: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<Int(proxy.size.height / 5 + 1), id: \.self) { index in
                    Rectangle()
                        .fill(Color(red: 0.31, green: 0.22, blue: 0.12).opacity(0.045))
                        .frame(height: 1)
                        .offset(y: CGFloat(index * 5))
                }

                Circle()
                    .fill(accentColor.opacity(0.075))
                    .frame(width: 180, height: 180)
                    .blur(radius: 34)
                    .position(x: proxy.size.width * 0.18, y: proxy.size.height * 0.28)

                Circle()
                    .fill(Color(red: 0.36, green: 0.25, blue: 0.12).opacity(0.055))
                    .frame(width: 150, height: 150)
                    .blur(radius: 30)
                    .position(x: proxy.size.width * 0.82, y: proxy.size.height * 0.14)
            }
        }
        .opacity(0.72)
        .allowsHitTesting(false)
    }
}

private struct ComposerHeaderView: View {
    let composer: Composer
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 14) {
                ComposerPortraitView(composer: composer)

                VStack(alignment: .leading, spacing: 4) {
                    Text(composer.name.text(for: language))
                        .font(.title2.weight(.bold))
                    Text("\(composer.years) - \(composer.country.text(for: language))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack {
                Text(composer.famousWork.text(for: language))
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(composer.color.opacity(0.12))
                    .clipShape(Capsule())

                Text(composer.theme.title.text(for: language))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Text(composer.introduction.text(for: language))
                .font(.body)
                .foregroundStyle(.primary)
        }
        .padding(20)
        .background(.white.opacity(0.40))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(classicalLineGradient)
                .frame(height: 1)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(classicalLineGradient)
                .frame(height: 1)
        }
        .background(.ultraThinMaterial)
    }

    private var classicalLineGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, composer.color.opacity(0.24), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

private struct AboutJamesView: View {
    let composer: Composer
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localized("About James Yuan", "关于 James Yuan"))
                .font(.caption.weight(.bold))
                .foregroundStyle(composer.color)

            Text(localized(
                "James Yuan loves classical music and is dedicated to introducing it to more listeners. He also follows music technology closely, believing that thoughtful technology can help more people feel the beauty of classical music.",
                "James Yuan 热爱古典音乐，致力于推广古典音乐，同时关注音乐科技。他相信通过有温度的科技，可以让更多人感受古典音乐的美好。"
            ))
            .font(.footnote)
            .lineSpacing(5)
            .foregroundStyle(.primary.opacity(0.88))

            Link(destination: URL(string: "https://www.jamesyyy.com")!) {
                HStack(spacing: 6) {
                    Text(localized("Learn more at www.jamesyyy.com", "了解更多 James Yuan：www.jamesyyy.com"))
                    Image(systemName: "arrow.up.right")
                        .font(.caption2.weight(.bold))
                }
                .font(.footnote.weight(.bold))
                .foregroundStyle(composer.color)
            }
        }
        .padding(20)
        .background(.white.opacity(0.30))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(classicalLineGradient)
                .frame(height: 1)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(classicalLineGradient)
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
    }

    private func localized(_ english: String, _ simplifiedChinese: String) -> String {
        language == .english ? english : simplifiedChinese
    }

    private var classicalLineGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, composer.color.opacity(0.28), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

private struct ArtQuoteView: View {
    let composer: Composer
    let language: AppLanguage

    var body: some View {
        VStack(spacing: 14) {
            DecorativeDivider(composer: composer)

            Text(composer.inspiration.text(for: language))
                .font(.system(size: language == .english ? 32 : 34, weight: .black, design: .serif))
                .italic()
                .lineSpacing(7)
                .multilineTextAlignment(.leading)
                .foregroundStyle(
                    LinearGradient(
                        colors: [composer.color, .primary, composer.color.opacity(0.72)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .white.opacity(0.72), radius: 1, y: 1)
                .frame(maxWidth: .infinity, alignment: .leading)

            DecorativeDivider(composer: composer, alignment: .trailing)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct DecorativeDivider: View {
    let composer: Composer
    var alignment: Alignment = .leading

    var body: some View {
        Text("-  ❦  -")
            .font(.system(size: 15, weight: .bold, design: .serif))
            .tracking(1.4)
            .foregroundStyle(composer.color.opacity(0.78))
            .frame(maxWidth: .infinity, alignment: alignment)
    }
}

private struct ImmersivePoemView: View {
    let composer: Composer
    let language: AppLanguage
    @State private var startDate = Date()

    var body: some View {
        let poem = PoemLibrary.poem(for: composer.id, language: language)

        TimelineView(.animation) { timeline in
            let elapsed = timeline.date.timeIntervalSince(startDate)
            let visibleCount = min(poem.lines.count, max(1, Int(elapsed / 2.4) + 1))

            VStack(alignment: .center, spacing: 18) {
                VStack(alignment: .center, spacing: 6) {
                    Text(localized("Poem for this music", "给这段音乐的诗"))
                        .font(.caption.weight(.bold))
                        .foregroundStyle(composer.color)

                    Text(poem.title)
                        .font(.system(size: 26, weight: .bold, design: .serif))
                        .foregroundStyle(.primary)

                    Text(poem.author)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Array(poem.lines.enumerated()), id: \.offset) { index, line in
                        Text(line)
                            .font(.system(size: language == .english ? 22 : 25, weight: .semibold, design: .serif))
                            .italic()
                            .lineSpacing(7)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundStyle(.primary.opacity(index < visibleCount ? 0.96 : 0.0))
                            .blur(radius: index < visibleCount ? 0 : 8)
                            .offset(y: index < visibleCount ? 0 : 10)
                            .animation(.easeOut(duration: 1.1), value: visibleCount)
                    }
                }
                .padding(.vertical, 8)

                Text(localized("Swipe to drift into another composer.", "左右滑动，进入另一位音乐家的世界。"))
                    .font(.footnote.weight(.medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .frame(maxWidth: .infinity, minHeight: 340, alignment: .top)
            .background(
                LinearGradient(
                    colors: [
                        .white.opacity(0.18),
                        composer.color.opacity(0.10),
                        .white.opacity(0.04)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(classicalLineGradient)
                    .frame(height: 1)
            }
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(classicalLineGradient)
                    .frame(height: 1)
            }
            .padding(20)
            .onChange(of: composer) { _, _ in
                startDate = Date()
            }
            .onChange(of: language) { _, _ in
                startDate = Date()
            }
        }
    }

    private func localized(_ english: String, _ simplifiedChinese: String) -> String {
        language == .english ? english : simplifiedChinese
    }

    private var classicalLineGradient: LinearGradient {
        LinearGradient(
            colors: [.clear, composer.color.opacity(0.30), .clear],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

private struct Poem {
    let title: String
    let author: String
    let lines: [String]
}

private enum PoemLibrary {
    static func poem(for composerID: String, language: AppLanguage) -> Poem {
        language == .english ? englishPoem(for: composerID) : chinesePoem(for: composerID)
    }

    private static func chinesePoem(for composerID: String) -> Poem {
        switch composerID {
        case "beethoven", "liszt", "verdi":
            return Poem(title: "行路难", author: "李白", lines: ["长风破浪会有时", "直挂云帆济沧海"])
        case "mozart", "haydn", "mendelssohn":
            return Poem(title: "春晓", author: "孟浩然", lines: ["春眠不觉晓", "处处闻啼鸟", "夜来风雨声", "花落知多少"])
        case "bach", "handel":
            return Poem(title: "登鹳雀楼", author: "王之涣", lines: ["白日依山尽", "黄河入海流", "欲穷千里目", "更上一层楼"])
        case "chopin", "schumann", "satie":
            return Poem(title: "静夜思", author: "李白", lines: ["床前明月光", "疑是地上霜", "举头望明月", "低头思故乡"])
        case "vivaldi", "grieg":
            return Poem(title: "钱塘湖春行", author: "白居易", lines: ["几处早莺争暖树", "谁家新燕啄春泥", "乱花渐欲迷人眼", "浅草才能没马蹄"])
        case "tchaikovsky", "saint-saens":
            return Poem(title: "鸟鸣涧", author: "王维", lines: ["人闲桂花落", "夜静春山空", "月出惊山鸟", "时鸣春涧中"])
        case "debussy", "ravel":
            return Poem(title: "望洞庭", author: "刘禹锡", lines: ["湖光秋月两相和", "潭面无风镜未磨", "遥望洞庭山水翠", "白银盘里一青螺"])
        case "mahler", "sibelius", "rachmaninoff":
            return Poem(title: "登幽州台歌", author: "陈子昂", lines: ["前不见古人", "后不见来者", "念天地之悠悠", "独怆然而涕下"])
        case "prokofiev", "stravinsky", "bizet":
            return Poem(title: "凉州词", author: "王翰", lines: ["葡萄美酒夜光杯", "欲饮琵琶马上催", "醉卧沙场君莫笑", "古来征战几人回"])
        case "elgar", "puccini":
            return Poem(title: "相思", author: "王维", lines: ["红豆生南国", "春来发几枝", "愿君多采撷", "此物最相思"])
        case "dvorak", "mussorgsky":
            return Poem(title: "渡汉江", author: "宋之问", lines: ["近乡情更怯", "不敢问来人"])
        default:
            return Poem(title: "山居秋暝", author: "王维", lines: ["空山新雨后", "天气晚来秋", "明月松间照", "清泉石上流"])
        }
    }

    private static func englishPoem(for composerID: String) -> Poem {
        switch composerID {
        case "beethoven", "liszt", "verdi":
            return Poem(title: "Prometheus Unbound", author: "Percy Bysshe Shelley", lines: ["To suffer woes which Hope thinks infinite;", "To forgive wrongs darker than death or night."])
        case "mozart", "haydn", "mendelssohn":
            return Poem(title: "Auguries of Innocence", author: "William Blake", lines: ["To see a World in a Grain of Sand", "And a Heaven in a Wild Flower."])
        case "bach", "handel":
            return Poem(title: "Ode: Intimations", author: "William Wordsworth", lines: ["Trailing clouds of glory do we come", "From God, who is our home."])
        case "chopin", "schumann", "satie":
            return Poem(title: "She Walks in Beauty", author: "Lord Byron", lines: ["She walks in beauty, like the night", "Of cloudless climes and starry skies."])
        case "vivaldi", "grieg":
            return Poem(title: "Lines Written in Early Spring", author: "William Wordsworth", lines: ["To her fair works did Nature link", "The human soul that through me ran."])
        case "tchaikovsky", "saint-saens":
            return Poem(title: "To a Waterfowl", author: "William Cullen Bryant", lines: ["There is a Power whose care", "Teaches thy way along that pathless coast."])
        case "debussy", "ravel":
            return Poem(title: "The Lake Isle of Innisfree", author: "W. B. Yeats", lines: ["I hear lake water lapping with low sounds by the shore;", "I hear it in the deep heart's core."])
        case "mahler", "sibelius", "rachmaninoff":
            return Poem(title: "Crossing the Bar", author: "Alfred, Lord Tennyson", lines: ["Sunset and evening star,", "And one clear call for me!"])
        case "prokofiev", "stravinsky", "bizet":
            return Poem(title: "The Tyger", author: "William Blake", lines: ["Tyger Tyger, burning bright,", "In the forests of the night."])
        case "elgar", "puccini":
            return Poem(title: "A Red, Red Rose", author: "Robert Burns", lines: ["O my Luve is like a red, red rose", "That's newly sprung in June."])
        case "dvorak", "mussorgsky":
            return Poem(title: "I Wandered Lonely as a Cloud", author: "William Wordsworth", lines: ["I wandered lonely as a cloud", "That floats on high o'er vales and hills."])
        default:
            return Poem(title: "Hope is the thing with feathers", author: "Emily Dickinson", lines: ["Hope is the thing with feathers", "That perches in the soul."])
        }
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
