import SwiftUI

struct RhythmGameView: View {
    let composer: Composer
    let language: AppLanguage

    @State private var taps = 0
    @State private var pulse = false
    @State private var completed = false
    @State private var feedbackKey = "start"
    @State private var expectedKeyIndex = 0

    private let targetTaps = 12
    private let speed = 5.4
    private let keys = PianoKey.playableKeys

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text(localized("Follow the staff", "跟着五线谱"))
                    .font(.headline)
                Spacer()
                Text("\(min(taps, targetTaps))/\(targetTaps)")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(composer.color)
            }

            VStack(spacing: 12) {
                ZStack {
                    FlowingStaffView(
                        composer: composer,
                        speed: speed,
                        pulse: pulse,
                        highlightedKey: keys[expectedKeyIndex]
                    )

                    VStack(spacing: 12) {
                        Text(feedbackText)
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)

                        Text(localized(
                            "Listen to \(composer.theme.title.text(for: language)), watch the note, then choose the matching key.",
                            "聆听\(composer.theme.title.text(for: language))，观察音符，然后点击对应琴键。"
                        ))
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(18)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(18)
                    .scaleEffect(pulse ? 1.035 : 1.0)
                    .animation(.spring(response: 0.22, dampingFraction: 0.72), value: pulse)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1.05, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(composer.color.opacity(0.22), lineWidth: 1)
                }

                PianoKeyboardView(
                    composer: composer,
                    language: language,
                    keys: keys,
                    expectedKey: keys[expectedKeyIndex],
                    onKeyTap: registerTap
                )
            }

            if completed {
                Text(localized("Great! Swipe left or right to meet another composer.", "太棒了！左右滑动，认识下一位音乐家。"))
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(composer.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ProgressView(value: Double(taps), total: Double(targetTaps))
                    .tint(composer.color)
            }
        }
        .padding(20)
        .onChange(of: composer) { _, _ in
            reset()
        }
    }

    private func registerTap(_ key: PianoKey) {
        guard !completed else { return }
        pulse.toggle()

        if key == keys[expectedKeyIndex] {
            taps += 1
            feedbackKey = "correct.\(taps % 4).\(key.name)"
            expectedKeyIndex = (expectedKeyIndex + 1) % keys.count
        } else {
            feedbackKey = "wrong.\(keys[expectedKeyIndex].name)"
        }

        if taps >= targetTaps {
            completed = true
            feedbackKey = "completed"
        }
    }

    private var feedbackText: String {
        if feedbackKey == "start" {
            return localized("Follow the staff and tap the piano keys", "跟着五线谱，点击钢琴键")
        }
        if feedbackKey == "completed" {
            return localized("You followed the melody.", "你跟上了旋律。")
        }
        if feedbackKey.hasPrefix("wrong.") {
            let key = feedbackKey.replacingOccurrences(of: "wrong.", with: "")
            return localized("Listen again. Try \(key).", "再听一次，试试 \(key)。")
        }
        let parts = feedbackKey.split(separator: ".")
        guard parts.count == 3 else {
            return localized("Beautiful timing", "节奏很美")
        }
        let step = String(parts[1])
        let key = String(parts[2])
        switch step {
        case "1": return localized("\(key) - clear tone", "\(key) - 清亮的音")
        case "2": return localized("\(key) - keep flowing", "\(key) - 继续流动")
        case "3": return localized("\(key) - listen forward", "\(key) - 向前聆听")
        default: return localized("\(key) - beautiful timing", "\(key) - 节奏很美")
        }
    }

    private func reset() {
        taps = 0
        completed = false
        feedbackKey = "start"
        expectedKeyIndex = 0
    }

    private func localized(_ english: String, _ simplifiedChinese: String) -> String {
        language == .english ? english : simplifiedChinese
    }
}

private struct FlowingStaffView: View {
    let composer: Composer
    let speed: Double
    let pulse: Bool
    let highlightedKey: PianoKey

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let staffTop = size.height * 0.30
                let spacing = size.height * 0.075
                let lineColor = composer.color.opacity(0.38)
                let time = timeline.date.timeIntervalSinceReferenceDate
                let offset = CGFloat((time.truncatingRemainder(dividingBy: speed)) / speed) * 92

                for index in 0..<5 {
                    var path = Path()
                    let y = staffTop + CGFloat(index) * spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(path, with: .color(lineColor), lineWidth: 2)
                }

                for index in 0..<14 {
                    let x = size.width - CGFloat(index) * 92 + offset
                    let keyOffset = (highlightedKey.staffPosition + index * 2) % 5
                    let y = staffTop + CGFloat(keyOffset) * spacing
                    let rect = CGRect(x: x, y: y - 12, width: 24, height: 18)
                    context.fill(Path(ellipseIn: rect), with: .color(composer.color.opacity(0.84)))

                    var stem = Path()
                    stem.move(to: CGPoint(x: x + 22, y: y - 4))
                    stem.addLine(to: CGPoint(x: x + 22, y: y - 56))
                    context.stroke(stem, with: .color(composer.color.opacity(0.72)), lineWidth: 3)
                }

                if pulse {
                    let ring = CGRect(
                        x: size.width / 2 - 58,
                        y: size.height / 2 - 58,
                        width: 116,
                        height: 116
                    )
                    context.stroke(Path(ellipseIn: ring), with: .color(composer.color.opacity(0.32)), lineWidth: 10)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color.white.opacity(0.74),
                    composer.color.opacity(0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

private struct PianoKeyboardView: View {
    let composer: Composer
    let language: AppLanguage
    let keys: [PianoKey]
    let expectedKey: PianoKey
    let onKeyTap: (PianoKey) -> Void

    @Namespace private var petNamespace

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(language == .english ? "Piano keys" : "钢琴键")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                ForEach(keys) { key in
                    Button {
                        onKeyTap(key)
                    } label: {
                        VStack(spacing: 5) {
                            ZStack {
                                if key == expectedKey {
                                    DinoPetView(color: composer.color)
                                        .matchedGeometryEffect(id: "music-pet", in: petNamespace)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .frame(height: 34)

                            Text(key.name)
                                .font(.caption.weight(.bold))
                            Circle()
                                .fill(key == expectedKey ? composer.color : Color.clear)
                                .frame(width: 7, height: 7)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: key.isSharp ? 82 : 104)
                        .foregroundStyle(key.isSharp ? .white : .primary)
                        .background(key.isSharp ? Color.black : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                        .overlay {
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(key == expectedKey ? composer.color : Color.black.opacity(0.12), lineWidth: key == expectedKey ? 2 : 1)
                        }
                        .shadow(color: key == expectedKey ? composer.color.opacity(0.26) : .black.opacity(0.08), radius: 5, y: 2)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Piano key \(key.name)")
                }
            }
            .animation(.spring(response: 0.34, dampingFraction: 0.72), value: expectedKey)
        }
    }
}

private struct DinoPetView: View {
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: 34, height: 26)
                .overlay(alignment: .top) {
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { _ in
                            Triangle()
                                .fill(color.opacity(0.92))
                                .frame(width: 8, height: 7)
                        }
                    }
                    .offset(y: -6)
                }

            Circle()
                .fill(.white.opacity(0.92))
                .frame(width: 5, height: 5)
                .offset(x: -7, y: -3)

            Circle()
                .fill(.white.opacity(0.92))
                .frame(width: 5, height: 5)
                .offset(x: 5, y: -3)

            Capsule()
                .fill(.white.opacity(0.88))
                .frame(width: 12, height: 3)
                .offset(x: -1, y: 7)

            Text("♪")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .offset(x: 22, y: -18)
        }
        .shadow(color: color.opacity(0.34), radius: 8, y: 4)
        .accessibilityHidden(true)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct PianoKey: Identifiable, Equatable {
    let id: String
    let name: String
    let isSharp: Bool
    let staffPosition: Int

    static let playableKeys = [
        PianoKey(id: "c", name: "C", isSharp: false, staffPosition: 4),
        PianoKey(id: "d", name: "D", isSharp: false, staffPosition: 3),
        PianoKey(id: "e", name: "E", isSharp: false, staffPosition: 2),
        PianoKey(id: "f", name: "F", isSharp: false, staffPosition: 1),
        PianoKey(id: "g", name: "G", isSharp: false, staffPosition: 0),
        PianoKey(id: "a", name: "A", isSharp: false, staffPosition: 1),
        PianoKey(id: "b", name: "B", isSharp: false, staffPosition: 2)
    ]
}
