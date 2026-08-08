import SwiftUI

/// Dynamic timeline screen renderer - vertical timeline with colored nodes.
/// Matches Android's DynamicTimelineScreen.
struct DynamicTimelineScreen: View {
    let spec: TimelineScreenSpec
    let items: [[String: String]]
    let onAction: (ScreenAction) -> Void
    
    @Environment(\.bauTheme) private var theme
    @State private var searchQuery = ""
    
    init(spec: TimelineScreenSpec, items: [[String: String]] = [], onAction: @escaping (ScreenAction) -> Void = { _ in }) {
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
                
                if !spec.stats.isEmpty {
                    StatCardsRow(stats: spec.stats)
                        .padding(.horizontal, 16)
                }
                
                if spec.enableSearch {
                    searchField
                }
                
                if let addAction = spec.actions.first(where: { $0.id == "add" }) {
                    addButton(addAction)
                }
                
                if filteredItems.isEmpty {
                    emptyState
                } else {
                    timelineList
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
            Image(systemName: "clock")
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
    
    private var timelineList: some View {
        VStack(spacing: 0) {
            ForEach(0..<filteredItems.count, id: \.self) { index in
                timelineItem(filteredItems[index], isLast: index == filteredItems.count - 1)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func timelineItem(_ item: [String: String], isLast: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Timeline node + connector
            VStack(spacing: 0) {
                Circle()
                    .fill(accentColor(for: item))
                    .frame(width: 12, height: 12)
                
                if !isLast {
                    Rectangle()
                        .fill(theme.outline.opacity(0.3))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 12)
            
            // Timeline item card
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        if let icon = item[spec.itemFields.iconField], !icon.isEmpty {
                            HStack(spacing: 6) {
                                IconResolver.resolve(icon)
                                    .font(.system(size: 18))
                                    .foregroundColor(accentColor(for: item))
                                Text(item[spec.itemFields.titleField] ?? "—")
                                    .font(.headline)
                                    .foregroundColor(theme.onSurface)
                            }
                        } else {
                            Text(item[spec.itemFields.titleField] ?? "—")
                                .font(.headline)
                                .foregroundColor(theme.onSurface)
                        }
                        
                        if let subtitle = item[spec.itemFields.subtitleField] {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundColor(theme.onSurface.opacity(0.7))
                        }
                    }
                    
                    Spacer()
                    
                    if let status = item[spec.itemFields.statusField] {
                        StatusChip(value: status)
                    }
                }
                
                if let description = item[spec.itemFields.descriptionField], !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(theme.onSurface)
                }
                
                HStack {
                    if let timestamp = item[spec.itemFields.timestampField] {
                        Label(timestamp, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(theme.onSurface.opacity(0.7))
                    }
                    
                    if let type = item[spec.itemFields.typeField] {
                        Label(type, systemImage: "tag")
                            .font(.caption)
                            .foregroundColor(theme.onSurface.opacity(0.7))
                    }
                    
                    if let owner = item[spec.itemFields.ownerField] {
                        Label(owner, systemImage: "person")
                            .font(.caption)
                            .foregroundColor(theme.onSurface.opacity(0.7))
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(theme.outline.opacity(0.3), lineWidth: 1)
            )
            .padding(.bottom, isLast ? 0 : 16)
        }
    }
    
    private var filteredItems: [[String: String]] {
        if searchQuery.isEmpty {
            return items
        }
        return items.filter { item in
            item.values.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    private func accentColor(for item: [String: String]) -> Color {
        guard let status = item[spec.itemFields.statusField] else {
            return Color(hex: "5F6368") // neutral
        }
        
        let tone = statusTone(for: status)
        switch tone {
        case .positive: return Color(hex: "1B5E20")
        case .warning: return Color(hex: "B26A00")
        case .negative: return Color(hex: "B3261E")
        case .neutral: return Color(hex: "5F6368")
        }
    }
}

#Preview {
    let spec = TimelineScreenSpec(
        title: "Activity Timeline",
        searchPlaceholder: "Search activities...",
        enableSearch: true,
        stats: [
            StatCard(id: "total", label: "Total", value: "24", icon: "clock", tone: "info"),
            StatCard(id: "pending", label: "Pending", value: "8", icon: "hourglass", tone: "warning")
        ],
        itemFields: TimelineItemFields(),
        actions: [
            ScreenAction(id: "add", label: "Add Activity", icon: "plus", action: ActionTypes.navigate)
        ],
        emptyStateMessage: "No activities found"
    )
    
    let items = [
        [
            "subject": "Employee Onboarding",
            "relatedTo": "John Doe",
            "description": "Complete onboarding checklist and setup workstation",
            "dueDate": "Today, 2:00 PM",
            "status": "In Progress",
            "type": "Task",
            "owner": "HR Team",
            "icon": "person.badge.plus"
        ],
        [
            "subject": "Interview Scheduled",
            "relatedTo": "Jane Smith - Senior Engineer",
            "description": "Technical interview for backend position",
            "dueDate": "Tomorrow, 10:00 AM",
            "status": "Scheduled",
            "type": "Meeting",
            "owner": "Sarah Johnson",
            "icon": "calendar"
        ],
        [
            "subject": "Performance Review",
            "relatedTo": "Bob Williams",
            "description": "Annual performance review completed",
            "dueDate": "Yesterday",
            "status": "Completed",
            "type": "Review",
            "owner": "Management",
            "icon": "checkmark.circle"
        ]
    ]
    
    return DynamicTimelineScreen(spec: spec, items: items)
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
