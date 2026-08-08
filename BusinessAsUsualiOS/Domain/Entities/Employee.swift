//
//  Employee.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

import Foundation

public struct Employee: Identifiable, Equatable, Codable {
    public let id: String
    public let firstName: String
    public let lastName: String
    public let email: String
    public let department: String
    public let jobTitle: String?
    public let photoUrl: String?
    public let hireDate: Date

    public var fullName: String {
        "\(firstName) \(lastName)"
    }

    public init(
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
