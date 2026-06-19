import AVFoundation
import Foundation

final class ThemePlayer: ObservableObject {
    @Published private(set) var isPlaying = false

    private let engine = AVAudioEngine()
    private var sourceNode: AVAudioSourceNode!
    private let frequencyLock = NSLock()
    private var phase = 0.0
    private var currentFrequency = 0.0
    private var playbackTask: Task<Void, Never>?

    init() {
        sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self else { return noErr }
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let sampleRate = 44_100.0
            let frequency = self.frequency()
            let amplitude = frequency == 0 ? 0.0 : 0.14

            for frame in 0..<Int(frameCount) {
                let sample = Float(sin(self.phase) * amplitude)
                self.phase += 2.0 * .pi * frequency / sampleRate
                if self.phase > 2.0 * .pi {
                    self.phase -= 2.0 * .pi
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

    private func frequency() -> Double {
        frequencyLock.lock()
        defer { frequencyLock.unlock() }
        return currentFrequency
    }

    private func setFrequency(_ frequency: Double) {
        frequencyLock.lock()
        currentFrequency = frequency
        frequencyLock.unlock()
    }
}
