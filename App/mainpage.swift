import SwiftUI

struct MainPage: View {
    @SwiftUI.EnvironmentObject private var store: JournalStore

    @State private var showSortPopover = false
    @State private var sheetMode: EditorPresentation? = nil
    @State private var pendingDelete: JournalEntry? = nil
    @State private var showDeleteDialog = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack(alignment: .firstTextBaseline) {
                        Text("Journal")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)

                        Spacer()

                        HStack(spacing: 16) {
                            Button { withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) { showSortPopover.toggle() } } label: {
                                Image("Sort").renderingMode(.original).resizable().scaledToFit().frame(width: 20, height: 20)
                            }
                            Button { sheetMode = .new } label: {
                                Image("add").renderingMode(.original).resizable().scaledToFit().frame(width: 20, height: 20)
                            }
                        }
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color(white: 0.1))
                                .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)
                        )
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                    Spacer(minLength: 24)

                    // List of cards
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(store.entries) { entry in
                                Button { sheetMode = .edit(entry) } label: {
                                    JournalCard(entry: entry)
                                        .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                                }
                                .buttonStyle(.plain)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button {
                                        pendingDelete = entry
                                        showDeleteDialog = true
                                    } label: {
                                        Image("trash").resizable().scaledToFit().frame(width: 22, height: 22)
                                            .padding(14)
                                            .background(Circle().fill(Color.red))
                                    }
                                    .tint(.clear)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }

                    // Search bar
                    HStack(spacing: 12) {
                        Image("search").foregroundStyle(.secondary)
                        Text("Search").foregroundStyle(.secondary)
                        Spacer()
                        Image("mic").foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .fill(Color(white: 0.12))
                            .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }

                if showSortPopover {
                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showSortPopover = false
                                store.sortByBookmark()
                            }
                        } label: {
                            HStack { Text("Sort by Bookmark"); Spacer() }
                                .padding(.vertical, 14).padding(.horizontal, 16)
                        }
                        Divider().background(Color.white.opacity(0.15))
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showSortPopover = false
                                store.sortByDateDescending()
                            }
                        } label: {
                            HStack { Text("Sort by Entry Date"); Spacer() }
                                .padding(.vertical, 14).padding(.horizontal, 16)
                        }
                    }
                    .font(.body)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(Color(white: 0.1))
                            .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)
                    )
                    .padding(.trailing, 20)
                    .padding(.top, 72)
                }
            }
            .sheet(item: $sheetMode) { mode in
                JournalEditorSheet(
                    mode: mode,
                    onSave: { updated in
                        switch mode {
                        case .new:
                            store.add(title: updated.title, body: updated.body, date: updated.date)
                        case .edit:
                            store.update(updated)
                        }
                    },
                    onCancel: {}
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
                .background(Color.black.ignoresSafeArea())
            }
            .confirmationDialog("Delete Journal?", isPresented: $showDeleteDialog, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let id = pendingDelete?.id {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            store.delete(id: id)
                        }
                    }
                    pendingDelete = nil
                }
                Button("Cancel", role: .cancel) { pendingDelete = nil }
            } message: {
                Text("Are you sure you want to delete this journal?")
            }
        }
    }
}

// Card UI
private struct JournalCard: View {
    let entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(entry.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color(red: 212/255, green: 200/255, blue: 255/255))
                    Text(entry.dateString)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }
                Spacer()
                Image(entry.isBookmarked ? "bookmark" : "nonbookmark")
                    .renderingMode(.original)
            }

            Text(entry.body)
                .foregroundStyle(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
                .lineLimit(5)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(white: 0.12))
                .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
        )
    }
}
