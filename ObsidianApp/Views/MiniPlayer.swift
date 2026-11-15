import SwiftUI

struct MiniPlayer: View {
    @EnvironmentObject private var player: PlayerEngine
    let onOpen: () -> Void

    var body: some View {
        if let track = player.current {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 44, height: 44)
                    .overlay(Image(systemName: "music.note").foregroundStyle(.secondary))
                VStack(alignment: .leading, spacing: 2) {
                    Text(track.title).lineLimit(1)
                    Text(track.artist).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                }
                Spacer()
                Button { player.toggle() } label: {
                    Image(systemName: player.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title3)
                }
            }
            .padding(10)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
            .onTapGesture(perform: onOpen)
        }
    }
}
