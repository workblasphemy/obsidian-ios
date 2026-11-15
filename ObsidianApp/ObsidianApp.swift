import SwiftUI

@main
struct ObsidianApp: App {
    @StateObject private var player = PlayerEngine()
    @StateObject private var library = LibraryStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(player)
                .environmentObject(library)
                .preferredColorScheme(.dark)
        }
    }
}
