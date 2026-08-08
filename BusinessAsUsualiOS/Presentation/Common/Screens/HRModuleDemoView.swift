//
//  HRModuleDemoView.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import SwiftUI

public struct HRModuleDemoView: View {
    @StateObject private var vm = EmployeeListSpecViewModel(
        getSpecUseCase: GetEmployeeListSpecUseCaseImpl(repository: DIContainer.shared.uiSpecRepository)
    )
    private let specUrl: String

    public init(specUrl: String) {
        self.specUrl = specUrl
    }

    public var body: some View {
        Group {
            if let spec = vm.spec {
                // For now use sample employees until EmployeeRepository is implemented
                EmployeeListSpecView(spec: spec, employees: sampleEmployees)
            } else if let error = vm.errorMessage {
                Text(error).foregroundColor(.red)
            } else {
                ProgressView("Loading spec...")
            }
        }
        .task {
            await vm.load(specUrl: specUrl)
        }
    }

    private var sampleEmployees: [Employee] {
        [
            Employee(id: "1", firstName: "Alice", lastName: "Smith", email: "alice@example.com", department: "Engineering", jobTitle: "Engineer", photoUrl: nil, hireDate: Date()),
            Employee(id: "2", firstName: "Bob", lastName: "Jones", email: "bob@example.com", department: "Sales", jobTitle: "Sales Rep", photoUrl: nil, hireDate: Date())
        ]
    }
}

#if DEBUG
struct HRModuleDemoView_Previews: PreviewProvider {
    static var previews: some View {
        HRModuleDemoView(specUrl: "https://example.com/api/hr/mobile/ui-spec/employee-list")
            .previewLayout(.device)
    }
}
#endif
