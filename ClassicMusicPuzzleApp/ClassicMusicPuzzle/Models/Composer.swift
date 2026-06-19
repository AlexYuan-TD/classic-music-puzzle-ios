import Foundation
import SwiftUI

struct Composer: Identifiable, Equatable {
    let id: String
    let name: String
    let years: String
    let country: String
    let introduction: String
    let inspiration: String
    let famousWork: String
    let color: Color
    let portraitAssetName: String
    let theme: MusicalTheme
}

struct MusicalTheme: Equatable {
    let title: String
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
            name: "Ludwig van Beethoven",
            years: "1770-1827",
            country: "Germany",
            introduction: "Beethoven turned struggle into sound, giving classical form a more human, storm-lit voice.",
            inspiration: "Begin again with courage. Even silence can become music.",
            famousWork: "Symphony No. 5",
            color: Color(red: 0.72, green: 0.16, blue: 0.15),
            portraitAssetName: "PortraitBeethoven",
            theme: MusicalTheme(
                title: "Symphony No. 5 motif",
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
            name: "Wolfgang Amadeus Mozart",
            years: "1756-1791",
            country: "Austria",
            introduction: "Mozart made clarity feel effortless, filling simple shapes with wit, grace, and surprise.",
            inspiration: "Let lightness be serious. Joy can be a discipline.",
            famousWork: "Eine kleine Nachtmusik",
            color: Color(red: 0.10, green: 0.42, blue: 0.66),
            portraitAssetName: "PortraitMozart",
            theme: MusicalTheme(
                title: "Eine kleine Nachtmusik opening",
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
            name: "Johann Sebastian Bach",
            years: "1685-1750",
            country: "Germany",
            introduction: "Bach built musical cathedrals from pattern, patience, and spiritual intensity.",
            inspiration: "Small steps can hold a universe when they move with care.",
            famousWork: "Cello Suite No. 1",
            color: Color(red: 0.22, green: 0.45, blue: 0.30),
            portraitAssetName: "PortraitBach",
            theme: MusicalTheme(
                title: "Cello Suite No. 1 prelude shape",
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
            name: "Frederic Chopin",
            years: "1810-1849",
            country: "Poland",
            introduction: "Chopin made the piano speak privately, as if a room could remember every feeling.",
            inspiration: "Softness is not weakness. It is precision with a heartbeat.",
            famousWork: "Nocturne Op. 9 No. 2",
            color: Color(red: 0.49, green: 0.28, blue: 0.58),
            portraitAssetName: "PortraitChopin",
            theme: MusicalTheme(
                title: "Nocturne Op. 9 No. 2 contour",
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
