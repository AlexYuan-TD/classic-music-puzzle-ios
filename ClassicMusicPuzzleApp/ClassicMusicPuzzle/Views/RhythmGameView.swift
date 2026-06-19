import SwiftUI

struct RhythmGameView: View {
    let composer: Composer
    let level: Int
    let onReplay: () -> Void
    let onNext: () -> Void

    @State private var taps = 0
    @State private var pulse = false
    @State private var completed = false
    @State private var feedback = "Follow the staff and tap the piano keys"
    @State private var expectedKeyIndex = 0

    private var targetTaps: Int { [12, 18, 24][level - 1] }
    private var speed: Double { [7.0, 5.5, 4.2][level - 1] }
    private let keys = PianoKey.playableKeys

    var body: some View {
        VStack(spacing: 18) {
            HStack {
                Text("Level \(level) - Follow the rhythm")
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
                        Text(feedback)
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.primary)

                        Text("Listen to \(composer.theme.title), watch the note, then choose the matching key.")
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
                    keys: keys,
                    expectedKey: keys[expectedKeyIndex],
                    onKeyTap: registerTap
                )
            }

            if completed {
                CompletionBar(onStay: {}, onReplay: reset, onNext: next)
            } else {
                ProgressView(value: Double(taps), total: Double(targetTaps))
                    .tint(composer.color)
            }
        }
        .padding(20)
        .onChange(of: composer) { _, _ in
            reset()
        }
        .onChange(of: level) { _, _ in
            reset()
        }
    }

    private func registerTap(_ key: PianoKey) {
        guard !completed else { return }
        pulse.toggle()

        if key == keys[expectedKeyIndex] {
            taps += 1
            feedback = tapFeedback(for: key)
            expectedKeyIndex = (expectedKeyIndex + 1) % keys.count
        } else {
            feedback = "Listen again. Try \(keys[expectedKeyIndex].name)."
        }

        if taps >= targetTaps {
            completed = true
            feedback = "You followed the melody."
        }
    }

    private func tapFeedback(for key: PianoKey) -> String {
        switch taps % 4 {
        case 1: return "\(key.name) - clear tone"
        case 2: return "\(key.name) - keep flowing"
        case 3: return "\(key.name) - listen forward"
        default: return "\(key.name) - beautiful timing"
        }
    }

    private func reset() {
        taps = 0
        completed = false
        feedback = "Follow the staff and tap the piano keys"
        expectedKeyIndex = 0
        onReplay()
    }

    private func next() {
        reset()
        onNext()
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
    let keys: [PianoKey]
    let expectedKey: PianoKey
    let onKeyTap: (PianoKey) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Piano keys")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                ForEach(keys) { key in
                    Button {
                        onKeyTap(key)
                    } label: {
                        VStack(spacing: 5) {
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
        }
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
