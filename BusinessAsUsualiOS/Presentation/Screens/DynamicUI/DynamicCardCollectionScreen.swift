import SwiftUI

/// Dynamic card collection screen renderer - rich preview cards (e.g. email templates).
/// Matches Android's DynamicCardCollectionScreen.
struct DynamicCardCollectionScreen: View {
    let spec: CardCollectionScreenSpec
    let items: [[String: String]]
    let onAction: (ScreenAction) -> Void
    
    @Environment(\.bauTheme) private var theme
    @State private var searchQuery = ""
    
    init(spec: CardCollectionScreenSpec, items: [[String: String]] = [], onAction: @escaping (ScreenAction) -> Void = { _ in }) {
        self.spec = spec
        self.items = items
        self.onAction = onAction
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(spec.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onBackground)
                    .padding(.horizontal, 16)
                
                if spec.enableSearch {
                    searchField
                }
                
                if let addAction = spec.actions.first(where: { $0.id == "add" }) {
                    addButton(addAction)
                }
                
                if filteredItems.isEmpty {
                    emptyState
                } else {
                    cardList
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.onSurface.opacity(0.7))
            TextField(spec.searchPlaceholder, text: $searchQuery)
                .textFieldStyle(.plain)
        }
        .padding(12)
        .background(theme.surface.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal, 16)
    }
    
    private func addButton(_ action: ScreenAction) -> some View {
        Button(action: {
            onAction(action)
        }) {
            HStack {
                IconResolver.resolve(action.icon)
                Text(action.label)
            }
        }
        .buttonStyle(.bauFilled)
        .padding(.horizontal, 16)
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(theme.onBackground.opacity(0.3))
            Text(spec.emptyStateMessage)
                .font(.subheadline)
                .foregroundColor(theme.onBackground.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 48)
    }
    
    private var cardList: some View {
        VStack(spacing: 12) {
            ForEach(0..<filteredItems.count, id: \.self) { index in
                previewCard(filteredItems[index])
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func previewCard(_ item: [String: String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: icon + title + status
            HStack(alignment: .top) {
                if let iconField = spec.cardLayout.iconField,
                   let icon = item[iconField], !icon.isEmpty {
                    IconResolver.resolve(icon)
                        .font(.system(size: 24))
                        .foregroundColor(theme.primary)
                        .frame(width: 40, height: 40)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item[spec.cardLayout.titleField] ?? "—")
                        .font(.headline)
                        .foregroundColor(theme.onSurface)
                        .lineLimit(2)
                    
                    if let subtitleField = spec.cardLayout.subtitleField,
                       let subtitle = item[subtitleField] {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(theme.onSurface.opacity(0.7))
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    if let statusField = spec.cardLayout.statusField,
                       let status = item[statusField] {
                        StatusChip(value: status)
                    }
                    
                    if let badgeField = spec.cardLayout.badgeField,
                       let badge = item[badgeField] {
                        Text(badge)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.primary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(theme.primary.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }
            }
            
            // Preview content
            if let previewField = spec.cardLayout.previewField,
               let preview = item[previewField], !preview.isEmpty {
                Text(preview)
                    .font(.body)
                    .foregroundColor(theme.onSurface.opacity(0.9))
                    .lineLimit(3)
                    .padding(.top, 4)
            }
            
            Divider()
            
            // Footer: meta + actions
            HStack {
                if let metaField = spec.cardLayout.metaField,
                   let meta = item[metaField] {
                    Text(meta)
                        .font(.caption)
                        .foregroundColor(theme.onSurface.opacity(0.7))
                }
                
                Spacer()
                
                if !spec.cardActions.isEmpty {
                    RowActionsMenu(actions: spec.cardActions) { action in
                        onAction(action.resolved(for: item))
                    }
                }
            }
        }
        .padding(16)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
    }
    
    private var filteredItems: [[String: String]] {
        if searchQuery.isEmpty {
            return items
        }
        return items.filter { item in
            item.values.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
}

#Preview {
    let spec = CardCollectionScreenSpec(
        title: "Email Templates",
        searchPlaceholder: "Search templates...",
        enableSearch: true,
        enableFilter: false,
        preferredColumns: 1,
        cardLayout: CardLayout(
            titleField: "name",
            subtitleField: "category",
            previewField: "preview",
            badgeField: "type",
            statusField: "status",
            metaField: "lastModified",
            iconField: "icon"
        ),
        actions: [
            ScreenAction(id: "add", label: "New Template", icon: "plus", action: ActionTypes.navigate)
        ],
        cardActions: [
            ScreenAction(id: "edit", label: "Edit", icon: "pencil", action: ActionTypes.navigate),
            ScreenAction(id: "duplicate", label: "Duplicate", icon: "doc.on.doc", action: ActionTypes.apiCall),
            ScreenAction(id: "delete", label: "Delete", icon: "trash", action: ActionTypes.apiCall, requiresConfirmation: true)
        ],
        filters: [],
        emptyStateMessage: "No templates found",
        fallbackColumns: []
    )
    
    let items = [
        [
            "name": "Welcome Email",
            "category": "Onboarding",
            "preview": "Welcome to our team! We're excited to have you join us. This email contains important information about your first week...",
            "type": "Automated",
            "status": "Active",
            "lastModified": "2 days ago",
            "icon": "envelope.badge.fill"
        ],
        [
            "name": "Interview Invitation",
            "category": "Recruitment",
            "preview": "Thank you for your application. We were impressed with your background and would like to invite you for an interview...",
            "type": "Manual",
            "status": "Active",
            "lastModified": "1 week ago",
            "icon": "person.fill.questionmark"
        ],
        [
            "name": "Performance Review Reminder",
            "category": "HR Operations",
            "preview": "This is a reminder that your annual performance review is scheduled for next week. Please prepare by reviewing...",
            "type": "Scheduled",
            "status": "Draft",
            "lastModified": "Yesterday",
            "icon": "chart.bar.doc.horizontal"
        ]
    ]
    
    return DynamicCardCollectionScreen(spec: spec, items: items)
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
