//
//  EmployeeListSpecView.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import SwiftUI

// A lightweight renderer for an Employee List screen based on a ScreenSpecDTO
public struct EmployeeListSpecView: View {
    public let spec: ScreenSpecDTO
    public let employees: [Employee]

    public init(spec: ScreenSpecDTO, employees: [Employee]) {
        self.spec = spec
        self.employees = employees
    }

    public var body: some View {
        VStack {
            if let title = spec.title {
                Text(title)
                    .font(.headline)
                    .padding(.top)
            }

            if spec.enableSearch ?? false {
                // simple non-functional search bar placeholder
                TextField(spec.searchPlaceholder ?? "Search", text: .constant(""))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .trailing])
            }

            List(employees) { employee in
                HStack(spacing: 12) {
                    ForEach(spec.columns ?? []) { column in
                        columnView(column: column, employee: employee)
                    }
                }
                .padding(.vertical, 6)
            }
        }
        .padding(.bottom)
    }

    @ViewBuilder
    private func columnView(column: ColumnSpecDTO, employee: Employee) -> some View {
        switch column.type {
        case "image":
            if let urlStr = employee.photoUrl, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray.frame(width: CGFloat(column.width ?? 40), height: 40)
                    case .success(let image):
                        image.resizable().aspectRatio(contentMode: .fill)
                            .frame(width: CGFloat(column.width ?? 40), height: 40)
                            .clipShape(Circle())
                    case .failure:
                        Color.gray.frame(width: CGFloat(column.width ?? 40), height: 40)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Color.gray.frame(width: CGFloat(column.width ?? 40), height: 40)
            }
        case "text":
            Text(textFor(column: column, employee: employee))
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
        case "badge":
            Text(textFor(column: column, employee: employee))
                .font(.caption)
                .padding(6)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
        default:
            Text(textFor(column: column, employee: employee))
        }
    }

    private func textFor(column: ColumnSpecDTO, employee: Employee) -> String {
        switch column.name {
        case "photoUrl":
            return ""
        case "fullName":
            return employee.fullName
        case "email":
            return employee.email
        case "department":
            return employee.department
        default:
            // try reflectively
            let mirror = Mirror(reflecting: employee)
            if let child = mirror.children.first(where: { $0.label == column.name }) {
                return "\(child.value)"
            }
            return ""
        }
    }
}

// Make ColumnSpecDTO conform to Identifiable for ForEach
// (Identifiable conformance is declared on the model type in UISpecModels.swift)

#if DEBUG
struct EmployeeListSpecView_Previews: PreviewProvider {
    static var sampleSpec: ScreenSpecDTO {
        ScreenSpecDTO(
            title: "Employees",
            searchPlaceholder: "Search employees...",
            enableSearch: true,
            enableFilter: true,
            columns: [
                ColumnSpecDTO(name: "photoUrl", label: "Photo", type: "image", width: 40, sortable: false),
                ColumnSpecDTO(name: "fullName", label: "Name", type: "text", width: 200, sortable: true),
                ColumnSpecDTO(name: "email", label: "Email", type: "text", width: 200, sortable: false)
            ],
            actions: [ActionSpecDTO(id: "add", label: "Add Employee", icon: "add", action: "navigate", navigateTo: "/hr/employees/new", apiEndpoint: nil)],
            filters: nil,
            sections: nil
        )
    }

    static var sampleEmployees: [Employee] {
        [
            Employee(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", department: "Engineering", jobTitle: "Engineer", photoUrl: nil, hireDate: Date()),
            Employee(id: "2", firstName: "Bob", lastName: "Jones", email: "bob@example.com", department: "Sales", jobTitle: "Sales Rep", photoUrl: nil, hireDate: Date())
        ]
    }

    static var previews: some View {
        EmployeeListSpecView(spec: sampleSpec, employees: sampleEmployees)
            .previewLayout(.sizeThatFits)
    }
}
#endif
