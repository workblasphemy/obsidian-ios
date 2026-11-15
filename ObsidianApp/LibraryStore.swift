import AVFoundation
import Combine
import Foundation

/// Scans the app's Documents folder for audio the user dropped in via the Files app or the importer.
@MainActor
final class LibraryStore: ObservableObject {
    @Published private(set) var tracks: [Track] = []
    @Published private(set) var isScanning = false

    private let audioExtensions: Set<String> = ["mp3", "m4a", "aac", "wav", "flac", "aiff", "alac"]

    var documents: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func refresh() {
        isScanning = true
        let found = Self.scan(documents, extensions: audioExtensions)
        tracks = found
        isScanning = false
    }

    private static func scan(_ root: URL, extensions: Set<String>) -> [Track] {
        let keys: [URLResourceKey] = [.isRegularFileKey, .contentModificationDateKey]
        guard let walker = FileManager.default.enumerator(
            at: root,
            includingPropertiesForKeys: keys,
            options: [.skipsHiddenFiles]
        ) else { return [] }

        var result: [Track] = []
        for case let url as URL in walker {
            guard extensions.contains(url.pathExtension.lowercased()) else { continue }
            result.append(makeTrack(url))
        }
        return result.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    private static func makeTrack(_ url: URL) -> Track {
        let asset = AVURLAsset(url: url)
        let seconds = CMTimeGetSeconds(asset.duration)
        let title = (try? url.resourceValues(forKeys: [.nameKey]).name)
            ?? url.deletingPathExtension().lastPathComponent
        return Track(
            id: url.path,
            url: url,
            title: title,
            artist: "Unknown artist",
            duration: seconds.isFinite ? seconds : 0
        )
    }
}
