import SwiftUI

/// Dashboard landing screen with welcome hero card + dynamic module grid.
/// Matches Android's DashboardScreen - modules are discovered from backend at runtime.
struct DashboardScreen: View {
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.bauTheme) private var theme
    
    let onModuleTap: (BAUModule) -> Void
    
    var body: some View {
        BAUScreenShell(
            title: "Dashboard",
            breadcrumbs: ["Dashboard"],
            currentRoute: .dashboard
        ) {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else {
                contentView
            }
        }
        .task {
            await viewModel.loadModules()
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading your workspace…")
                .font(.subheadline)
                .foregroundColor(theme.onBackground.opacity(0.7))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("Failed to Load")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(theme.onBackground)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(theme.onBackground.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button(action: viewModel.retry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
            }
            .buttonStyle(.bauFilled)
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                welcomeHero
                
                Text("Modules")
                    .font(.headline)
                    .foregroundColor(theme.onBackground)
                    .padding(.top, 4)
                
                ForEach(viewModel.modules) { module in
                    moduleCard(module)
                }
            }
            .padding(16)
        }
    }
    
    private var welcomeHero: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Welcome back")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.onPrimary)
            
            Text(viewModel.modules.isEmpty
                 ? "No modules available"
                 : "You have \(viewModel.modules.count) module\(viewModel.modules.count == 1 ? "" : "s") available")
                .font(.subheadline)
                .foregroundColor(theme.onPrimary.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(theme.primary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.15), radius: 6, y: 3)
    }
    
    private func moduleCard(_ module: BAUModule) -> some View {
        Button {
            onModuleTap(module)
        } label: {
            HStack(spacing: 16) {
                IconResolver.resolve(module.icon)
                    .font(.system(size: 28))
                    .foregroundColor(theme.primary)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(module.name)
                        .font(.headline)
                        .foregroundColor(theme.onSurface)
                    Text(module.description)
                        .font(.caption)
                        .foregroundColor(theme.onSurface.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(theme.onSurface.opacity(0.5))
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.outline.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    DashboardScreen(onModuleTap: { _ in })
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
