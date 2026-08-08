import SwiftUI

/// Dynamic list screen renderer - displays data in adaptive table/card layout.
/// Matches Android's DynamicListScreen with shouldUseTable heuristic.
struct DynamicListScreen: View {
    let spec: ListScreenSpec
    let rows: [[String: String]]
    let onAction: (ScreenAction) -> Void
    
    @Environment(\.bauTheme) private var theme
    @State private var searchQuery = ""
    @State private var pendingConfirmAction: ScreenAction?
    
    init(spec: ListScreenSpec, rows: [[String: String]] = [], onAction: @escaping (ScreenAction) -> Void = { _ in }) {
        self.spec = spec
        self.rows = rows
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
                
                if let addAction = spec.actions.first(where: { $0.action == ActionTypes.navigate && $0.id == "add" }) {
                    addButton(addAction)
                }
                
                if filteredRows.isEmpty {
                    emptyState
                } else if shouldUseTable {
                    tableLayout
                } else {
                    cardLayout
                }
            }
            .padding(.vertical, 16)
        }
        .confirmationDialog(
            pendingConfirmAction?.label ?? "",
            isPresented: Binding(
                get: { pendingConfirmAction != nil },
                set: { if !$0 { pendingConfirmAction = nil } }
            ),
            titleVisibility: .visible
        ) {
            if let action = pendingConfirmAction {
                Button(action.label, role: .destructive) {
                    onAction(action)
                    pendingConfirmAction = nil
                }
                Button("Cancel", role: .cancel) {
                    pendingConfirmAction = nil
                }
            }
        } message: {
            if let action = pendingConfirmAction {
                Text(action.confirmationMessage ?? "Are you sure?")
            }
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
            Image(systemName: "tray")
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
    
    private var filteredRows: [[String: String]] {
        if searchQuery.isEmpty {
            return rows
        }
        return rows.filter { row in
            row.values.contains { $0.localizedCaseInsensitiveContains(searchQuery) }
        }
    }
    
    private var shouldUseTable: Bool {
        let totalWidth = spec.columns.reduce(0) { $0 + $1.width }
        return spec.columns.count >= 5 || totalWidth > 560
    }
    
    private var rowActions: [ScreenAction] {
        spec.actions.filter { $0.id != "add" }
    }
    
    // MARK: - Card Layout
    
    private var cardLayout: some View {
        let titleCol = spec.columns.first
        let badgeCol = spec.columns.first { $0.type == FieldTypes.badge }
        let detailCols = spec.columns.filter { $0 != titleCol && $0 != badgeCol }
        
        return VStack(spacing: 10) {
            ForEach(0..<filteredRows.count, id: \.self) { index in
                let row = filteredRows[index]
                cardRow(row: row, titleCol: titleCol, badgeCol: badgeCol, detailCols: detailCols)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func cardRow(row: [String: String], titleCol: ListColumn?, badgeCol: ListColumn?, detailCols: [ListColumn]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titleCol.flatMap { row[$0.name] } ?? "—")
                    .font(.headline)
                    .foregroundColor(theme.onSurface)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let badgeCol = badgeCol {
                    StatusChip(value: row[badgeCol.name] ?? "")
                }
                
                if !rowActions.isEmpty {
                    RowActionsMenu(actions: rowActions) { action in
                        handleRowAction(action.resolved(for: row))
                    }
                }
            }
            
            ForEach(detailCols, id: \.name) { col in
                HStack(alignment: .top) {
                    Text(col.label)
                        .font(.caption)
                        .foregroundColor(theme.onSurface.opacity(0.7))
                        .frame(width: 120, alignment: .leading)
                    
                    cellContent(value: row[col.name] ?? "", type: col.type)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(16)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }
    
    // MARK: - Table Layout
    
    private var tableLayout: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
                    ForEach(spec.columns, id: \.name) { col in
                        Text(col.label)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.onSurface.opacity(0.7))
                            .lineLimit(1)
                            .frame(width: CGFloat(col.width), alignment: .leading)
                            .padding(.horizontal, 8)
                    }
                    if !rowActions.isEmpty {
                        Spacer().frame(width: 56)
                    }
                }
                .padding(.vertical, 10)
                .background(theme.surface.opacity(0.5))
                
                Divider()
                
                // Rows
                ForEach(0..<filteredRows.count, id: \.self) { index in
                    let row = filteredRows[index]
                    tableRow(row: row)
                    Divider()
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    private func tableRow(row: [String: String]) -> some View {
        HStack(spacing: 0) {
            ForEach(spec.columns, id: \.name) { col in
                cellContent(value: row[col.name] ?? "", type: col.type)
                    .frame(width: CGFloat(col.width), alignment: .leading)
                    .padding(.horizontal, 8)
            }
            if !rowActions.isEmpty {
                RowActionsMenu(actions: rowActions) { action in
                    handleRowAction(action.resolved(for: row))
                }
                .frame(width: 56)
            }
        }
        .padding(.vertical, 10)
    }
    
    // MARK: - Cell Content
    
    @ViewBuilder
    private func cellContent(value: String, type: String) -> some View {
        switch type {
        case FieldTypes.badge:
            StatusChip(value: value)
        case FieldTypes.progress:
            ProgressBarCell(value: value)
        case FieldTypes.percent:
            PercentRing(value: value)
        case FieldTypes.rating:
            StarRatingCell(value: value)
        default:
            Text(value.isEmpty ? "—" : value)
                .font(.subheadline)
                .foregroundColor(theme.onSurface)
                .lineLimit(1)
        }
    }
    
    private func handleRowAction(_ action: ScreenAction) {
        if action.requiresConfirmation {
            pendingConfirmAction = action
        } else {
            onAction(action)
        }
    }
}

#Preview {
    let spec = ListScreenSpec(
        title: "Employees",
        searchPlaceholder: "Search employees...",
        enableSearch: true,
        enableFilter: false,
        columns: [
            ListColumn(name: "name", label: "Name", type: FieldTypes.text, sortable: true, width: 200),
            ListColumn(name: "title", label: "Title", type: FieldTypes.text, sortable: true, width: 180),
            ListColumn(name: "department", label: "Department", type: FieldTypes.text, sortable: true, width: 150),
            ListColumn(name: "status", label: "Status", type: FieldTypes.badge, sortable: false, width: 120)
        ],
        actions: [
            ScreenAction(id: "add", label: "Add Employee", icon: "plus", action: ActionTypes.navigate),
            ScreenAction(id: "edit", label: "Edit", icon: "edit", action: ActionTypes.navigate),
            ScreenAction(id: "delete", label: "Delete", icon: "delete", action: ActionTypes.apiCall, requiresConfirmation: true, confirmationMessage: "Delete this employee?")
        ],
        filters: [],
        emptyStateMessage: "No employees found",
        stats: [
            StatCard(id: "total", label: "Total", value: "45", icon: "person", tone: "info"),
            StatCard(id: "active", label: "Active", value: "42", icon: "checkmark", tone: "positive")
        ]
    )
    
    let rows = [
        ["name": "John Doe", "title": "Senior Engineer", "department": "Engineering", "status": "Active"],
        ["name": "Jane Smith", "title": "Product Manager", "department": "Product", "status": "Active"],
        ["name": "Bob Johnson", "title": "Designer", "department": "Design", "status": "On Leave"]
    ]
    
    return DynamicListScreen(spec: spec, rows: rows)
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
