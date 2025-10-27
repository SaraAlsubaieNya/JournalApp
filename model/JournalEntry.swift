import Foundation

struct JournalEntry: Identifiable, Equatable {
    let id: UUID
    var title: String
    var body: String
    var date: Date
    var isBookmarked: Bool

    var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }

    static func makeDate(_ d: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.date(from: d) ?? .now
    }
}
