import SwiftUI

/// Dynamic board (kanban) screen renderer - horizontal lanes with cards.
/// Matches Android's DynamicBoardScreen.
struct DynamicBoardScreen: View {
    let spec: BoardScreenSpec
    let items: [[String: String]]
    let onAction: (ScreenAction) -> Void
    
    @Environment(\.bauTheme) private var theme
    @State private var searchQuery = ""
    
    init(spec: BoardScreenSpec, items: [[String: String]] = [], onAction: @escaping (ScreenAction) -> Void = { _ in }) {
        self.spec = spec
        self.items = items
        self.onAction = onAction
    }
    
    var body: some View {
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
                boardLanes
            }
        }
        .padding(.vertical, 16)
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
            Image(systemName: "square.split.2x1")
                .font(.system(size: 48))
                .foregroundColor(theme.onBackground.opacity(0.3))
            Text(spec.emptyStateMessage)
                .font(.subheadline)
                .foregroundColor(theme.onBackground.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 48)
    }
    
    private var boardLanes: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(spec.columns, id: \.id) { column in
                    boardLane(column)
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func boardLane(_ column: BoardColumn) -> some View {
        let laneItems = itemsForColumn(column)
        let color = Color(hex: column.color ?? "5F6368")
        
        return VStack(alignment: .leading, spacing: 8) {
            // Lane header
            HStack {
                Text(column.label)
                    .font(.headline)
                    .foregroundColor(color)
                Spacer()
                Text("\(laneItems.count)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.15))
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            
            if let summary = column.summaryLabel {
                Text(summary)
                    .font(.caption)
                    .foregroundColor(theme.onSurface.opacity(0.7))
                    .padding(.horizontal, 12)
            }
            
            Divider()
                .padding(.horizontal, 12)
            
            // Lane cards
            ScrollView {
                VStack(spacing: 8) {
                    ForEach(0..<laneItems.count, id: \.self) { index in
                        boardCard(laneItems[index], accentColor: color)
                    }
                }
                .padding(12)
            }
            .frame(maxHeight: 500)
        }
        .frame(width: 280)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 2)
        )
    }
    
    private func boardCard(_ item: [String: String], accentColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item[spec.cardLayout.titleField] ?? "—")
                .font(.headline)
                .foregroundColor(theme.onSurface)
                .lineLimit(2)
            
            if let subtitleField = spec.cardLayout.subtitleField, let subtitle = item[subtitleField] {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(theme.onSurface.opacity(0.7))
                    .lineLimit(1)
            }
            
            if let valueField = spec.cardLayout.valueField, let value = item[valueField] {
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(accentColor)
            }
            
            if let progressField = spec.cardLayout.progressField, let progress = item[progressField] {
                ProgressBarCell(value: progress)
            }
            
            HStack {
                if let badgeField = spec.cardLayout.badgeField, let badge = item[badgeField] {
                    StatusChip(value: badge)
                }
                
                Spacer()
                
                if let metaField = spec.cardLayout.metaField, let meta = item[metaField] {
                    Text(meta)
                        .font(.caption)
                        .foregroundColor(theme.onSurface.opacity(0.7))
                }
            }
        }
        .padding(12)
        .background(theme.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(theme.outline.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var filteredItems: [[String: String]] {
        if searchQuery.isEmpty {
            return items
        }
        return items.filter { item in
            item.values.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    private func itemsForColumn(_ column: BoardColumn) -> [[String: String]] {
        filteredItems.filter { item in
            item[spec.groupByField] == column.id
        }
    }
}

#Preview {
    let spec = BoardScreenSpec(
        title: "Opportunities Board",
        searchPlaceholder: "Search opportunities...",
        enableSearch: true,
        groupByField: "stage",
        columns: [
            BoardColumn(id: "lead", label: "Leads", color: "757575", summaryLabel: "$0"),
            BoardColumn(id: "qualified", label: "Qualified", color: "0D66C2", summaryLabel: "$45K"),
            BoardColumn(id: "proposal", label: "Proposal", color: "B26A00", summaryLabel: "$120K"),
            BoardColumn(id: "closed", label: "Closed Won", color: "1B5E20", summaryLabel: "$85K")
        ],
        cardLayout: BoardCardLayout(
            titleField: "company",
            subtitleField: "contact",
            valueField: "value",
            progressField: "probability",
            badgeField: "priority",
            metaField: "owner"
        ),
        actions: [
            ScreenAction(id: "add", label: "Add Opportunity", icon: "plus", action: ActionTypes.navigate)
        ],
        enableDragToMove: false,
        moveEndpoint: nil,
        emptyStateMessage: "No opportunities found",
        fallbackColumns: []
    )
    
    let items = [
        ["stage": "lead", "company": "Acme Corp", "contact": "John Smith", "value": "$25K", "probability": "20%", "priority": "High", "owner": "Sarah"],
        ["stage": "lead", "company": "TechStart Inc", "contact": "Jane Doe", "value": "$15K", "probability": "15%", "priority": "Medium", "owner": "Mike"],
        ["stage": "qualified", "company": "Global Systems", "contact": "Bob Wilson", "value": "$45K", "probability": "40%", "priority": "High", "owner": "Sarah"],
        ["stage": "proposal", "company": "Enterprise Co", "contact": "Alice Brown", "value": "$120K", "probability": "60%", "priority": "Critical", "owner": "Tom"],
        ["stage": "closed", "company": "Big Client LLC", "contact": "Charlie Davis", "value": "$85K", "probability": "100%", "priority": "High", "owner": "Sarah"]
    ]
    
    return DynamicBoardScreen(spec: spec, items: items)
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
