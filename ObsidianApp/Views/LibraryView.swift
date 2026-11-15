import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
    @EnvironmentObject private var library: LibraryStore
    @EnvironmentObject private var player: PlayerEngine
    @State private var importing = false

    var body: some View {
        List {
            if library.tracks.isEmpty {
                ContentUnavailableView(
                    "No music yet",
                    systemImage: "music.note",
                    description: Text("Import audio files to get started.")
                )
            } else {
                ForEach(library.tracks) { track in
                    Button {
                        player.play(track, in: library.tracks)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(track.title).foregroundStyle(.primary)
                                Text(track.artist).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(Self.time(track.duration))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { importing = true } label: { Image(systemName: "plus") }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button { library.refresh() } label: { Image(systemName: "arrow.clockwise") }
            }
        }
        .fileImporter(
            isPresented: $importing,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: true
        ) { result in
            guard case .success(let urls) = result else { return }
            for url in urls {
                let destination = library.documents.appendingPathComponent(url.lastPathComponent)
                _ = url.startAccessingSecurityScopedResource()
                try? FileManager.default.copyItem(at: url, to: destination)
                url.stopAccessingSecurityScopedResource()
            }
            library.refresh()
        }
    }

    static func time(_ seconds: TimeInterval) -> String {
        guard seconds.isFinite, seconds > 0 else { return "--:--" }
        let total = Int(seconds.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
}
