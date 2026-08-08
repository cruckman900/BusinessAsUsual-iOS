import SwiftUI

// MARK: - Status Chip

/// Rounded chip with icon + label, color-coded by semantic tone.
/// Matches Android's StatusChip rendering exactly.
struct StatusChip: View {
    let value: String
    @Environment(\.bauTheme) private var theme
    
    var body: some View {
        if value.isBlank {
            Text("—")
                .font(.subheadline)
        } else {
            chipContent
        }
    }
    
    private var chipContent: some View {
        let tone = statusTone(for: value)
        let (container, content) = colors(for: tone)
        
        return HStack(spacing: 4) {
            icon(for: tone)
                .font(.system(size: 14))
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(container)
        .foregroundColor(content)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private func icon(for tone: StatusTone) -> Image {
        switch tone {
        case .positive: return Image(systemName: "checkmark.circle.fill")
        case .warning: return Image(systemName: "clock.fill")
        case .negative: return Image(systemName: "xmark.circle.fill")
        case .neutral: return Image(systemName: "circle.fill")
        }
    }
    
    private func colors(for tone: StatusTone) -> (Color, Color) {
        switch tone {
        case .positive:
            return (Color(hex: "1B5E20").opacity(0.14), Color(hex: "1B5E20"))
        case .warning:
            return (Color(hex: "B26A00").opacity(0.16), Color(hex: "B26A00"))
        case .negative:
            return (Color(hex: "B3261E").opacity(0.14), Color(hex: "B3261E"))
        case .neutral:
            return (theme.surface, theme.onSurface.opacity(0.7))
        }
    }
}

// MARK: - Progress Bar Cell

/// Thin colored bar + label ("60%" or "36/50"). Web parity thresholds.
/// Matches Android's ProgressBarCell.
struct ProgressBarCell: View {
    let value: String
    
    var body: some View {
        if let (percent, label) = parseProgress(value) {
            progressBar(percent: percent, label: label)
        } else {
            Text(value.isEmpty ? "—" : value)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    private func progressBar(percent: Float, label: String) -> some View {
        let color = progressColor(percent: percent)
        
        return HStack(spacing: 8) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color.opacity(0.18))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percent / 100), height: 8)
                }
            }
            .frame(height: 8)
            
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
        }
    }
    
    private func progressColor(percent: Float) -> Color {
        switch percent {
        case 80...100: return Color(hex: "1B5E20") // success
        case 50..<80: return Color(hex: "0D66C2")  // info
        case 25..<50: return Color(hex: "B26A00")  // warning
        default: return Color(hex: "B3261E")       // error
        }
    }
}

// MARK: - Percent Ring

/// Small circular progress indicator with centered percent value.
/// Matches Android's PercentRing (MudProgressCircular).
struct PercentRing: View {
    let value: String
    
    var body: some View {
        if let percent = parsePercent(value) {
            ring(percent: percent)
        } else {
            Text(value.isEmpty ? "—" : value)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    private func ring(percent: Float) -> some View {
        let color = progressColor(percent: percent)
        
        return ZStack {
            Circle()
                .stroke(color.opacity(0.18), lineWidth: 3)
            
            Circle()
                .trim(from: 0, to: CGFloat(percent / 100))
                .stroke(color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(percent))")
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(width: 40, height: 40)
    }
    
    private func progressColor(percent: Float) -> Color {
        switch percent {
        case 80...100: return Color(hex: "1B5E20")
        case 50..<80: return Color(hex: "0D66C2")
        case 25..<50: return Color(hex: "B26A00")
        default: return Color(hex: "B3261E")
        }
    }
}

// MARK: - Star Rating Cell

/// Renders 1–5 stars (filled / half / empty) from numeric value.
/// Matches Android's StarRatingCell (MudRating).
struct StarRatingCell: View {
    let value: String
    
    var body: some View {
        if let rating = parseRating(value) {
            starsView(rating: rating)
        } else {
            Text(value.isEmpty ? "—" : value)
                .font(.subheadline)
                .lineLimit(1)
        }
    }
    
    private func starsView(rating: Float) -> some View {
        let amber = Color(hex: "F6A609")
        
        return HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                starIcon(for: index, rating: rating)
                    .foregroundColor(amber)
                    .font(.system(size: 16))
            }
        }
    }
    
    private func starIcon(for index: Int, rating: Float) -> Image {
        if rating >= Float(index) {
            return Image(systemName: "star.fill")
        } else if rating >= Float(index) - 0.5 {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}

// MARK: - Stat Cards Row

/// Horizontal scroll of small stat tiles (icon, value, label, semantic color).
/// Matches Android's StatCardsRow.
struct StatCardsRow: View {
    let stats: [StatCard]
    @Environment(\.bauTheme) private var theme
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(stats, id: \.id) { stat in
                    statCard(stat)
                }
            }
        }
    }
    
    private func statCard(_ stat: StatCard) -> some View {
        let accent = statColor(tone: stat.tone)
        
        return VStack(alignment: .leading, spacing: 4) {
            if !stat.icon.isEmpty {
                IconResolver.resolve(stat.icon)
                    .font(.system(size: 18))
                    .foregroundColor(accent)
            }
            
            Text(stat.value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(accent)
            
            Text(stat.label)
                .font(.caption)
                .foregroundColor(theme.onSurface.opacity(0.7))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(minWidth: 96)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.05), radius: 1, y: 1)
    }
    
    private func statColor(tone: String) -> Color {
        switch tone.lowercased().trimmingCharacters(in: .whitespaces) {
        case "positive", "success": return Color(hex: "1B5E20")
        case "warning": return Color(hex: "B26A00")
        case "negative", "error": return Color(hex: "B3261E")
        case "info": return Color(hex: "0D66C2")
        default: return Color(hex: "5F6368")
        }
    }
}

// MARK: - Helper Functions & Types

enum StatusTone {
    case positive, warning, negative, neutral
}

/// Maps a free-text status/badge value to a semantic tone.
/// Matches Android's statusToneFor() logic exactly.
func statusTone(for value: String) -> StatusTone {
    let v = value.lowercased().trimmingCharacters(in: .whitespaces)
    if v.isEmpty { return .neutral }
    
    let positive = ["active", "approved", "completed", "complete", "passed", "pass", "hired",
                    "current", "valid", "enrolled", "on track", "ontrack", "paid", "open",
                    "success", "won", "excellent", "good", "met", "achieved", "verified",
                    "submitted", "confirmed", "yes"]
    
    let warning = ["pending", "in progress", "in-progress", "inprogress", "review", "in review",
                   "scheduled", "draft", "on hold", "onhold", "waiting", "expiring", "at risk",
                   "atrisk", "partial", "probation", "onboarding", "interview", "offered", "maybe"]
    
    let negative = ["inactive", "rejected", "failed", "fail", "expired", "overdue", "terminated",
                    "cancelled", "canceled", "declined", "closed", "lost", "off track", "offtrack",
                    "missed", "denied", "blocked", "suspended", "no"]
    
    if negative.contains(where: { v.contains($0) }) { return .negative }
    if warning.contains(where: { v.contains($0) }) { return .warning }
    if positive.contains(where: { v.contains($0) }) { return .positive }
    return .neutral
}

/// Parses a leading numeric percent from strings like "60%", "60", "  75 %".
func parsePercent(_ raw: String) -> Float? {
    guard let match = raw.range(of: "-?\\d+(\\.\\d+)?", options: .regularExpression) else {
        return nil
    }
    let numStr = String(raw[match])
    return Float(numStr)?.clamped(to: 0...100)
}

/// Parses a "used/total" fraction (e.g. "36/50") into percent + label.
func parseFraction(_ raw: String) -> (Float, String)? {
    guard let match = raw.range(of: "(\\d+(?:\\.\\d+)?)\\s*/\\s*(\\d+(?:\\.\\d+)?)", options: .regularExpression) else {
        return nil
    }
    let matchStr = String(raw[match])
    let parts = matchStr.split(separator: "/").map { $0.trimmingCharacters(in: .whitespaces) }
    guard parts.count == 2,
          let used = Float(parts[0]),
          let total = Float(parts[1]),
          total > 0 else {
        return nil
    }
    let percent = (used / total * 100).clamped(to: 0...100)
    return (percent, "\(parts[0])/\(parts[1])")
}

/// Parses progress value (handles both "60%" and "36/50").
func parseProgress(_ raw: String) -> (Float, String)? {
    if let (percent, label) = parseFraction(raw) {
        return (percent, label)
    }
    if let percent = parsePercent(raw) {
        return (percent, "\(Int(percent))%")
    }
    return nil
}

/// Parses a numeric rating value (e.g. "4.5", "3").
func parseRating(_ raw: String) -> Float? {
    guard let match = raw.range(of: "-?\\d+(\\.\\d+)?", options: .regularExpression) else {
        return nil
    }
    let numStr = String(raw[match])
    return Float(numStr)
}

// MARK: - Extensions

extension Float {
    func clamped(to range: ClosedRange<Float>) -> Float {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}

extension String {
    var isBlank: Bool {
        trimmingCharacters(in: .whitespaces).isEmpty
    }
}
