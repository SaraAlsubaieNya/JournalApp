//
//  emptystate.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 28/04/1447 AH.
//
import SwiftUI

struct EmptyState: View {
    // Match MainPage toolbar behavior
    @State private var showSortPopover = false
    @State private var showNewJournal = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {

                    //Header copied from MainPage (same styles and actions)
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

                    VStack(spacing: 16) {
                        Image("emptystatebook")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 302, height: 302)
                            .foregroundStyle(Color(.systemIndigo))

                        Text("Begin Your Journal")
                            .font(.title2.bold())
                            .foregroundStyle(
                                Color(red: 212.0/255.0, green: 200.0/255.0, blue: 255.0/255.0, opacity: 1.0)
                            )

                        Text("Craft your personal diary, tap the\nplus icon to begin")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.9))
                            .font(.body)
                    }
                    .padding(.horizontal, 32)

                    Spacer()

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

                //Sort popover (same look/behavior as MainPage)
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
                    .padding(.top, 72)
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
            // Present the same card-style new journal sheet used on MainPage
            .sheet(isPresented: $showNewJournal) {
                // Reuse the same sheet UI you preferred
                CardNewJournal {
                    showNewJournal = false
                } onCancel: {
                    showNewJournal = false
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
                .background(Color.black.ignoresSafeArea())
            }
        }
    }
}

#Preview {
    EmptyState()
}

// MARK: - Card New Journal Sheet (same as in MainPage)

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

            VStack {
                Spacer(minLength: 8)
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
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
            .padding(.top, 64)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(white: 0.12))
                    .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 12)
            .padding(.top, 24)

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

                Button(action: onSave) {
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
