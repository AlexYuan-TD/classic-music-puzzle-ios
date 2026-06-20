import AVFoundation
import Foundation

final class ThemePlayer: ObservableObject {
    @Published private(set) var isPlaying = false

    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode!
    private let frequencyLock = NSLock()
    private var phase = 0.0
    private var currentFrequency = 0.0
    private var noteSampleAge = 0.0
    private var playbackTask: Task<Void, Never>?

    init() {
        sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self else { return noErr }
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let sampleRate = 44_100.0

            self.frequencyLock.lock()
            defer { self.frequencyLock.unlock() }
            for frame in 0..<Int(frameCount) {
                let frequency = self.currentFrequency
                let sample: Float
                if frequency == 0 {
                    sample = 0
                } else {
                    let age = self.noteSampleAge / sampleRate
                    let attack = min(1.0, age / 0.012)
                    let decay = exp(-age * 2.7)
                    let envelope = attack * decay
                    let tone =
                        sin(self.phase) * 0.72 +
                        sin(self.phase * 2.0) * 0.20 +
                        sin(self.phase * 3.0) * 0.08
                    sample = Float(tone * envelope * 0.18)

                    self.phase += 2.0 * .pi * frequency / sampleRate
                    self.noteSampleAge += 1
                    if self.phase > 2.0 * .pi {
                        self.phase -= 2.0 * .pi
                    }
                }
                for buffer in ablPointer {
                    let pointer = buffer.mData?.assumingMemoryBound(to: Float.self)
                    pointer?[frame] = sample
                }
            }
            return noErr
        }

        engine.attach(sourceNode)
        let format = AVAudioFormat(standardFormatWithSampleRate: 44_100, channels: 1)
        engine.connect(sourceNode, to: engine.mainMixerNode, format: format)
    }

    @MainActor
    func play(theme: MusicalTheme) {
        stop()
        isPlaying = true

        playbackTask = Task { [weak self] in
            guard let self else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                if !engine.isRunning {
                    try engine.start()
                }
            } catch {
                await MainActor.run {
                    self.isPlaying = false
                }
                return
            }

            while !Task.isCancelled {
                for note in theme.notes {
                    if Task.isCancelled { break }
                    self.setFrequency(note.frequency)
                    let seconds = 60.0 / theme.tempo * note.beats
                    try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                }
            }
        }
    }

    @MainActor
    func stop() {
        playbackTask?.cancel()
        playbackTask = nil
        setFrequency(0)
        isPlaying = false
    }

    private func setFrequency(_ frequency: Double) {
        frequencyLock.lock()
        currentFrequency = frequency
        noteSampleAge = 0
        phase = 0
        frequencyLock.unlock()
    }
}
