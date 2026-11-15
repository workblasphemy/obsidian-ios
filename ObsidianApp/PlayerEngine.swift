import AVFoundation
import Combine
import Foundation

/// Queue plus AVPlayer. One player instance for the whole app so playback survives navigation.
@MainActor
final class PlayerEngine: ObservableObject {
    @Published private(set) var queue: [Track] = []
    @Published private(set) var index: Int = 0
    @Published private(set) var isPlaying = false
    @Published private(set) var position: TimeInterval = 0
    @Published var repeatAll = true

    private let player = AVPlayer()
    private var timeObserver: Any?
    private var endObserver: NSObjectProtocol?

    var current: Track? {
        guard queue.indices.contains(index) else { return nil }
        return queue[index]
    }

    init() {
        timeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            Task { @MainActor in self?.position = time.seconds }
        }
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.advance() }
        }
    }

    deinit {
        if let timeObserver { player.removeTimeObserver(timeObserver) }
        if let endObserver { NotificationCenter.default.removeObserver(endObserver) }
    }

    func play(_ track: Track, in tracks: [Track]) {
        queue = tracks
        index = tracks.firstIndex(of: track) ?? 0
        loadCurrent(autoplay: true)
    }

    func toggle() {
        guard current != nil else { return }
        if isPlaying { player.pause() } else { player.play() }
        isPlaying.toggle()
    }

    func next() {
        guard !queue.isEmpty else { return }
        index = (index + 1) % queue.count
        loadCurrent(autoplay: true)
    }

    func previous() {
        guard !queue.isEmpty else { return }
        if position > 3 {
            seek(0)
            return
        }
        index = (index - 1 + queue.count) % queue.count
        loadCurrent(autoplay: true)
    }

    func seek(_ seconds: TimeInterval) {
        player.seek(to: CMTime(seconds: seconds, preferredTimescale: 600))
        position = seconds
    }

    private func loadCurrent(autoplay: Bool) {
        guard let track = current else { return }
        let item = AVPlayerItem(url: track.url)
        player.replaceCurrentItem(with: item)
        position = 0
        if autoplay {
            player.play()
            isPlaying = true
        }
    }

    private func advance() {
        if index == queue.count - 1 && !repeatAll {
            player.pause()
            isPlaying = false
            return
        }
        next()
    }
}
