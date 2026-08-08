import SwiftUI

/// Per-row overflow (⋮) menu with an icon on every item. Destructive items are tinted.
/// Matches Android's RowActionsMenu.
struct RowActionsMenu: View {
    let actions: [ScreenAction]
    let onAction: (ScreenAction) -> Void
    @Environment(\.bauTheme) private var theme
    
    @State private var showMenu = false
    
    var body: some View {
        if actions.isEmpty {
            EmptyView()
        } else {
            Menu {
                ForEach(actions, id: \.id) { action in
                    Button(action: {
                        onAction(action)
                    }) {
                        Label {
                            Text(action.label)
                                .foregroundColor(isDestructive(action) ? .red : theme.onSurface)
                        } icon: {
                            IconResolver.resolve(action.icon)
                                .foregroundColor(isDestructive(action) ? .red : theme.onSurface)
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(theme.onSurface)
                    .frame(width: 44, height: 44)
            }
        }
    }
    
    private func isDestructive(_ action: ScreenAction) -> Bool {
        action.id == "delete" || action.id == "reject"
    }
}
