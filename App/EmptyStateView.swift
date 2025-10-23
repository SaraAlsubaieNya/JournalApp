import SwiftUI

struct EmptyStateView: View {
    @SwiftUI.EnvironmentObject private var store: JournalStore

    @State private var showSortPopover = false
    @State private var showNewJournal = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack(alignment: .firstTextBaseline) {
                        Text("Journal")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)

                        Spacer()

                        HStack(spacing: 16) {
                            Button {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                    showSortPopover.toggle()
                                }
                            } label: {
                                Image("Sort")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                            }

                            Button {
                                showNewJournal = true
                            } label: {
                                Image("add")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
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

                    VStack(spacing: 16) {
                        Image("emptystatebook")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 302, height: 302)

                        Text("Begin Your Journal")
                            .font(.title2.bold())
                            .foregroundStyle(Color(red: 212/255, green: 200/255, blue: 255/255))

                        Text("Craft your personal diary, tap the\nplus icon to begin")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.9))
                            .font(.body)
                    }
                    .padding(.horizontal, 32)

                    Spacer()

                    // Search bar (disabled look)
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
                    // Popover UI kept for parity
                    VStack(alignment: .leading, spacing: 0) {
                        Button { withAnimation { showSortPopover = false } } label: {
                            HStack { Text("Sort by Bookmark"); Spacer() }
                                .padding(.vertical, 14).padding(.horizontal, 16)
                        }
                        Divider().background(Color.white.opacity(0.15))
                        Button { withAnimation { showSortPopover = false } } label: {
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
            .sheet(isPresented: $showNewJournal) {
                JournalEditorSheet(
                    mode: .new,
                    onSave: { entry in
                        store.add(title: entry.title, body: entry.body, date: entry.date)
                    },
                    onCancel: {}
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
                .background(Color.black.ignoresSafeArea())
            }
        }
    }
}

#Preview {
    EmptyStateView().environmentObject(JournalStore())
}
