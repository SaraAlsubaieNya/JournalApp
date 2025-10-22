//
//  newjournal.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 29/04/1447 AH.
//

import SwiftUI

struct newjournal: View {
    // Outgoing callback so MainPage (or a future store) can receive the entry
    var onSave: ((String, String, Date) -> Void)? = nil

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @FocusState private var focusedField: Field?

    private enum Field {
        case title, body
    }

    private var today: Date { Date() }
    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: today)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            // Card container
            VStack {
                Spacer(minLength: 8)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Title only (purple line removed)
                        TextField("Title", text: $title, axis: .vertical)
                            .font(.system(size: 28, weight: .heavy))
                            .foregroundStyle(Color(red: 212/255, green: 200/255, blue: 255/255))
                            .tint(Color(.systemIndigo))
                            .focused($focusedField, equals: .title)
                            .submitLabel(.next)
                            .onSubmit { focusedField = .body }

                        Text(dateString)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))

                        // Body editor with placeholder
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
            .padding(.top, 64) // leave room for the floating buttons
            .background(
                // The card shape
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(white: 0.12))
                    .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 10)
            )
            .padding(.horizontal, 12)
            .padding(.top, 24)

            // Top controls (floating, outside the card)
            HStack {
                Button {
                    dismiss()
                } label: {
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
                    let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                    let trimmedBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines)
                    onSave?(trimmedTitle, trimmedBody, today)
                    dismiss()
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
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
                    .foregroundStyle(Color(.systemIndigo))
            }
        }
        .onAppear {
            // Auto-focus title on appear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                focusedField = .title
            }
        }
    }
}

#Preview {
    NavigationStack {
        newjournal()
    }
}
