import SwiftUI

/// Generic host screen for any backend-discovered module. Renders the module's
/// contract-driven UI with tab navigation and overview landing.
/// Matches Android's ModuleHostScreen + ModuleContent.
struct ModuleHostScreen: View {
    @StateObject private var viewModel: ModuleHostViewModel
    @Environment(\.bauTheme) private var theme
    
    let moduleId: String
    
    init(moduleId: String) {
        self.moduleId = moduleId
        self._viewModel = StateObject(wrappedValue: ModuleHostViewModel(moduleId: moduleId))
    }
    
    var body: some View {
        BAUScreenShell(
            title: viewModel.breadcrumbTitle,
            breadcrumbs: buildBreadcrumbs(),
            currentRoute: .dashboard // TODO: Update when navigation is wired
        ) {
            if viewModel.isLoading {
                loadingView
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else if let moduleUi = viewModel.moduleUi {
                moduleContent(moduleUi)
            }
        }
        .task {
            await viewModel.loadModuleUI()
        }
    }
    
    private func buildBreadcrumbs() -> [String] {
        var crumbs = ["Dashboard"]
        
        if let moduleUi = viewModel.moduleUi {
            crumbs.append(moduleUi.displayName)
            
            // Add screen title if not on overview
            if viewModel.selectedScreen != "__overview__",
               let selectedScreen = viewModel.selectedScreen,
               let navItem = moduleUi.navigation.items.first(where: { $0.screen == selectedScreen }) {
                crumbs.append(navItem.label)
            }
        }
        
        return crumbs
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading module…")
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
            
            Text("Failed to Load Module")
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
    
    private func moduleContent(_ moduleUi: ModuleUi) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Module header
                VStack(alignment: .leading, spacing: 4) {
                    Text(moduleUi.moduleName)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.onBackground)
                    Text("v\(moduleUi.version)")
                        .font(.caption)
                        .foregroundColor(theme.onBackground.opacity(0.6))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                
                // Horizontal tab/chip navigation
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        // Overview tab
                        filterChip(
                            label: "Overview",
                            icon: "square.grid.2x2",
                            isSelected: viewModel.selectedScreen == "__overview__",
                            isEnabled: true
                        ) {
                            viewModel.selectScreen("__overview__")
                        }
                        
                        // Navigation items from contract
                        ForEach(moduleUi.navigation.items, id: \.id) { item in
                            let enabled = moduleUi.screens.keys.contains(item.screen)
                            filterChip(
                                label: item.label,
                                icon: item.icon,
                                isSelected: viewModel.selectedScreen == item.screen,
                                isEnabled: enabled
                            ) {
                                viewModel.selectScreen(item.screen)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 8)
                
                Divider()
                    .padding(.vertical, 8)
                
                // Selected screen content
                if viewModel.selectedScreen == "__overview__" {
                    moduleOverview(moduleUi)
                } else {
                    // TODO: Phase 3 - Render dynamic screens here
                    placeholderScreen(moduleUi)
                }
            }
        }
    }
    
    private func filterChip(label: String, icon: String, isSelected: Bool, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                IconResolver.resolve(icon)
                    .font(.system(size: 16))
                Text(label)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? theme.primary.opacity(0.12) : theme.surface)
            .foregroundColor(isSelected ? theme.primary : (isEnabled ? theme.onSurface : theme.onSurface.opacity(0.38)))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? theme.primary : theme.outline.opacity(0.3), lineWidth: 1)
            )
        }
        .disabled(!isEnabled)
    }
    
    /// Overview landing: card grid of module sections (matches Android ModuleOverview).
    private func moduleOverview(_ moduleUi: ModuleUi) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(moduleUi.displayName) Overview")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(theme.onBackground)
                .padding(.horizontal, 16)
            
            Text("Choose a section to get started")
                .font(.subheadline)
                .foregroundColor(theme.onBackground.opacity(0.7))
                .padding(.horizontal, 16)
            
            ForEach(moduleUi.navigation.items, id: \.id) { item in
                let enabled = moduleUi.screens.keys.contains(item.screen)
                overviewCard(item: item, enabled: enabled)
            }
        }
        .padding(.vertical, 16)
    }
    
    private func overviewCard(item: NavItem, enabled: Bool) -> some View {
        Button {
            if enabled {
                viewModel.selectScreen(item.screen)
            }
        } label: {
            HStack(spacing: 16) {
                IconResolver.resolve(item.icon)
                    .font(.system(size: 28))
                    .foregroundColor(enabled ? theme.primary : theme.onSurface.opacity(0.3))
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.label)
                        .font(.headline)
                        .foregroundColor(theme.onSurface)
                    
                    if !enabled {
                        Text("Coming soon")
                            .font(.caption)
                            .foregroundColor(theme.onSurface.opacity(0.5))
                    }
                }
                
                Spacer()
                
                if enabled {
                    Image(systemName: "chevron.right")
                        .foregroundColor(theme.onSurface.opacity(0.5))
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        }
        .disabled(!enabled)
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
    
    /// Placeholder for screens until Phase 3 dynamic renderers are built.
    private func placeholderScreen(_ moduleUi: ModuleUi) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 48))
                .foregroundColor(theme.onBackground.opacity(0.3))
            
            Text("Screen Renderer Coming Soon")
                .font(.headline)
                .foregroundColor(theme.onBackground)
            
            if let selectedScreen = viewModel.selectedScreen,
               let screen = moduleUi.screens[selectedScreen] {
                Text("Type: \(String(describing: type(of: screen)))")
                    .font(.caption)
                    .foregroundColor(theme.onBackground.opacity(0.6))
            }
            
            Text("Dynamic screen renderers will be implemented in Phase 3")
                .font(.subheadline)
                .foregroundColor(theme.onBackground.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
}

#Preview {
    ModuleHostScreen(moduleId: "hr")
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
