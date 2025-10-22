//
//  mainpage.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 29/04/1447 AH.
//
import SwiftUI

struct MainPage: View {
    //Temporary mock data
    private let sampleEntries: [JournalEntryUI] = [
        .init(id: UUID(), title: "My Birthday", dateString: "02/09/2024", preview: lorem, isBookmarked: true),
        .init(id: UUID(), title: "Today’s Journal", dateString: "02/09/2024", preview: lorem, isBookmarked: false),
        .init(id: UUID(), title: "Great Day", dateString: "02/09/2024", preview: lorem, isBookmarked: false)
    ]

    // UI state
    @State private var showSortPopover = false
    @State private var showNewJournal = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    //Header
                    HStack(alignment: .firstTextBaseline) {
                        Text("Journal")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)

                        Spacer()

                        //Toolbar
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

                    //Cards list
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(sampleEntries) { entry in
                                JournalCard(entry: entry)
                                    .contentShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                                    //Swipe left
                                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                        Button {
                                            
                                        } label: {
                                            Image("trash")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 22, height: 22)
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

                    //Search bar
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

                //Sort popover
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
                    .padding(.top, 72) //just below the toolbar
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
            //New Journal
            .sheet(isPresented: $showNewJournal) {
                CardNewJournal {
                    //Save action callback — connect to your store later
                    showNewJournal = false
                } onCancel: {
                    showNewJournal = false
                }
                .presentationDetents([.large]) // full height feel, but still a sheet
                .presentationDragIndicator(.hidden)
                .background(Color.black.ignoresSafeArea())
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

// MARK: - Card New Journal Sheet (UI only)

private struct CardNewJournal: View {
    var onSave: () -> Void
    var onCancel: () -> Void

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @FocusState private var focusedField: Field?

    private enum Field { case title, body }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: Date())
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            // The rounded card
            VStack {
                Spacer(minLength: 8)
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Title with purple leading bar (as in the screenshot)
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Rectangle()
                                .fill(Color(.systemIndigo))
                                .frame(width: 3, height: 28)
                                .cornerRadius(1.5)

                            TextField("Title", text: $title, axis: .vertical)
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundStyle(Color(red: 212/255, green: 200/255, blue: 255/255))
                                .tint(Color(.systemIndigo))
                                .focused($focusedField, equals: .title)
                                .submitLabel(.next)
                                .onSubmit { focusedField = .body }
                        }

                        Text(dateString)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))

                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $bodyText)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 220, alignment: .topLeading)
                                .font(.body)
                                .foregroundStyle(.white)
                                .tint(Color(.systemIndigo))
                                .focused($focusedField, equals: .body)
                                .padding(.top, 6)

                            if bodyText.isEmpty {
                                Text("Type your Journal...")
                                    .foregroundStyle(.white.opacity(0.35))
                                    .padding(.top, 12)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
                    .padding(20)
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 64) //space for floating buttons
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(white: 0.12))
                    .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 12)
            .padding(.top, 24)

            //Floating controls
            HStack {
                Button(action: onCancel) {
                    Circle()
                        .fill(Color(white: 0.12))
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)
                }

                Spacer()

                Button {
                    onSave()
                } label: {
                    Circle()
                        .fill(Color(.systemIndigo))
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black.opacity(0.9))
                        )
                        .frame(width: 40, height: 40)
                        .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 8)
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                          bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(title.isEmpty && bodyText.isEmpty ? 0.6 : 1)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                focusedField = .title
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
                    .foregroundStyle(Color(.systemIndigo))
            }
        }
    }
}
