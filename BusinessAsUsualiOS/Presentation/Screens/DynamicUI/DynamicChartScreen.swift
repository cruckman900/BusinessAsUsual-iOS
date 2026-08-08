import SwiftUI
import Charts

/// Dynamic chart screen renderer - displays charts from contract data.
/// Matches Android's ChartDashboard. Uses Swift Charts for native rendering.
struct DynamicChartScreen: View {
    let spec: ChartScreenSpec
    
    @Environment(\.bauTheme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(spec.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.onBackground)
                    .padding(.horizontal, 16)
                
                if spec.charts.isEmpty {
                    emptyState
                } else {
                    chartGrid
                }
            }
            .padding(.vertical, 16)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.xyaxis.line")
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
    
    private var chartGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
            ForEach(spec.charts, id: \.id) { chart in
                chartCard(chart)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var gridColumns: [GridItem] {
        [GridItem(.flexible()), GridItem(.flexible())]
    }
    
    private func chartCard(_ chart: ChartSpec) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(chart.title)
                .font(.headline)
                .foregroundColor(theme.onSurface)
            
            if let subtitle = chart.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(theme.onSurface.opacity(0.7))
            }
            
            chartView(chart)
                .frame(height: 200)
        }
        .padding(16)
        .background(theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 2, y: 1)
    }
    
    @ViewBuilder
    private func chartView(_ chart: ChartSpec) -> some View {
        switch chart.chartType {
        case ChartTypes.line:
            lineChart(chart)
        case ChartTypes.bar:
            barChart(chart)
        case ChartTypes.pie, ChartTypes.donut:
            pieChart(chart, isDonut: chart.chartType == ChartTypes.donut)
        case ChartTypes.sparkline:
            sparklineChart(chart)
        default:
            placeholderChart(chart)
        }
    }
    
    private func lineChart(_ chart: ChartSpec) -> some View {
        Chart {
            ForEach(chart.series, id: \.name) { series in
                ForEach(Array(series.points.enumerated()), id: \.offset) { index, point in
                    LineMark(
                        x: .value("Label", point.label.isEmpty ? chart.labels[safe: index] ?? "\(index)" : point.label),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(Color(hex: series.color ?? point.color ?? "0D66C2"))
                    .interpolationMethod(.catmullRom)
                }
                .symbol {
                    Circle()
                        .fill(Color(hex: series.color ?? "0D66C2"))
                        .frame(width: 6, height: 6)
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
    
    private func barChart(_ chart: ChartSpec) -> some View {
        Chart {
            ForEach(chart.series, id: \.name) { series in
                ForEach(Array(series.points.enumerated()), id: \.offset) { index, point in
                    BarMark(
                        x: .value("Label", point.label.isEmpty ? chart.labels[safe: index] ?? "\(index)" : point.label),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(Color(hex: series.color ?? point.color ?? "0D66C2"))
                }
            }
        }
    }
    
    @ViewBuilder
    private func pieChart(_ chart: ChartSpec, isDonut: Bool) -> some View {
        let series = chart.series.first
        let points = series?.points ?? []
        
        Chart(points, id: \.label) { point in
            SectorMark(
                angle: .value("Value", point.value),
                innerRadius: isDonut ? .ratio(0.5) : .ratio(0),
                angularInset: 1.5
            )
            .foregroundStyle(Color(hex: point.color ?? "0D66C2"))
        }
    }
    
    @ViewBuilder
    private func sparklineChart(_ chart: ChartSpec) -> some View {
        let series = chart.series.first
        let points = series?.points ?? []
        
        Group {
            Chart {
                ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                    LineMark(
                        x: .value("Index", index),
                        y: .value("Value", point.value)
                    )
                    .foregroundStyle(Color(hex: series?.color ?? "0D66C2"))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
        }
    }
    
    private func placeholderChart(_ chart: ChartSpec) -> some View {
        VStack {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 32))
                .foregroundColor(theme.onSurface.opacity(0.3))
            Text("Chart type: \(chart.chartType)")
                .font(.caption)
                .foregroundColor(theme.onSurface.opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Array Extension

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    let spec = ChartScreenSpec(
        title: "Analytics Dashboard",
        charts: [
            ChartSpec(
                id: "revenue",
                title: "Revenue",
                subtitle: "Last 6 months",
                chartType: ChartTypes.line,
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                series: [
                    ChartSeries(
                        name: "2024",
                        color: "0D66C2",
                        points: [
                            ChartDataPoint(value: 45000),
                            ChartDataPoint(value: 52000),
                            ChartDataPoint(value: 48000),
                            ChartDataPoint(value: 61000),
                            ChartDataPoint(value: 55000),
                            ChartDataPoint(value: 67000)
                        ]
                    )
                ]
            ),
            ChartSpec(
                id: "employees",
                title: "Employees by Department",
                chartType: ChartTypes.bar,
                series: [
                    ChartSeries(
                        name: "Count",
                        points: [
                            ChartDataPoint(label: "Engineering", value: 45, color: "0D66C2"),
                            ChartDataPoint(label: "Sales", value: 32, color: "1B5E20"),
                            ChartDataPoint(label: "Marketing", value: 18, color: "B26A00"),
                            ChartDataPoint(label: "HR", value: 12, color: "5F6368")
                        ]
                    )
                ]
            ),
            ChartSpec(
                id: "status",
                title: "Project Status",
                chartType: ChartTypes.pie,
                series: [
                    ChartSeries(
                        name: "Status",
                        points: [
                            ChartDataPoint(label: "Completed", value: 42, color: "1B5E20"),
                            ChartDataPoint(label: "In Progress", value: 35, color: "0D66C2"),
                            ChartDataPoint(label: "On Hold", value: 15, color: "B26A00"),
                            ChartDataPoint(label: "Cancelled", value: 8, color: "B3261E")
                        ]
                    )
                ]
            ),
            ChartSpec(
                id: "trend",
                title: "Sales Trend",
                subtitle: "Last 30 days",
                chartType: ChartTypes.sparkline,
                series: [
                    ChartSeries(
                        name: "Sales",
                        color: "1B5E20",
                        points: (1...30).map { _ in ChartDataPoint(value: Double.random(in: 50...100)) }
                    )
                ]
            )
        ],
        emptyStateMessage: "No charts available"
    )
    
    DynamicChartScreen(spec: spec)
        .environment(\.bauTheme, ThemeRegistry.resolve(name: "bau", dark: false))
}
