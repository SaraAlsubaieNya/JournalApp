import Foundation
import SwiftUI
import Combine

@MainActor
final class JournalStore: SwiftUI.ObservableObject {
    @SwiftUI.Published private(set) var entries: [JournalEntry] = []

    var isEmpty: Bool { entries.isEmpty }

    init() {}

    // Demo data if you need it
    func seedDemo() {
        entries = [
            .init(id: UUID(), title: "My Birthday", body: lorem, date: JournalEntry.makeDate("02/09/2024"), isBookmarked: true),
            .init(id: UUID(), title: "Today’s Journal", body: lorem, date: JournalEntry.makeDate("02/09/2024"), isBookmarked: false),
            .init(id: UUID(), title: "Great Day", body: lorem, date: JournalEntry.makeDate("02/09/2024"), isBookmarked: false)
        ]
    }

    func add(title: String, body: String, date: Date) {
        let new = JournalEntry(id: UUID(), title: title, body: body, date: date, isBookmarked: false)
        entries.insert(new, at: 0)
    }

    func update(_ entry: JournalEntry) {
        guard let idx = entries.firstIndex(where: { $0.id == entry.id }) else { return }
        entries[idx] = entry
    }

    func delete(id: UUID) {
        entries.removeAll { $0.id == id }
    }

    func toggleBookmark(id: UUID) {
        guard let idx = entries.firstIndex(where: { $0.id == id }) else { return }
        entries[idx].isBookmarked.toggle()
    }

    // Sorting helpers so views don’t mutate entries directly
    func sortByBookmark() {
        entries.sort { (a, b) in
            if a.isBookmarked == b.isBookmarked {
                return a.date > b.date
            }
            return a.isBookmarked && !b.isBookmarked
        }
    }

    func sortByDateDescending() {
        entries.sort { $0.date > $1.date }
    }
}

// Shared lorem used in demo seeds
let lorem =
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh viverra non semper suscipit posuere.
"""
