//
//  emptystate.swift
//  JournalApp
//
//  Created by Sara Alsubaie on 28/04/1447 AH.
//
import SwiftUI

struct EmptyState: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                
                HStack(alignment: .firstTextBaseline) {
                    Text("Journal")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Spacer()

                    
                    HStack(spacing: 16) {
                        Image(systemName: "line.3.horizontal")
                        Image(systemName: "plus")
                                        }
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
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
        }
    }
}

#Preview {
    EmptyState()
}

private struct GlassEffectModifier: ViewModifier {
    var cornerRadius: CGFloat
    var strokeOpacity: Double
    var blurRadius: CGFloat
    var tint: Color
    var noiseOpacity: Double

    func body(content: Content) -> some View {
        content
            
            .background(
                Group {
                    if #available(iOS 15.0, *) {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(.ultraThinMaterial)
                    } else {
                        
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(tint.opacity(0.15))
                            .background(BlurView(style: .systemUltraThinMaterial))
                    }
                }
            )
            
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(tint.opacity(0.08))
            )
                .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        .white.opacity(strokeOpacity),
                        lineWidth: 1
                    )
                    .blendMode(.overlay)
            )
            .blur(radius: blurRadius)
            .overlay(
                NoiseOverlay()
                    .opacity(noiseOpacity)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            )
    }
}

private struct NoiseOverlay: View {
    var body: some View {
        // Uses a system material-like noise by leveraging a very subtle gradient + screen blend
        LinearGradient(
            colors: [
                Color.white.opacity(0.02),
                Color.black.opacity(0.02)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blendMode(.screen)
    }
}

// UIKit blur fallback for iOS < 15
private struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

private extension View {
    // Keep the same API you used: .GlassEffect()
    func GlassEffect(
        cornerRadius: CGFloat = 22,
        strokeOpacity: Double = 0.35,
        blurRadius: CGFloat = 0,
        tint: Color = .white,
        noiseOpacity: Double = 0.06
    ) -> some View {
        modifier(GlassEffectModifier(
            cornerRadius: cornerRadius,
            strokeOpacity: strokeOpacity,
            blurRadius: blurRadius,
            tint: tint,
            noiseOpacity: noiseOpacity
        ))
    }
}
