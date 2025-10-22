//
//  mainpage.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 29/04/1447 AH.
//
import SwiftUI

struct MainPage: View {
    // Temporary mock data for UI only
    private let sampleEntries: [JournalEntryUI] = [
        .init(id: UUID(), title: "My Birthday", dateString: "02/09/2024", preview: lorem, isBookmarked: true),
        .init(id: UUID(), title: "Today’s Journal", dateString: "02/09/2024", preview: lorem, isBookmarked: false),
        .init(id: UUID(), title: "Great Day", dateString: "02/09/2024", preview: lorem, isBookmarked: false)
    ]

    // UI state (no business logic)
    @State private var showSortPopover = false
    @State private var showNewJournal = false

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

                        // Toolbar with Sort (left) and Add (right)
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
                                    .accessibilityLabel("Sort")
                            }

                            Button {
                                showNewJournal = true
                            } label: {
                                Image("add")
                                    .renderingMode(.original)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .accessibilityLabel("Add")
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

                    // Cards list
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(sampleEntries) { entry in
                                JournalCard(entry: entry)
                                    .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                                    // Swipe left to reveal red circular trash icon
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            // UI only – no delete logic yet
                                        } label: {
                                            Image("trash")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 22, height: 22)
                                                .padding(14)
                                                .background(Circle().fill(Color.red))
                                        }
                                        .tint(.clear) // keep our custom red circle & asset colors
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }

                    // Search bar placeholder
                    HStack(spacing: 12) {
                        Image("search")
                            .foregroundStyle(.secondary)

                        Text("Search")
                            .foregroundStyle(.secondary)

                        Spacer()

                        Image("mic")
                            .foregroundStyle(.secondary)
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

                // Sort popover – appears near the toolbar
                if showSortPopover {
                    VStack(alignment: .leading, spacing: 0) {
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showSortPopover = false
                            }
                        } label: {
                            HStack {
                                Text("Sort by Bookmark")
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                        }
                        Divider().background(Color.white.opacity(0.15))
                        Button {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                showSortPopover = false
                            }
                        } label: {
                            HStack {
                                Text("Sort by Entry Date")
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
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
                    .padding(.top, 72) // just below the toolbar
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            showSortPopover = false
                        }
                    }
                    .background(
                        Color.black.opacity(0.001)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                    showSortPopover = false
                                }
                            }
                    )
                }
            }
            // Navigation to a placeholder New Journal page (UI only)
            .navigationDestination(isPresented: $showNewJournal) {
                NewJournalPage()
            }
        }
    }
}

#Preview {
    MainPage()
}

// MARK: - UI Types used only for this screen (placeholder for now)

private struct JournalEntryUI: Identifiable {
    let id: UUID
    let title: String
    let dateString: String   // Display-only for now. Replace with Date later.
    let preview: String
    let isBookmarked: Bool
}

private let lorem =
"""
mock data
"""

private struct JournalCard: View {
    let entry: JournalEntryUI

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

                // Bookmark asset: "bookmark" / "nonbookmark"
                Image(entry.isBookmarked ? "bookmark" : "nonbookmark")
                    .renderingMode(.original)
            }

            Text(entry.preview)
                .foregroundStyle(.white)
                .font(.body)
                .multilineTextAlignment(.leading)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(white: 0.12))
                .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
        )
    }
}

// Simple placeholder destination for the Add action.
// Replace with your real new‑entry screen when ready.
private struct NewJournalPage: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("New Journal")
                .font(.title.bold())
                .foregroundStyle(.white)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
