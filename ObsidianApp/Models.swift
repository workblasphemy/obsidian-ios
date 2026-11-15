import Foundation

struct Track: Identifiable, Equatable {
    let id: String
    let url: URL
    let title: String
    let artist: String
    let duration: TimeInterval

    static func == (lhs: Track, rhs: Track) -> Bool { lhs.id == rhs.id }
}
