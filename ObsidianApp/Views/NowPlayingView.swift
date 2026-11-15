import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var player: PlayerEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Capsule().fill(.secondary).frame(width: 40, height: 5).padding(.top, 8)

            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.06))
                .overlay(Image(systemName: "music.note").font(.system(size: 48)).foregroundStyle(.secondary))
                .padding(.horizontal, 32)

            VStack(spacing: 4) {
                Text(player.current?.title ?? "Nothing playing").font(.title3).bold().lineLimit(1)
                Text(player.current?.artist ?? "").foregroundStyle(.secondary).lineLimit(1)
            }

            Slider(
                value: Binding(
                    get: { player.position },
                    set: { player.seek($0) }
                ),
                in: 0...max(player.current?.duration ?? 1, 1)
            )
            .padding(.horizontal, 32)

            HStack(spacing: 40) {
                Button { player.previous() } label: { Image(systemName: "backward.fill") }
                Button { player.toggle() } label: {
                    Image(systemName: player.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 64))
                }
                Button { player.next() } label: { Image(systemName: "forward.fill") }
            }
            .font(.title2)

            Spacer()
            Button("Close") { dismiss() }.padding(.bottom, 20)
        }
    }
}
