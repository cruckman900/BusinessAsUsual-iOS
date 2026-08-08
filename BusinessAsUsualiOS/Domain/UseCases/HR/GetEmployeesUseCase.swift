//
//  GetEmployeesUseCase {.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

protocol GetEmployeesUseCase {
    func execute() async throws -> [Employee]
}

class GetEmployeesUseCaseImpl: GetEmployeesUseCase {
    private let repository: IEmployeeRepository
    
    init(repository: IEmployeeRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Employee] {
        // Offline-first: try local first
        if let cached = try? await repository.getLocalEmployees(), !cached.isEmpty {
            // Return cached, fetch fresh in background
            Task {
                let fresh = try? await repository.getRemoteEmployees()
                if let fresh = fresh {
                    try? await repository.saveLocalEmployees(fresh)
                }
            }
            return cached
        }
        
        // No cache, must fetch
        let employees = try await repository.getRemoteEmployees()
        try? await repository.saveLocalEmployees(employees)
        return employees
    }
}
