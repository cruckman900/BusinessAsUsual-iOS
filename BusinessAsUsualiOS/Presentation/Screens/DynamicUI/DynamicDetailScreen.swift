import SwiftUI

/// Dynamic detail screen renderer - displays read-only field sections.
/// Matches Android's DynamicDetailScreen.
struct DynamicDetailScreen: View {
    let spec: DetailScreenSpec
    let values: [String: String]
    let onAction: (ScreenAction) -> Void
    
    @Environment(\.bauTheme) private var theme
    
    init(spec: DetailScreenSpec, values: [String: String] = [:], onAction: @escaping (ScreenAction) -> Void =  { _ in }) {
        self.spec = spec
        self.values = values
        self.onAction = onAction
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(spec.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onBackground)
                    .padding(.horizontal, 16)
                
                ForEach(spec.sections, id: \.id) { section in
                    sectionCard(section)
                }
                
                if !spec.actions.isEmpty {
                    actionButtons
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    private func sectionCard(_ section: DetailSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.title)
                .font(.headline)
                .foregroundColor(theme.onSurface)
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            ForEach(section.fields, id: \.name) { field in
                fieldRow(field)
            }
            
            Spacer().frame(height: 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
        .padding(.horizontal, 16)
    }
    
    private func fieldRow(_ field: DetailField) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if let iconName = field.icon {
                IconResolver.resolve(iconName)
                    .foregroundColor(theme.primary)
                    .frame(width: 20)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(field.label)
                    .font(.caption)
                    .foregroundColor(theme.onSurface.opacity(0.7))
                
                Text(values[field.name] ?? "—")
                    .font(.body)
                    .foregroundColor(theme.onSurface)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 8) {
            ForEach(spec.actions, id: \.id) { action in
                Button(action: {
                    onAction(action)
                }) {
                    HStack {
                        IconResolver.resolve(action.icon)
                        Text(action.label)
                    }
                }
                .buttonStyle(.bauOutlined)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    let spec = DetailScreenSpec(
        title: "Employee Details",
        sections: [
            DetailSection(
                id: "personal",
                title: "Personal Information",
                fields: [
                    DetailField(name: "name", label: "Name", type: "text", icon: "person"),
                    DetailField(name: "email", label: "Email", type: "email", icon: "envelope"),
                    DetailField(name: "phone", label: "Phone", type: "phone", icon: "phone")
                ]
            ),
            DetailSection(
                id: "employment",
                title: "Employment",
                fields: [
                    DetailField(name: "title", label: "Job Title", type: "text"),
                    DetailField(name: "department", label: "Department", type: "text"),
                    DetailField(name: "startDate", label: "Start Date", type: "date", icon: "calendar")
                ]
            )
        ],
        actions: [
            ScreenAction(id: "edit", label: "Edit", icon: "edit", action: ActionTypes.navigate),
            ScreenAction(id: "delete", label: "Delete", icon: "delete", action: ActionTypes.apiCall, requiresConfirmation: true)
        ]
    )
    
    let values: [String: String] = [
        "name": "John Doe",
        "email": "john.doe@company.com",
        "phone": "+1 (555) 123-4567",
        "title": "Senior Engineer",
        "department": "Engineering",
        "startDate": "January 15, 2023"
    ]
    
    return DynamicDetailScreen(spec: spec, values: values)
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
