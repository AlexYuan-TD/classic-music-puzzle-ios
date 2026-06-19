import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english
    case simplifiedChinese

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .english: return "English"
        case .simplifiedChinese: return "中文"
        }
    }
}

struct LocalizedCopy: Equatable {
    let english: String
    let simplifiedChinese: String

    func text(for language: AppLanguage) -> String {
        switch language {
        case .english: return english
        case .simplifiedChinese: return simplifiedChinese
        }
    }
}

struct Composer: Identifiable, Equatable {
    let id: String
    let name: LocalizedCopy
    let years: String
    let country: LocalizedCopy
    let introduction: LocalizedCopy
    let inspiration: LocalizedCopy
    let famousWork: LocalizedCopy
    let color: Color
    let portraitAssetName: String?
    let theme: MusicalTheme
}

struct MusicalTheme: Equatable {
    let title: LocalizedCopy
    let tempo: Double
    let notes: [ThemeNote]
}

struct ThemeNote: Equatable {
    let frequency: Double
    let beats: Double
}

extension Composer {
    private static let brightMotif = [
        ThemeNote(frequency: 261.63, beats: 0.5), ThemeNote(frequency: 329.63, beats: 0.5),
        ThemeNote(frequency: 392.00, beats: 0.5), ThemeNote(frequency: 523.25, beats: 1.0),
        ThemeNote(frequency: 392.00, beats: 0.5), ThemeNote(frequency: 329.63, beats: 0.5),
        ThemeNote(frequency: 293.66, beats: 1.0)
    ]

    private static let lyricalMotif = [
        ThemeNote(frequency: 329.63, beats: 0.75), ThemeNote(frequency: 392.00, beats: 0.75),
        ThemeNote(frequency: 440.00, beats: 0.5), ThemeNote(frequency: 392.00, beats: 0.5),
        ThemeNote(frequency: 349.23, beats: 0.75), ThemeNote(frequency: 329.63, beats: 1.0)
    ]

    private static let danceMotif = [
        ThemeNote(frequency: 392.00, beats: 0.5), ThemeNote(frequency: 493.88, beats: 0.5),
        ThemeNote(frequency: 587.33, beats: 0.5), ThemeNote(frequency: 493.88, beats: 0.5),
        ThemeNote(frequency: 392.00, beats: 0.5), ThemeNote(frequency: 329.63, beats: 0.5),
        ThemeNote(frequency: 392.00, beats: 1.0)
    ]

    private static let darkMotif = [
        ThemeNote(frequency: 220.00, beats: 0.75), ThemeNote(frequency: 261.63, beats: 0.5),
        ThemeNote(frequency: 311.13, beats: 0.75), ThemeNote(frequency: 293.66, beats: 0.5),
        ThemeNote(frequency: 246.94, beats: 1.0), ThemeNote(frequency: 220.00, beats: 1.0)
    ]

    static let catalog: [Composer] = [
        Composer(
            id: "beethoven",
            name: LocalizedCopy(english: "Ludwig van Beethoven", simplifiedChinese: "路德维希·范·贝多芬"),
            years: "1770-1827",
            country: LocalizedCopy(english: "Germany", simplifiedChinese: "德国"),
            introduction: LocalizedCopy(
                english: "Beethoven turned struggle into sound, giving classical form a more human, storm-lit voice.",
                simplifiedChinese: "贝多芬把挣扎化为声音，让古典形式拥有更炽热、更人性的力量。"
            ),
            inspiration: LocalizedCopy(
                english: "Begin again with courage. Even silence can become music.",
                simplifiedChinese: "带着勇气重新开始。即使沉默，也能成为音乐。"
            ),
            famousWork: LocalizedCopy(english: "Symphony No. 5", simplifiedChinese: "第五交响曲"),
            color: Color(red: 0.72, green: 0.16, blue: 0.15),
            portraitAssetName: "PortraitBeethoven",
            theme: MusicalTheme(
                title: LocalizedCopy(english: "Symphony No. 5 motif", simplifiedChinese: "第五交响曲动机"),
                tempo: 112,
                notes: [
                    .init(frequency: 392.00, beats: 0.5), .init(frequency: 392.00, beats: 0.5),
                    .init(frequency: 392.00, beats: 0.5), .init(frequency: 311.13, beats: 1.5),
                    .init(frequency: 349.23, beats: 0.5), .init(frequency: 349.23, beats: 0.5),
                    .init(frequency: 349.23, beats: 0.5), .init(frequency: 293.66, beats: 1.5)
                ]
            )
        ),
        Composer(
            id: "mozart",
            name: LocalizedCopy(english: "Wolfgang Amadeus Mozart", simplifiedChinese: "沃尔夫冈·阿马德乌斯·莫扎特"),
            years: "1756-1791",
            country: LocalizedCopy(english: "Austria", simplifiedChinese: "奥地利"),
            introduction: LocalizedCopy(
                english: "Mozart made clarity feel effortless, filling simple shapes with wit, grace, and surprise.",
                simplifiedChinese: "莫扎特让清澈听起来毫不费力，把简单的形状装满机智、优雅与惊喜。"
            ),
            inspiration: LocalizedCopy(
                english: "Let lightness be serious. Joy can be a discipline.",
                simplifiedChinese: "让轻盈也变得认真。快乐，也是一种练习。"
            ),
            famousWork: LocalizedCopy(english: "Eine kleine Nachtmusik", simplifiedChinese: "小夜曲"),
            color: Color(red: 0.10, green: 0.42, blue: 0.66),
            portraitAssetName: "PortraitMozart",
            theme: MusicalTheme(
                title: LocalizedCopy(english: "Eine kleine Nachtmusik opening", simplifiedChinese: "小夜曲开头主题"),
                tempo: 132,
                notes: [
                    .init(frequency: 392.00, beats: 0.5), .init(frequency: 0, beats: 0.25),
                    .init(frequency: 587.33, beats: 0.5), .init(frequency: 392.00, beats: 0.5),
                    .init(frequency: 587.33, beats: 0.5), .init(frequency: 392.00, beats: 0.5),
                    .init(frequency: 783.99, beats: 1.0), .init(frequency: 739.99, beats: 0.5),
                    .init(frequency: 659.25, beats: 0.5), .init(frequency: 587.33, beats: 1.0)
                ]
            )
        ),
        Composer(
            id: "bach",
            name: LocalizedCopy(english: "Johann Sebastian Bach", simplifiedChinese: "约翰·塞巴斯蒂安·巴赫"),
            years: "1685-1750",
            country: LocalizedCopy(english: "Germany", simplifiedChinese: "德国"),
            introduction: LocalizedCopy(
                english: "Bach built musical cathedrals from pattern, patience, and spiritual intensity.",
                simplifiedChinese: "巴赫用秩序、耐心与精神的光，建造出一座座音乐中的教堂。"
            ),
            inspiration: LocalizedCopy(
                english: "Small steps can hold a universe when they move with care.",
                simplifiedChinese: "小小的步伐，只要足够专注，也能托起一个宇宙。"
            ),
            famousWork: LocalizedCopy(english: "Cello Suite No. 1", simplifiedChinese: "第一大提琴组曲"),
            color: Color(red: 0.22, green: 0.45, blue: 0.30),
            portraitAssetName: "PortraitBach",
            theme: MusicalTheme(
                title: LocalizedCopy(english: "Cello Suite No. 1 prelude shape", simplifiedChinese: "第一大提琴组曲前奏轮廓"),
                tempo: 96,
                notes: [
                    .init(frequency: 196.00, beats: 0.5), .init(frequency: 293.66, beats: 0.5),
                    .init(frequency: 246.94, beats: 0.5), .init(frequency: 293.66, beats: 0.5),
                    .init(frequency: 196.00, beats: 0.5), .init(frequency: 293.66, beats: 0.5),
                    .init(frequency: 246.94, beats: 0.5), .init(frequency: 293.66, beats: 0.5)
                ]
            )
        ),
        Composer(
            id: "chopin",
            name: LocalizedCopy(english: "Frederic Chopin", simplifiedChinese: "弗雷德里克·肖邦"),
            years: "1810-1849",
            country: LocalizedCopy(english: "Poland", simplifiedChinese: "波兰"),
            introduction: LocalizedCopy(
                english: "Chopin made the piano speak privately, as if a room could remember every feeling.",
                simplifiedChinese: "肖邦让钢琴像在低声私语，仿佛一个房间记住了所有情绪。"
            ),
            inspiration: LocalizedCopy(
                english: "Softness is not weakness. It is precision with a heartbeat.",
                simplifiedChinese: "柔软不是脆弱，而是带着心跳的精准。"
            ),
            famousWork: LocalizedCopy(english: "Nocturne Op. 9 No. 2", simplifiedChinese: "夜曲 Op. 9 No. 2"),
            color: Color(red: 0.49, green: 0.28, blue: 0.58),
            portraitAssetName: "PortraitChopin",
            theme: MusicalTheme(
                title: LocalizedCopy(english: "Nocturne Op. 9 No. 2 contour", simplifiedChinese: "夜曲 Op. 9 No. 2 旋律轮廓"),
                tempo: 72,
                notes: [
                    .init(frequency: 466.16, beats: 0.75), .init(frequency: 523.25, beats: 0.5),
                    .init(frequency: 554.37, beats: 0.5), .init(frequency: 622.25, beats: 1.0),
                    .init(frequency: 587.33, beats: 0.5), .init(frequency: 554.37, beats: 0.5),
                    .init(frequency: 523.25, beats: 1.25)
                ]
            )
        ),
        Composer(
            id: "vivaldi",
            name: LocalizedCopy(english: "Antonio Vivaldi", simplifiedChinese: "安东尼奥·维瓦尔第"),
            years: "1678-1741",
            country: LocalizedCopy(english: "Italy", simplifiedChinese: "意大利"),
            introduction: LocalizedCopy(english: "Vivaldi painted weather, light, and motion with strings that seem to breathe.", simplifiedChinese: "维瓦尔第用弦乐描绘天气、光线与流动，仿佛音乐自己在呼吸。"),
            inspiration: LocalizedCopy(english: "Let the season change you without losing your pulse.", simplifiedChinese: "让季节改变你，但不要失去自己的脉搏。"),
            famousWork: LocalizedCopy(english: "The Four Seasons", simplifiedChinese: "四季"),
            color: Color(red: 0.86, green: 0.34, blue: 0.12),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Spring theme", simplifiedChinese: "春主题"), tempo: 120, notes: brightMotif)
        ),
        Composer(
            id: "handel",
            name: LocalizedCopy(english: "George Frideric Handel", simplifiedChinese: "乔治·弗里德里希·亨德尔"),
            years: "1685-1759",
            country: LocalizedCopy(english: "Germany / England", simplifiedChinese: "德国 / 英国"),
            introduction: LocalizedCopy(english: "Handel gave ceremony a golden voice, turning public grandeur into song.", simplifiedChinese: "亨德尔让典礼拥有金色的声音，把宏大的场面化成歌唱。"),
            inspiration: LocalizedCopy(english: "Rise with dignity. Your quiet strength can still sound grand.", simplifiedChinese: "带着尊严站起来。安静的力量，也可以很宏伟。"),
            famousWork: LocalizedCopy(english: "Messiah", simplifiedChinese: "弥赛亚"),
            color: Color(red: 0.72, green: 0.52, blue: 0.15),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Hallelujah contour", simplifiedChinese: "哈利路亚轮廓"), tempo: 104, notes: brightMotif)
        ),
        Composer(
            id: "haydn",
            name: LocalizedCopy(english: "Joseph Haydn", simplifiedChinese: "约瑟夫·海顿"),
            years: "1732-1809",
            country: LocalizedCopy(english: "Austria", simplifiedChinese: "奥地利"),
            introduction: LocalizedCopy(english: "Haydn made musical conversation sparkle with balance, humor, and invention.", simplifiedChinese: "海顿让音乐对话闪闪发光，充满平衡、幽默与创造力。"),
            inspiration: LocalizedCopy(english: "Build with patience; surprise can live inside order.", simplifiedChinese: "耐心地建造；惊喜也能住在秩序里。"),
            famousWork: LocalizedCopy(english: "Surprise Symphony", simplifiedChinese: "惊愕交响曲"),
            color: Color(red: 0.44, green: 0.56, blue: 0.28),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Surprise Symphony shape", simplifiedChinese: "惊愕交响曲轮廓"), tempo: 100, notes: danceMotif)
        ),
        Composer(
            id: "schubert",
            name: LocalizedCopy(english: "Franz Schubert", simplifiedChinese: "弗朗茨·舒伯特"),
            years: "1797-1828",
            country: LocalizedCopy(english: "Austria", simplifiedChinese: "奥地利"),
            introduction: LocalizedCopy(english: "Schubert found entire landscapes inside melody, tender and suddenly infinite.", simplifiedChinese: "舒伯特在旋律里发现整片风景，温柔而忽然辽阔。"),
            inspiration: LocalizedCopy(english: "A small song can open a wide sky.", simplifiedChinese: "一首小歌，也能打开很宽的天空。"),
            famousWork: LocalizedCopy(english: "Ave Maria", simplifiedChinese: "圣母颂"),
            color: Color(red: 0.32, green: 0.42, blue: 0.72),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Ave Maria contour", simplifiedChinese: "圣母颂轮廓"), tempo: 72, notes: lyricalMotif)
        ),
        Composer(
            id: "schumann",
            name: LocalizedCopy(english: "Robert Schumann", simplifiedChinese: "罗伯特·舒曼"),
            years: "1810-1856",
            country: LocalizedCopy(english: "Germany", simplifiedChinese: "德国"),
            introduction: LocalizedCopy(english: "Schumann wrote like a diary with two hearts: dreamer and dancer.", simplifiedChinese: "舒曼像用两颗心写日记：一颗做梦，一颗跳舞。"),
            inspiration: LocalizedCopy(english: "Honor every inner voice; they may become harmony.", simplifiedChinese: "尊重内心的每个声音，它们也许会成为和声。"),
            famousWork: LocalizedCopy(english: "Scenes from Childhood", simplifiedChinese: "童年情景"),
            color: Color(red: 0.56, green: 0.30, blue: 0.50),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Traumerei contour", simplifiedChinese: "梦幻曲轮廓"), tempo: 76, notes: lyricalMotif)
        ),
        Composer(
            id: "liszt",
            name: LocalizedCopy(english: "Franz Liszt", simplifiedChinese: "弗朗茨·李斯特"),
            years: "1811-1886",
            country: LocalizedCopy(english: "Hungary", simplifiedChinese: "匈牙利"),
            introduction: LocalizedCopy(english: "Liszt turned the piano into thunder, theater, prayer, and flame.", simplifiedChinese: "李斯特把钢琴变成雷声、剧场、祈祷与火焰。"),
            inspiration: LocalizedCopy(english: "Do not hide your fire; shape it until it shines.", simplifiedChinese: "不要藏起你的火，把它塑造成光。"),
            famousWork: LocalizedCopy(english: "Hungarian Rhapsody No. 2", simplifiedChinese: "第二匈牙利狂想曲"),
            color: Color(red: 0.65, green: 0.14, blue: 0.38),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Hungarian Rhapsody pulse", simplifiedChinese: "匈牙利狂想曲脉动"), tempo: 128, notes: danceMotif)
        ),
        Composer(
            id: "brahms",
            name: LocalizedCopy(english: "Johannes Brahms", simplifiedChinese: "约翰内斯·勃拉姆斯"),
            years: "1833-1897",
            country: LocalizedCopy(english: "Germany", simplifiedChinese: "德国"),
            introduction: LocalizedCopy(english: "Brahms carried old forms with warm blood, deep shadow, and autumn light.", simplifiedChinese: "勃拉姆斯让古老形式流着温热的血，带着深影与秋光。"),
            inspiration: LocalizedCopy(english: "Depth does not need hurry. Let the heart mature.", simplifiedChinese: "深度不需要匆忙，让心慢慢成熟。"),
            famousWork: LocalizedCopy(english: "Hungarian Dance No. 5", simplifiedChinese: "第五匈牙利舞曲"),
            color: Color(red: 0.40, green: 0.25, blue: 0.18),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Hungarian Dance drive", simplifiedChinese: "匈牙利舞曲律动"), tempo: 130, notes: danceMotif)
        ),
        Composer(
            id: "tchaikovsky",
            name: LocalizedCopy(english: "Pyotr Ilyich Tchaikovsky", simplifiedChinese: "彼得·伊里奇·柴可夫斯基"),
            years: "1840-1893",
            country: LocalizedCopy(english: "Russia", simplifiedChinese: "俄罗斯"),
            introduction: LocalizedCopy(english: "Tchaikovsky made emotion dance in sweeping lines of longing and light.", simplifiedChinese: "柴可夫斯基让情感在渴望与光芒的长线条里起舞。"),
            inspiration: LocalizedCopy(english: "Let feeling move; it may find its own choreography.", simplifiedChinese: "让情感动起来，它会找到自己的舞步。"),
            famousWork: LocalizedCopy(english: "Swan Lake", simplifiedChinese: "天鹅湖"),
            color: Color(red: 0.20, green: 0.38, blue: 0.70),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Swan Lake contour", simplifiedChinese: "天鹅湖轮廓"), tempo: 84, notes: lyricalMotif)
        ),
        Composer(
            id: "dvorak",
            name: LocalizedCopy(english: "Antonin Dvorak", simplifiedChinese: "安东宁·德沃夏克"),
            years: "1841-1904",
            country: LocalizedCopy(english: "Czech lands", simplifiedChinese: "捷克"),
            introduction: LocalizedCopy(english: "Dvorak heard home and distance at once, giving folk spirit symphonic wings.", simplifiedChinese: "德沃夏克同时听见故乡与远方，让民间精神长出交响的翅膀。"),
            inspiration: LocalizedCopy(english: "Carry home with you; it can become a horizon.", simplifiedChinese: "把故乡带在身上，它也可以成为远方。"),
            famousWork: LocalizedCopy(english: "New World Symphony", simplifiedChinese: "新世界交响曲"),
            color: Color(red: 0.16, green: 0.48, blue: 0.54),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "New World theme", simplifiedChinese: "新世界主题"), tempo: 88, notes: lyricalMotif)
        ),
        Composer(
            id: "grieg",
            name: LocalizedCopy(english: "Edvard Grieg", simplifiedChinese: "爱德华·格里格"),
            years: "1843-1907",
            country: LocalizedCopy(english: "Norway", simplifiedChinese: "挪威"),
            introduction: LocalizedCopy(english: "Grieg made mountains, morning air, and folklore glow in miniature.", simplifiedChinese: "格里格让山脉、晨光与民间传说在小巧篇幅中发亮。"),
            inspiration: LocalizedCopy(english: "Begin softly; morning does not need to shout.", simplifiedChinese: "轻轻开始吧，清晨不需要呼喊。"),
            famousWork: LocalizedCopy(english: "Peer Gynt: Morning Mood", simplifiedChinese: "培尔·金特：晨景"),
            color: Color(red: 0.22, green: 0.58, blue: 0.50),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Morning Mood shape", simplifiedChinese: "晨景轮廓"), tempo: 80, notes: brightMotif)
        ),
        Composer(
            id: "debussy",
            name: LocalizedCopy(english: "Claude Debussy", simplifiedChinese: "克洛德·德彪西"),
            years: "1862-1918",
            country: LocalizedCopy(english: "France", simplifiedChinese: "法国"),
            introduction: LocalizedCopy(english: "Debussy blurred edges until harmony became water, moonlight, and perfume.", simplifiedChinese: "德彪西模糊边界，让和声变成水、月光与香气。"),
            inspiration: LocalizedCopy(english: "Not every truth has a hard outline.", simplifiedChinese: "并不是每一种真实，都需要清晰的轮廓。"),
            famousWork: LocalizedCopy(english: "Clair de Lune", simplifiedChinese: "月光"),
            color: Color(red: 0.42, green: 0.50, blue: 0.78),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Clair de Lune contour", simplifiedChinese: "月光轮廓"), tempo: 66, notes: lyricalMotif)
        ),
        Composer(
            id: "ravel",
            name: LocalizedCopy(english: "Maurice Ravel", simplifiedChinese: "莫里斯·拉威尔"),
            years: "1875-1937",
            country: LocalizedCopy(english: "France", simplifiedChinese: "法国"),
            introduction: LocalizedCopy(english: "Ravel crafted color with jeweler-like precision and a dancer's nerve.", simplifiedChinese: "拉威尔像珠宝匠一样雕刻色彩，又带着舞者的神经。"),
            inspiration: LocalizedCopy(english: "Precision can still shimmer.", simplifiedChinese: "精准，也可以闪闪发光。"),
            famousWork: LocalizedCopy(english: "Bolero", simplifiedChinese: "波莱罗"),
            color: Color(red: 0.72, green: 0.28, blue: 0.22),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Bolero pulse", simplifiedChinese: "波莱罗脉动"), tempo: 116, notes: danceMotif)
        ),
        Composer(
            id: "saint-saens",
            name: LocalizedCopy(english: "Camille Saint-Saens", simplifiedChinese: "卡米尔·圣-桑"),
            years: "1835-1921",
            country: LocalizedCopy(english: "France", simplifiedChinese: "法国"),
            introduction: LocalizedCopy(english: "Saint-Saens balanced elegance and wit, making animals, dances, and organs sparkle.", simplifiedChinese: "圣-桑平衡优雅与机智，让动物、舞蹈与管风琴都闪耀起来。"),
            inspiration: LocalizedCopy(english: "Playfulness is a serious kind of intelligence.", simplifiedChinese: "玩心，是一种很认真的智慧。"),
            famousWork: LocalizedCopy(english: "The Swan", simplifiedChinese: "天鹅"),
            color: Color(red: 0.35, green: 0.62, blue: 0.72),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "The Swan contour", simplifiedChinese: "天鹅轮廓"), tempo: 74, notes: lyricalMotif)
        ),
        Composer(
            id: "mendelssohn",
            name: LocalizedCopy(english: "Felix Mendelssohn", simplifiedChinese: "费利克斯·门德尔松"),
            years: "1809-1847",
            country: LocalizedCopy(english: "Germany", simplifiedChinese: "德国"),
            introduction: LocalizedCopy(english: "Mendelssohn gave lightness wings, quicksilver, and classical grace.", simplifiedChinese: "门德尔松让轻盈拥有翅膀、流光与古典的优雅。"),
            inspiration: LocalizedCopy(english: "Move lightly, but mean every step.", simplifiedChinese: "轻盈地前进，但每一步都要真诚。"),
            famousWork: LocalizedCopy(english: "Wedding March", simplifiedChinese: "婚礼进行曲"),
            color: Color(red: 0.30, green: 0.52, blue: 0.70),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Wedding March shape", simplifiedChinese: "婚礼进行曲轮廓"), tempo: 110, notes: brightMotif)
        ),
        Composer(
            id: "mahler",
            name: LocalizedCopy(english: "Gustav Mahler", simplifiedChinese: "古斯塔夫·马勒"),
            years: "1860-1911",
            country: LocalizedCopy(english: "Austria", simplifiedChinese: "奥地利"),
            introduction: LocalizedCopy(english: "Mahler stretched the symphony until it could hold a whole world.", simplifiedChinese: "马勒把交响曲拉伸到足以容纳整个世界。"),
            inspiration: LocalizedCopy(english: "Make room for everything: grief, wonder, memory, and dawn.", simplifiedChinese: "为一切留出空间：悲伤、惊奇、记忆与黎明。"),
            famousWork: LocalizedCopy(english: "Symphony No. 5 Adagietto", simplifiedChinese: "第五交响曲柔板"),
            color: Color(red: 0.30, green: 0.22, blue: 0.48),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Adagietto contour", simplifiedChinese: "柔板轮廓"), tempo: 64, notes: darkMotif)
        ),
        Composer(
            id: "sibelius",
            name: LocalizedCopy(english: "Jean Sibelius", simplifiedChinese: "让·西贝柳斯"),
            years: "1865-1957",
            country: LocalizedCopy(english: "Finland", simplifiedChinese: "芬兰"),
            introduction: LocalizedCopy(english: "Sibelius carved music like northern stone, wind, and wide silence.", simplifiedChinese: "西贝柳斯像雕刻北方的石头、风和辽阔沉默一样写音乐。"),
            inspiration: LocalizedCopy(english: "Silence can be a landscape, not an absence.", simplifiedChinese: "沉默也可以是一片风景，而不是空缺。"),
            famousWork: LocalizedCopy(english: "Finlandia", simplifiedChinese: "芬兰颂"),
            color: Color(red: 0.18, green: 0.34, blue: 0.58),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Finlandia hymn", simplifiedChinese: "芬兰颂赞歌"), tempo: 76, notes: darkMotif)
        ),
        Composer(
            id: "rachmaninoff",
            name: LocalizedCopy(english: "Sergei Rachmaninoff", simplifiedChinese: "谢尔盖·拉赫玛尼诺夫"),
            years: "1873-1943",
            country: LocalizedCopy(english: "Russia", simplifiedChinese: "俄罗斯"),
            introduction: LocalizedCopy(english: "Rachmaninoff made nostalgia vast, with piano lines that seem to remember everything.", simplifiedChinese: "拉赫玛尼诺夫让乡愁变得辽阔，钢琴线条仿佛记住了一切。"),
            inspiration: LocalizedCopy(english: "Longing can become strength when you give it form.", simplifiedChinese: "当你赋予思念形状，它就能变成力量。"),
            famousWork: LocalizedCopy(english: "Piano Concerto No. 2", simplifiedChinese: "第二钢琴协奏曲"),
            color: Color(red: 0.46, green: 0.16, blue: 0.22),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Piano Concerto No. 2 contour", simplifiedChinese: "第二钢琴协奏曲轮廓"), tempo: 78, notes: darkMotif)
        ),
        Composer(
            id: "prokofiev",
            name: LocalizedCopy(english: "Sergei Prokofiev", simplifiedChinese: "谢尔盖·普罗科菲耶夫"),
            years: "1891-1953",
            country: LocalizedCopy(english: "Russia", simplifiedChinese: "俄罗斯"),
            introduction: LocalizedCopy(english: "Prokofiev sharpened fairy tales and rhythm until music could grin and leap.", simplifiedChinese: "普罗科菲耶夫把童话和节奏磨得锋利，让音乐会咧嘴笑、会跳跃。"),
            inspiration: LocalizedCopy(english: "Keep your edge; playfulness can still be brave.", simplifiedChinese: "保留你的锋芒，玩心也可以很勇敢。"),
            famousWork: LocalizedCopy(english: "Peter and the Wolf", simplifiedChinese: "彼得与狼"),
            color: Color(red: 0.68, green: 0.24, blue: 0.18),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Peter theme", simplifiedChinese: "彼得主题"), tempo: 118, notes: danceMotif)
        ),
        Composer(
            id: "shostakovich",
            name: LocalizedCopy(english: "Dmitri Shostakovich", simplifiedChinese: "德米特里·肖斯塔科维奇"),
            years: "1906-1975",
            country: LocalizedCopy(english: "Russia", simplifiedChinese: "俄罗斯"),
            introduction: LocalizedCopy(english: "Shostakovich hid irony, fear, and courage inside unforgettable musical signals.", simplifiedChinese: "肖斯塔科维奇把讽刺、恐惧与勇气藏进难忘的音乐信号中。"),
            inspiration: LocalizedCopy(english: "Even under pressure, a true voice can leave a mark.", simplifiedChinese: "即使承受压力，真实的声音仍会留下痕迹。"),
            famousWork: LocalizedCopy(english: "Waltz No. 2", simplifiedChinese: "第二圆舞曲"),
            color: Color(red: 0.30, green: 0.30, blue: 0.34),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Waltz No. 2 shape", simplifiedChinese: "第二圆舞曲轮廓"), tempo: 96, notes: danceMotif)
        ),
        Composer(
            id: "stravinsky",
            name: LocalizedCopy(english: "Igor Stravinsky", simplifiedChinese: "伊戈尔·斯特拉文斯基"),
            years: "1882-1971",
            country: LocalizedCopy(english: "Russia / France / United States", simplifiedChinese: "俄罗斯 / 法国 / 美国"),
            introduction: LocalizedCopy(english: "Stravinsky made rhythm modern, bright, fierce, and impossible to ignore.", simplifiedChinese: "斯特拉文斯基让节奏变得现代、明亮、凶猛，无法被忽视。"),
            inspiration: LocalizedCopy(english: "Break the pattern only after you can feel its bones.", simplifiedChinese: "先摸到结构的骨头，再去打破它。"),
            famousWork: LocalizedCopy(english: "The Rite of Spring", simplifiedChinese: "春之祭"),
            color: Color(red: 0.70, green: 0.32, blue: 0.12),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Rite rhythm", simplifiedChinese: "春之祭节奏"), tempo: 132, notes: danceMotif)
        ),
        Composer(
            id: "elgar",
            name: LocalizedCopy(english: "Edward Elgar", simplifiedChinese: "爱德华·埃尔加"),
            years: "1857-1934",
            country: LocalizedCopy(english: "England", simplifiedChinese: "英格兰"),
            introduction: LocalizedCopy(english: "Elgar gave nobility a private tenderness beneath the ceremonial shine.", simplifiedChinese: "埃尔加在典礼的光辉下，藏着一种私人的温柔。"),
            inspiration: LocalizedCopy(english: "Stand tall, but keep the tender center alive.", simplifiedChinese: "挺直站立，也别熄灭内心的温柔。"),
            famousWork: LocalizedCopy(english: "Enigma Variations: Nimrod", simplifiedChinese: "谜语变奏曲：宁录"),
            color: Color(red: 0.44, green: 0.36, blue: 0.24),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Nimrod contour", simplifiedChinese: "宁录轮廓"), tempo: 70, notes: lyricalMotif)
        ),
        Composer(
            id: "puccini",
            name: LocalizedCopy(english: "Giacomo Puccini", simplifiedChinese: "贾科莫·普契尼"),
            years: "1858-1924",
            country: LocalizedCopy(english: "Italy", simplifiedChinese: "意大利"),
            introduction: LocalizedCopy(english: "Puccini made melody speak like theater at the exact edge of tears.", simplifiedChinese: "普契尼让旋律像剧场一样说话，停在眼泪将落未落的边缘。"),
            inspiration: LocalizedCopy(english: "Let beauty say what words cannot carry.", simplifiedChinese: "让美说出语言承载不了的东西。"),
            famousWork: LocalizedCopy(english: "Nessun Dorma", simplifiedChinese: "今夜无人入睡"),
            color: Color(red: 0.66, green: 0.22, blue: 0.24),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Nessun Dorma contour", simplifiedChinese: "今夜无人入睡轮廓"), tempo: 78, notes: brightMotif)
        ),
        Composer(
            id: "verdi",
            name: LocalizedCopy(english: "Giuseppe Verdi", simplifiedChinese: "朱塞佩·威尔第"),
            years: "1813-1901",
            country: LocalizedCopy(english: "Italy", simplifiedChinese: "意大利"),
            introduction: LocalizedCopy(english: "Verdi made human drama sing with directness, fire, and unforgettable breath.", simplifiedChinese: "威尔第让人性的戏剧以直接、炽热、难忘的呼吸歌唱。"),
            inspiration: LocalizedCopy(english: "Speak plainly when the heart is on fire.", simplifiedChinese: "当心燃烧时，就坦率地说。"),
            famousWork: LocalizedCopy(english: "La donna e mobile", simplifiedChinese: "女人善变"),
            color: Color(red: 0.54, green: 0.12, blue: 0.18),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "La donna e mobile contour", simplifiedChinese: "女人善变轮廓"), tempo: 124, notes: brightMotif)
        ),
        Composer(
            id: "bizet",
            name: LocalizedCopy(english: "Georges Bizet", simplifiedChinese: "乔治·比才"),
            years: "1838-1875",
            country: LocalizedCopy(english: "France", simplifiedChinese: "法国"),
            introduction: LocalizedCopy(english: "Bizet fused theatrical color, danger, and rhythm into melodies that refuse to sit still.", simplifiedChinese: "比才把戏剧色彩、危险与节奏融进不肯安静的旋律里。"),
            inspiration: LocalizedCopy(english: "Energy is a color. Let it be vivid.", simplifiedChinese: "能量也是一种颜色，让它鲜明起来。"),
            famousWork: LocalizedCopy(english: "Carmen: Habanera", simplifiedChinese: "卡门：哈巴涅拉"),
            color: Color(red: 0.75, green: 0.20, blue: 0.16),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Habanera pulse", simplifiedChinese: "哈巴涅拉脉动"), tempo: 108, notes: danceMotif)
        ),
        Composer(
            id: "mussorgsky",
            name: LocalizedCopy(english: "Modest Mussorgsky", simplifiedChinese: "穆捷斯特·穆索尔斯基"),
            years: "1839-1881",
            country: LocalizedCopy(english: "Russia", simplifiedChinese: "俄罗斯"),
            introduction: LocalizedCopy(english: "Mussorgsky made pictures walk, breathe, and glow through rugged musical imagination.", simplifiedChinese: "穆索尔斯基让图画在粗犷的音乐想象中行走、呼吸、发光。"),
            inspiration: LocalizedCopy(english: "Walk through the gallery of your mind; every image has a sound.", simplifiedChinese: "走过你心里的画廊，每幅图像都有声音。"),
            famousWork: LocalizedCopy(english: "Pictures at an Exhibition", simplifiedChinese: "图画展览会"),
            color: Color(red: 0.42, green: 0.20, blue: 0.13),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Promenade contour", simplifiedChinese: "漫步主题轮廓"), tempo: 96, notes: brightMotif)
        ),
        Composer(
            id: "satie",
            name: LocalizedCopy(english: "Erik Satie", simplifiedChinese: "埃里克·萨蒂"),
            years: "1866-1925",
            country: LocalizedCopy(english: "France", simplifiedChinese: "法国"),
            introduction: LocalizedCopy(english: "Satie made simplicity strange, quiet, and gently rebellious.", simplifiedChinese: "萨蒂让简单变得奇异、安静，并带一点温柔的叛逆。"),
            inspiration: LocalizedCopy(english: "Leave space. A single note may need a room.", simplifiedChinese: "留出空间。一个音，也许需要一整个房间。"),
            famousWork: LocalizedCopy(english: "Gymnopedie No. 1", simplifiedChinese: "第一号吉诺佩蒂"),
            color: Color(red: 0.54, green: 0.56, blue: 0.46),
            portraitAssetName: nil,
            theme: MusicalTheme(title: LocalizedCopy(english: "Gymnopedie contour", simplifiedChinese: "吉诺佩蒂轮廓"), tempo: 60, notes: lyricalMotif)
        )
    ]
}
