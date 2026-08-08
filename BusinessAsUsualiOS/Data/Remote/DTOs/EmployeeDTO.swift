//
//  EmployeeDTO.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

import Foundation

struct EmployeeDTO: Codable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let department: String
    let jobTitle: String?
    let photoUrl: String?
    let hireDate: Date

    /// Maps the network DTO to the domain `Employee` entity.
    func toDomain() -> Employee {
        Employee(
            id: id,
            firstName: firstName,
            lastName: lastName,
            email: email,
            department: department,
            jobTitle: jobTitle,
            photoUrl: photoUrl,
            hireDate: hireDate
        )
    }

    /// Creates a DTO from a domain `Employee` entity.
    init(from employee: Employee) {
        self.id = employee.id
        self.firstName = employee.firstName
        self.lastName = employee.lastName
        self.email = employee.email
        self.department = employee.department
        self.jobTitle = employee.jobTitle
        self.photoUrl = employee.photoUrl
        self.hireDate = employee.hireDate
    }

    init(
        id: String,
        firstName: String,
        lastName: String,
        email: String,
        department: String,
        jobTitle: String? = nil,
        photoUrl: String? = nil,
        hireDate: Date
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.department = department
        self.jobTitle = jobTitle
        self.photoUrl = photoUrl
        self.hireDate = hireDate
    }
}
