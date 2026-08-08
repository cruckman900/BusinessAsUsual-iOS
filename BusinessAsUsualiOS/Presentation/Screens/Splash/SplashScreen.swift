import SwiftUI

/// Splash screen with animated logo that auto-navigates to Dashboard.
/// Matches Android's simple fade-in animation.
struct SplashScreen: View {
    @Environment(\.bauTheme) private var theme
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo/Icon
                Image(systemName: "briefcase.fill")
                    .font(.system(size: 80))
                    .foregroundColor(theme.primary)
                
                Text("Business As Usual")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(theme.onBackground)
                
                Text("Your workspace, simplified")
                    .font(.subheadline)
                    .foregroundColor(theme.onBackground.opacity(0.7))
            }
            .opacity(opacity)
            .scaleEffect(scale)
        }
        .onAppear {
            // Fade-in animation
            withAnimation(.easeOut(duration: 0.6)) {
                opacity = 1
                scale = 1
            }
            
            // Auto-navigate to Dashboard after 1.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                onComplete()
            }
        }
    }
}

#Preview {
    SplashScreen(onComplete: {})
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
