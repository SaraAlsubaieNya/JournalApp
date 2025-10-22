//
//  ContentView.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 28/04/1447 AH.
//

import SwiftUI

struct SplashScreen: View {
    let appName = "Journali"
    var body: some View {
        ZStack () {
            VStack{
                Image("url@4x")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                            }
                    }
                Text(appName)
                    .foregroundStyle(Color.white)
                    .font(Font.custom("SFPro-Black", size: 42))
                    .bold()
                Text ("Your thoughts, your story")
                    .font(Font.custom("SFPro-Light", size: 18))
            }
        }
        .padding()
    }
}

#Preview {
    SplashScreen()
}
