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
    let portraitAssetName: String
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
        )
    ]
}
