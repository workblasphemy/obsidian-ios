import SwiftUI

struct RootView: View {
    @EnvironmentObject private var library: LibraryStore
    @EnvironmentObject private var player: PlayerEngine
    @State private var showPlayer = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                LibraryView()
                    .navigationTitle("Library")
            }
            if player.current != nil {
                MiniPlayer { showPlayer = true }
            }
        }
        .sheet(isPresented: $showPlayer) {
            NowPlayingView()
                .environmentObject(player)
        }
        .task { library.refresh() }
    }
}
