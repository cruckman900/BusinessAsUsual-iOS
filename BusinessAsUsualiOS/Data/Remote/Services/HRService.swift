//
//  HRService.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

class HRService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func getEmployees() async throws -> [EmployeeDTO] {
        try await client.request(
            .getEmployees,
            responseType: [EmployeeDTO].self
        )
    }
    
    func createEmployee(_ dto: EmployeeDTO) async throws -> EmployeeDTO {
        try await client.request(
            .createEmployee(dto),
            responseType: EmployeeDTO.self
        )
    }
}

// APIEndpoint+HR.swift
extension APIEndpoint {
    static let getEmployees = APIEndpoint(
        path: "/api/hr/employees",
        method: .get
    )
    
    static func createEmployee(_ dto: EmployeeDTO) -> APIEndpoint {
        APIEndpoint(
            path: "/api/hr/employees",
            method: .post,
            body: dto
        )
    }
}
