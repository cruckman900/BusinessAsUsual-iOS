//
//  EmployeeEntity.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

import CoreData

/// Core Data managed object for a persisted employee record.
///
/// The Core Data model for this entity is defined programmatically in
/// `BAUDatabase` (see `BAUDatabase.managedObjectModel`), so no `.xcdatamodeld`
/// file is required.
@objc(EmployeeEntity)
public class EmployeeEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeEntity> {
        NSFetchRequest<EmployeeEntity>(entityName: "EmployeeEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var department: String?
    @NSManaged public var jobTitle: String?
    @NSManaged public var photoUrl: String?
    @NSManaged public var hireDate: Date?
}

extension EmployeeEntity {

    /// Creates and inserts a managed object from a domain `Employee`.
    @discardableResult
    static func from(_ employee: Employee, context: NSManagedObjectContext) -> EmployeeEntity {
        let entity = EmployeeEntity(context: context)
        entity.id = employee.id
        entity.firstName = employee.firstName
        entity.lastName = employee.lastName
        entity.email = employee.email
        entity.department = employee.department
        entity.jobTitle = employee.jobTitle
        entity.photoUrl = employee.photoUrl
        entity.hireDate = employee.hireDate
        return entity
    }

    /// Maps the managed object back to a domain `Employee`.
    func toDomain() -> Employee {
        Employee(
            id: id ?? "",
            firstName: firstName ?? "",
            lastName: lastName ?? "",
            email: email ?? "",
            department: department ?? "",
            jobTitle: jobTitle,
            photoUrl: photoUrl,
            hireDate: hireDate ?? Date()
        )
    }
}
