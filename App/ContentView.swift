//
//  ContentView.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 28/04/1447 AH.
//

import SwiftUI

struct SplashScreen: View {
    @State private var showEmptyState = false
    private let appName = "Journali"

    var body: some View {
        Group {
            if showEmptyState {
                //Land on EmptyState after 2 seconds
                EmptyState()
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
                    //Show splash for 2 seconds
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

#Preview {
    SplashScreen()
}
