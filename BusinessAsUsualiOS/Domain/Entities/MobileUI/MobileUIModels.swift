import Foundation

// MARK: - Module UI Contract

/// Aggregated UI contract for one module (e.g. HR), fetched in a single call.
struct ModuleUi: Codable {
    let moduleId: String
    let moduleName: String
    let displayName: String
    let version: String
    let navigation: NavigationMap
    let screens: [String: ScreenSpec]
    
    /// First list screen, if any (convenience for legacy callers).
    var listScreen: ListScreenSpec? {
        screens.values.compactMap { $0 as? ListScreenSpec }.first
    }
    
    /// First detail screen, if any.
    var detailScreen: DetailScreenSpec? {
        screens.values.compactMap { $0 as? DetailScreenSpec }.first
    }
    
    /// First form screen, if any.
    var formScreen: FormScreenSpec? {
        screens.values.compactMap { $0 as? FormScreenSpec }.first
    }
    
    enum CodingKeys: String, CodingKey {
        case moduleId, moduleName, displayName, version, navigation, screens
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        moduleId = try container.decode(String.self, forKey: .moduleId)
        moduleName = try container.decode(String.self, forKey: .moduleName)
        displayName = try container.decodeIfPresent(String.self, forKey: .displayName) ?? moduleName
        version = try container.decode(String.self, forKey: .version)
        navigation = try container.decode(NavigationMap.self, forKey: .navigation)
        
        // Decode screens dictionary with type discrimination
        let screensContainer = try container.nestedContainer(keyedBy: DynamicKey.self, forKey: .screens)
        var decodedScreens: [String: ScreenSpec] = [:]
        
        for key in screensContainer.allKeys {
            let screenContainer = try screensContainer.nestedContainer(keyedBy: ScreenTypeKey.self, forKey: key)
            let type = try screenContainer.decode(String.self, forKey: .type)
            
            switch type {
            case "list":
                decodedScreens[key.stringValue] = try screensContainer.decode(ListScreenSpec.self, forKey: key)
            case "detail":
                decodedScreens[key.stringValue] = try screensContainer.decode(DetailScreenSpec.self, forKey: key)
            case "form":
                decodedScreens[key.stringValue] = try screensContainer.decode(FormScreenSpec.self, forKey: key)
            case "timeline":
                decodedScreens[key.stringValue] = try screensContainer.decode(TimelineScreenSpec.self, forKey: key)
            case "board":
                decodedScreens[key.stringValue] = try screensContainer.decode(BoardScreenSpec.self, forKey: key)
            case "card-collection":
                decodedScreens[key.stringValue] = try screensContainer.decode(CardCollectionScreenSpec.self, forKey: key)
            case "chart":
                decodedScreens[key.stringValue] = try screensContainer.decode(ChartScreenSpec.self, forKey: key)
            default:
                // Unknown screen type - skip
                continue
            }
        }
        screens = decodedScreens
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(moduleId, forKey: .moduleId)
        try container.encode(moduleName, forKey: .moduleName)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(version, forKey: .version)
        try container.encode(navigation, forKey: .navigation)
        
        var screensContainer = container.nestedContainer(keyedBy: DynamicKey.self, forKey: .screens)
        for (key, screen) in screens {
            let dynamicKey = DynamicKey(stringValue: key)!
            switch screen {
            case let spec as ListScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            case let spec as DetailScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            case let spec as FormScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            case let spec as TimelineScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            case let spec as BoardScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            case let spec as CardCollectionScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            case let spec as ChartScreenSpec:
                try screensContainer.encode(spec, forKey: dynamicKey)
            default:
                continue
            }
        }
    }
}

// MARK: - Screen Spec Protocol

/// Marker for any contract-driven screen, discriminated by backend "type".
protocol ScreenSpec: Codable {}

// MARK: - Navigation

struct NavigationMap: Codable {
    let moduleId: String
    let moduleName: String
    let icon: String
    let items: [NavItem]
}

struct NavItem: Codable {
    let id: String
    let label: String
    let icon: String
    let screen: String
    let route: String?
    let children: [NavItem]
    let requiresPermission: Bool
    let permission: String?
    
    init(id: String, label: String, icon: String, screen: String, route: String? = nil,
         children: [NavItem] = [], requiresPermission: Bool = false, permission: String? = nil) {
        self.id = id
        self.label = label
        self.icon = icon
        self.screen = screen
        self.route = route
        self.children = children
        self.requiresPermission = requiresPermission
        self.permission = permission
    }
}

// MARK: - List Screen

struct ListScreenSpec: ScreenSpec {
    let type: String = "list"
    let title: String
    let searchPlaceholder: String
    let enableSearch: Bool
    let enableFilter: Bool
    let columns: [ListColumn]
    let actions: [ScreenAction]
    let filters: [Filter]
    let emptyStateMessage: String
    let stats: [StatCard]
    
    enum CodingKeys: String, CodingKey {
        case type, title, searchPlaceholder, enableSearch, enableFilter
        case columns, actions, filters, emptyStateMessage, stats
    }
}

struct ListColumn: Codable, Equatable {
    let name: String
    let label: String
    let type: String
    let sortable: Bool
    let width: Int
}

struct Filter: Codable {
    let id: String
    let label: String
    let type: String
    let values: [FilterValue]
}

struct FilterValue: Codable {
    let id: String
    let label: String
    let value: String
}

// MARK: - Board Screen (Kanban)

struct BoardScreenSpec: ScreenSpec {
    let type: String = "board"
    let title: String
    let searchPlaceholder: String
    let enableSearch: Bool
    let groupByField: String
    let columns: [BoardColumn]
    let cardLayout: BoardCardLayout
    let actions: [ScreenAction]
    let enableDragToMove: Bool
    let moveEndpoint: String?
    let emptyStateMessage: String
    let fallbackColumns: [ListColumn]
    
    enum CodingKeys: String, CodingKey {
        case type, title, searchPlaceholder, enableSearch, groupByField
        case columns, cardLayout, actions, enableDragToMove, moveEndpoint
        case emptyStateMessage, fallbackColumns
    }
}

struct BoardColumn: Codable {
    let id: String
    let label: String
    let color: String?
    let summaryLabel: String?
    
    init(id: String, label: String, color: String? = nil, summaryLabel: String? = nil) {
        self.id = id
        self.label = label
        self.color = color
        self.summaryLabel = summaryLabel
    }
}

struct BoardCardLayout: Codable {
    let titleField: String
    let subtitleField: String?
    let valueField: String?
    let progressField: String?
    let badgeField: String?
    let metaField: String?
    
    init(titleField: String = "", subtitleField: String? = nil, valueField: String? = nil,
         progressField: String? = nil, badgeField: String? = nil, metaField: String? = nil) {
        self.titleField = titleField
        self.subtitleField = subtitleField
        self.valueField = valueField
        self.progressField = progressField
        self.badgeField = badgeField
        self.metaField = metaField
    }
}

// MARK: - Card Collection Screen

struct CardCollectionScreenSpec: ScreenSpec {
    let type: String = "card-collection"
    let title: String
    let searchPlaceholder: String
    let enableSearch: Bool
    let enableFilter: Bool
    let preferredColumns: Int
    let cardLayout: CardLayout
    let actions: [ScreenAction]
    let cardActions: [ScreenAction]
    let filters: [Filter]
    let emptyStateMessage: String
    let fallbackColumns: [ListColumn]
    
    enum CodingKeys: String, CodingKey {
        case type, title, searchPlaceholder, enableSearch, enableFilter
        case preferredColumns, cardLayout, actions, cardActions, filters
        case emptyStateMessage, fallbackColumns
    }
}

struct CardLayout: Codable {
    let titleField: String
    let subtitleField: String?
    let previewField: String?
    let badgeField: String?
    let statusField: String?
    let metaField: String?
    let iconField: String?
    
    init(titleField: String = "", subtitleField: String? = nil, previewField: String? = nil,
         badgeField: String? = nil, statusField: String? = nil, metaField: String? = nil, iconField: String? = nil) {
        self.titleField = titleField
        self.subtitleField = subtitleField
        self.previewField = previewField
        self.badgeField = badgeField
        self.statusField = statusField
        self.metaField = metaField
        self.iconField = iconField
    }
}

// MARK: - Timeline Screen

struct TimelineScreenSpec: ScreenSpec {
    let type: String = "timeline"
    let title: String
    let searchPlaceholder: String
    let enableSearch: Bool
    let stats: [StatCard]
    let itemFields: TimelineItemFields
    let actions: [ScreenAction]
    let emptyStateMessage: String
    
    enum CodingKeys: String, CodingKey {
        case type, title, searchPlaceholder, enableSearch
        case stats, itemFields, actions, emptyStateMessage
    }
}

struct TimelineItemFields: Codable {
    let titleField: String
    let subtitleField: String
    let descriptionField: String
    let timestampField: String
    let statusField: String
    let typeField: String
    let ownerField: String
    let iconField: String
    
    init(titleField: String = "subject", subtitleField: String = "relatedTo",
         descriptionField: String = "description", timestampField: String = "dueDate",
         statusField: String = "status", typeField: String = "type",
         ownerField: String = "owner", iconField: String = "icon") {
        self.titleField = titleField
        self.subtitleField = subtitleField
        self.descriptionField = descriptionField
        self.timestampField = timestampField
        self.statusField = statusField
        self.typeField = typeField
        self.ownerField = ownerField
        self.iconField = iconField
    }
}

// MARK: - Stat Card

struct StatCard: Codable {
    let id: String
    let label: String
    let value: String
    let icon: String
    let tone: String
}

// MARK: - Detail Screen

struct DetailScreenSpec: ScreenSpec {
    let type: String = "detail"
    let title: String
    let sections: [DetailSection]
    let actions: [ScreenAction]
    
    enum CodingKeys: String, CodingKey {
        case type, title, sections, actions
    }
}

struct DetailSection: Codable {
    let id: String
    let title: String
    let fields: [DetailField]
    let collapsible: Bool
    let defaultCollapsed: Bool
    
    init(id: String, title: String, fields: [DetailField], collapsible: Bool = false, defaultCollapsed: Bool = false) {
        self.id = id
        self.title = title
        self.fields = fields
        self.collapsible = collapsible
        self.defaultCollapsed = defaultCollapsed
    }
}

struct DetailField: Codable {
    let name: String
    let label: String
    let type: String
    let readOnly: Bool
    let icon: String?
    let format: String?
    
    init(name: String, label: String, type: String, readOnly: Bool = true, icon: String? = nil, format: String? = nil) {
        self.name = name
        self.label = label
        self.type = type
        self.readOnly = readOnly
        self.icon = icon
        self.format = format
    }
}

// MARK: - Form Screen

struct FormScreenSpec: ScreenSpec {
    let type: String = "form"
    let title: String
    let sections: [FormSection]
    let actions: [ScreenAction]
    let validation: FormValidation
    
    enum CodingKeys: String, CodingKey {
        case type, title, sections, actions, validation
    }
}

struct FormSection: Codable {
    let id: String
    let title: String
    let fields: [FormField]
}

struct FormField: Codable {
    let name: String
    let label: String
    let type: String
    let required: Bool
    let placeholder: String?
    let helpText: String?
    let options: [SelectOption]
    let maxLength: Int?
    let minLength: Int?
    let pattern: String?
    let validationMessage: String?
    
    init(name: String, label: String, type: String, required: Bool = false,
         placeholder: String? = nil, helpText: String? = nil, options: [SelectOption] = [],
         maxLength: Int? = nil, minLength: Int? = nil, pattern: String? = nil, validationMessage: String? = nil) {
        self.name = name
        self.label = label
        self.type = type
        self.required = required
        self.placeholder = placeholder
        self.helpText = helpText
        self.options = options
        self.maxLength = maxLength
        self.minLength = minLength
        self.pattern = pattern
        self.validationMessage = validationMessage
    }
}

struct SelectOption: Codable {
    let value: String
    let label: String
}

struct FormValidation: Codable {
    let errorMessages: [String: String]
    let customValidationEndpoint: String?
    
    init(errorMessages: [String: String] = [:], customValidationEndpoint: String? = nil) {
        self.errorMessages = errorMessages
        self.customValidationEndpoint = customValidationEndpoint
    }
}

// MARK: - Screen Action

struct ScreenAction: Codable {
    let id: String
    let label: String
    let icon: String
    let action: String
    let navigateTo: String?
    let apiEndpoint: String?
    let requiresConfirmation: Bool
    let confirmationMessage: String?
    
    init(id: String, label: String, icon: String, action: String,
         navigateTo: String? = nil, apiEndpoint: String? = nil,
         requiresConfirmation: Bool = false, confirmationMessage: String? = nil) {
        self.id = id
        self.label = label
        self.icon = icon
        self.action = action
        self.navigateTo = navigateTo
        self.apiEndpoint = apiEndpoint
        self.requiresConfirmation = requiresConfirmation
        self.confirmationMessage = confirmationMessage
    }
    
    /// Resolves the row's id into any `{id}` placeholder in navigateTo / apiEndpoint.
    func resolved(for row: [String: String]) -> ScreenAction {
        guard let id = row["id"] ?? row["Id"] else { return self }
        return ScreenAction(
            id: self.id,
            label: label,
            icon: icon,
            action: action,
            navigateTo: navigateTo?.replacingOccurrences(of: "{id}", with: id),
            apiEndpoint: apiEndpoint?.replacingOccurrences(of: "{id}", with: id),
            requiresConfirmation: requiresConfirmation,
            confirmationMessage: confirmationMessage
        )
    }
}

// MARK: - Chart Screen

struct ChartScreenSpec: ScreenSpec {
    let type: String = "chart"
    let title: String
    let charts: [ChartSpec]
    let emptyStateMessage: String
    
    enum CodingKeys: String, CodingKey {
        case type, title, charts, emptyStateMessage
    }
}

struct ChartSpec: Codable {
    let id: String
    let title: String
    let subtitle: String?
    let chartType: String
    let labels: [String]
    let series: [ChartSeries]
    
    init(id: String, title: String, subtitle: String? = nil, chartType: String,
         labels: [String] = [], series: [ChartSeries] = []) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.chartType = chartType
        self.labels = labels
        self.series = series
    }
}

struct ChartSeries: Codable {
    let name: String
    let color: String?
    let points: [ChartDataPoint]
    
    init(name: String, color: String? = nil, points: [ChartDataPoint] = []) {
        self.name = name
        self.color = color
        self.points = points
    }
}

struct ChartDataPoint: Codable {
    let label: String
    let value: Double
    let color: String?
    
    init(label: String = "", value: Double, color: String? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }
}

// MARK: - Constants

enum ChartTypes {
    static let line = "line"
    static let bar = "bar"
    static let pie = "pie"
    static let donut = "donut"
    static let sparkline = "sparkline"
}

enum ActionTypes {
    static let navigate = "navigate"
    static let apiCall = "api-call"
    static let custom = "custom"
}

enum FieldTypes {
    static let text = "text"
    static let email = "email"
    static let phone = "phone"
    static let number = "number"
    static let date = "date"
    static let select = "select"
    static let multiselect = "multiselect"
    static let image = "image"
    static let badge = "badge"
    static let progress = "progress"
    static let percent = "percent"
    static let rating = "rating"
}

// MARK: - Coding Helpers

private struct DynamicKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
}

private struct ScreenTypeKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        return nil
    }
    
    static let type = ScreenTypeKey(stringValue: "type")!
}
