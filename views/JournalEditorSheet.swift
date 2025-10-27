import SwiftUI

enum EditorPresentation: Identifiable, Equatable {
    case new
    case edit(JournalEntry)

    var id: String {
        switch self {
        case .new: return "new"
        case .edit(let e): return e.id.uuidString
        }
    }
}

struct JournalEditorSheet: View {
    let mode: EditorPresentation
    var onSave: (JournalEntry) -> Void
    var onCancel: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var bodyText: String = ""
    @State private var date: Date = .now
    @State private var isDirty: Bool = false
    @State private var showDiscardDialog = false

    @FocusState private var focusedField: Field?
    private enum Field { case title, body }

    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        bodyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var dateString: String {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: date)
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.black.ignoresSafeArea()

            // Rounded card content (no purple leading line)
            VStack {
                Spacer(minLength: 8)
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
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

            // Floating top controls
            HStack {
                Button {
                    if isDirty && (!title.isEmpty || !bodyText.isEmpty) {
                        showDiscardDialog = true
                    } else {
                        dismiss()
                        onCancel()
                    }
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
                    let entry: JournalEntry
                    switch mode {
                    case .new:
                        entry = JournalEntry(id: UUID(),
                                             title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                             body: bodyText.trimmingCharacters(in: .whitespacesAndNewlines),
                                             date: date,
                                             isBookmarked: false)
                    case .edit(let original):
                        entry = JournalEntry(id: original.id,
                                             title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                             body: bodyText.trimmingCharacters(in: .whitespacesAndNewlines),
                                             date: date,
                                             isBookmarked: original.isBookmarked)
                    }
                    onSave(entry)
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
                .disabled(isSaveDisabled)
                .opacity(isSaveDisabled ? 0.6 : 1)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .onAppear {
            switch mode {
            case .new:
                title = ""
                bodyText = ""
                date = .now
            case .edit(let e):
                title = e.title
                bodyText = e.body
                date = e.date
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                focusedField = .title
            }
        }
        .onChange(of: title) { _ in isDirty = true }
        .onChange(of: bodyText) { _ in isDirty = true }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
                    .foregroundStyle(Color(.systemIndigo))
            }
        }
        .confirmationDialog(
            "Are you sure you want to discard changes on this journal?",
            isPresented: $showDiscardDialog,
            titleVisibility: .visible
        ) {
            Button("Discard Changes", role: .destructive) {
                dismiss()
                onCancel()
            }
            Button("Keep Editing", role: .cancel) {}
        }
    }
}
