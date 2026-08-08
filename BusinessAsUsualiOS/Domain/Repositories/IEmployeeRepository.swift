//
//  IEmployeeRepository.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

protocol IEmployeeRepository {
    func getRemoteEmployees() async throws -> [Employee]
    func getLocalEmployees() async throws -> [Employee]
    func saveLocalEmployees(_ employees: [Employee]) async throws
    func createEmployee(_ employee: Employee) async throws -> Employee
    func updateEmployee(_ employee: Employee) async throws -> Employee
    func deleteEmployee(id: String) async throws
}
