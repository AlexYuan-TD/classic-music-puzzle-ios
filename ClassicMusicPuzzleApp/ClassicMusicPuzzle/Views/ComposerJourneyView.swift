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
                        ArtQuoteView(composer: composer, language: language)
                        ImmersivePoemView(composer: composer, language: language)
                    }
                    .frame(maxWidth: .infinity)
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
        }
        .ignoresSafeArea()
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
        .background(.ultraThinMaterial)
    }
}

private struct ArtQuoteView: View {
    let composer: Composer
    let language: AppLanguage

    var body: some View {
        Text(composer.inspiration.text(for: language))
            .font(.system(size: language == .english ? 32 : 34, weight: .black, design: .serif))
            .italic()
            .lineSpacing(7)
            .foregroundStyle(
                LinearGradient(
                    colors: [composer.color, .primary, composer.color.opacity(0.72)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .white.opacity(0.72), radius: 1, y: 1)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white.opacity(0.34))
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
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.white.opacity(0.50))
                    RoundedRectangle(cornerRadius: 8)
                        .fill(composer.color.opacity(0.12))
                }
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(0.42), lineWidth: 1)
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
