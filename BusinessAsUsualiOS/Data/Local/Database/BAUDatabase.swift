//
//  BAUDatabase.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 7/16/26.
//

// Create .xcdatamodeld file
// Add EmployeeEntity with attributes:
// - id: String
// - firstName: String
// - lastName: String
// - email: String
// - department: String
// - etc.

import CoreData

// Data/Local/Database/BAUDatabase.swift
class BAUDatabase {
    static let shared = BAUDatabase()

    /// Programmatically defined Core Data model (avoids needing an `.xcdatamodeld` file).
    static let managedObjectModel: NSManagedObjectModel = {
        let model = NSManagedObjectModel()

        let employee = NSEntityDescription()
        employee.name = "EmployeeEntity"
        employee.managedObjectClassName = NSStringFromClass(EmployeeEntity.self)

        func attribute(_ name: String, _ type: NSAttributeType) -> NSAttributeDescription {
            let attr = NSAttributeDescription()
            attr.name = name
            attr.attributeType = type
            attr.isOptional = true
            return attr
        }

        employee.properties = [
            attribute("id", .stringAttributeType),
            attribute("firstName", .stringAttributeType),
            attribute("lastName", .stringAttributeType),
            attribute("email", .stringAttributeType),
            attribute("department", .stringAttributeType),
            attribute("jobTitle", .stringAttributeType),
            attribute("photoUrl", .stringAttributeType),
            attribute("hireDate", .dateAttributeType)
        ]

        model.entities = [employee]
        return model
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(
            name: "BusinessAsUsual",
            managedObjectModel: Self.managedObjectModel
        )
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}

// Data/Local/DAO/EmployeeDAO.swift
class EmployeeDAO {
    private let context: NSManagedObjectContext
    
    init(database: BAUDatabase) {
        self.context = database.context
    }
    
    func getAll() async throws -> [EmployeeEntity] {
        let request: NSFetchRequest<EmployeeEntity> = EmployeeEntity.fetchRequest()
        return try context.fetch(request)
    }
    
    func insert(_ entity: EmployeeEntity) async throws {
        context.insert(entity)
        try context.save()
    }
    
    func deleteAll() async throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = EmployeeEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
    }
}
