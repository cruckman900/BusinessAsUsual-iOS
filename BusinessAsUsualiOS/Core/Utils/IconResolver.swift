import SwiftUI

/// Maps backend-provided icon keys to SF Symbols (matches Android's MaterialIconResolver).
/// Android uses reflection to resolve Material Icon names; iOS uses a static mapping to SF Symbols.
struct IconResolver {
    /// Resolves a backend icon key (e.g. "person", "dashboard", "add") to an SF Symbol Image.
    /// Returns a fallback icon for unknown names.
    static func resolve(_ iconKey: String) -> Image {
        let normalized = iconKey.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Map common Material icon names to SF Symbols
        let symbolName: String = switch normalized {
        // Navigation & Core
        case "dashboard": "square.grid.2x2"
        case "home": "house"
        case "menu": "line.3.horizontal"
        case "back", "arrow_back": "chevron.left"
        case "forward", "arrow_forward": "chevron.right"
        case "arrow_up": "chevron.up"
        case "arrow_down": "chevron.down"
        case "close", "cancel": "xmark"
        case "check", "check_circle", "done": "checkmark.circle"
        case "info", "info_outline": "info.circle"
        case "settings": "gearshape"
        case "more_vert": "ellipsis"
        case "more_horiz": "ellipsis"
        case "expand_more": "chevron.down"
        case "expand_less": "chevron.up"
        
        // People & HR
        case "person", "people", "hr": "person.2"
        case "person_add", "add_person": "person.badge.plus"
        case "contacts": "person.crop.circle"
        case "group": "person.3"
        case "account_circle": "person.crop.circle"
        case "badge": "person.text.rectangle"
        
        // Business & CRM
        case "business", "work": "briefcase"
        case "crm", "customers": "briefcase"
        case "contact_mail": "envelope.badge.person.crop"
        case "assignment": "doc.text"
        case "description": "doc"
        case "note", "notes": "note.text"
        case "event": "calendar"
        case "schedule": "clock"
        
        // Finance & Money
        case "finance", "money", "attach_money": "dollarsign.circle"
        case "payment": "creditcard"
        case "receipt": "doc.plaintext"
        case "account_balance": "building.columns"
        case "trending_up": "chart.line.uptrend.xyaxis"
        case "trending_down": "chart.line.downtrend.xyaxis"
        
        // Actions
        case "add", "create", "plus": "plus.circle"
        case "edit", "mode_edit": "pencil"
        case "delete", "remove": "trash"
        case "save": "checkmark"
        case "refresh": "arrow.clockwise"
        case "search": "magnifyingglass"
        case "filter", "filter_list": "line.3.horizontal.decrease.circle"
        case "sort": "arrow.up.arrow.down"
        case "upload", "cloud_upload": "arrow.up.doc"
        case "download", "cloud_download": "arrow.down.doc"
        case "share": "square.and.arrow.up"
        case "print": "printer"
        case "visibility", "eye": "eye"
        case "visibility_off": "eye.slash"
        case "lock": "lock"
        case "lock_open": "lock.open"
        
        // Status & Feedback
        case "check_circle": "checkmark.circle.fill"
        case "cancel", "error": "xmark.circle.fill"
        case "warning": "exclamationmark.triangle.fill"
        case "help", "help_outline": "questionmark.circle"
        case "feedback": "bubble.left.and.bubble.right"
        case "star", "grade": "star.fill"
        case "star_border", "star_outline": "star"
        case "favorite": "heart.fill"
        case "favorite_border": "heart"
        case "thumb_up": "hand.thumbsup"
        case "thumb_down": "hand.thumbsdown"
        
        // Communication
        case "email", "mail": "envelope"
        case "send": "paperplane"
        case "inbox": "tray"
        case "message", "chat": "message"
        case "phone", "call": "phone"
        case "notifications": "bell"
        case "campaign": "megaphone"
        
        // Media & Files
        case "image", "photo": "photo"
        case "attach_file", "attachment": "paperclip"
        case "folder": "folder"
        case "insert_drive_file": "doc"
        case "cloud": "icloud"
        case "link": "link"
        
        // Data & Charts
        case "bar_chart": "chart.bar"
        case "pie_chart": "chart.pie"
        case "show_chart", "line_chart": "chart.xyaxis.line"
        case "analytics": "chart.bar.xaxis"
        case "assessment": "list.bullet.clipboard"
        case "table_chart": "tablecells"
        
        // Time & Calendar
        case "access_time", "time": "clock"
        case "today": "calendar.badge.clock"
        case "date_range": "calendar.badge.exclamationmark"
        case "history": "clock.arrow.circlepath"
        case "timer": "timer"
        
        // Organization
        case "category": "square.grid.3x3"
        case "label": "tag"
        case "bookmark": "bookmark"
        case "flag": "flag"
        case "list": "list.bullet"
        case "view_list": "list.bullet.rectangle"
        case "view_module": "square.grid.2x2"
        case "view_kanban", "view_column": "square.split.2x1"
        
        // Misc
        case "color_lens": "paintpalette"
        case "language": "globe"
        case "location_on", "place": "mappin"
        case "public": "network"
        case "extension": "puzzlepiece.extension"
        case "build": "wrench"
        case "bug_report": "ant"
        
        // Timeline-specific
        case "circle": "circle"
        
        // Fallback for unknown icons
        default: "questionmark.square.dashed"
        }
        
        return Image(systemName: symbolName)
    }
}
