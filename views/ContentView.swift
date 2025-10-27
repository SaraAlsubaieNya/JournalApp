import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject private var store: JournalStore
    @State private var showEmptyState = false
    private let appName = "Journali"

    var body: some View {
        Group {
            if showEmptyState {
                RootRouter()
                    .transition(.opacity)
            } else {
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack {
                        Image("url@4x")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .padding()
                        Text(appName)
                            .foregroundStyle(.white)
                            .font(Font.custom("SFPro-Black", size: 42))
                            .bold()
                        Text("Your thoughts, your story")
                            .foregroundStyle(.white.opacity(0.9))
                            .font(Font.custom("SFPro-Light", size: 18))
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showEmptyState = true
                        }
                    }
                }
            }
        }
    }
}

//Decides EmptyState vs MainPage based on store
private struct RootRouter: View {
    @EnvironmentObject private var store: JournalStore

    var body: some View {
        if store.isEmpty {
            EmptyStateView()
        } else {
            MainPage()
        }
    }
}
