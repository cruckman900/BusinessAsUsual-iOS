//
//  UISpecModels.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

// Top-level UI spec for a module
public struct ModuleUISpecDTO: Codable {
    public let moduleId: String
    public let moduleName: String
    public let version: String?
    public let navigation: NavigationSpecDTO?
    public let screens: [String: ScreenSpecDTO]?
}

public struct NavigationSpecDTO: Codable {
    public let items: [NavItemDTO]
}

public struct NavItemDTO: Codable {
    public let id: String
    public let label: String
    public let icon: String?
    public let screen: String?
    public let route: String?
}

public struct ScreenSpecDTO: Codable {
    // For list screens, we expect an EmployeeListSpec shape
    public let title: String?
    public let searchPlaceholder: String?
    public let enableSearch: Bool?
    public let enableFilter: Bool?
    public let columns: [ColumnSpecDTO]?
    public let actions: [ActionSpecDTO]?
    public let filters: [FilterSpecDTO]?
    public let sections: [SectionSpecDTO]?
}

public struct ColumnSpecDTO: Codable, Identifiable {
    public let name: String
    public let label: String?
    public let type: String
    public let width: Int?
    public let sortable: Bool?

    public var id: String { name }
}

public struct ActionSpecDTO: Codable {
    public let id: String
    public let label: String?
    public let icon: String?
    public let action: String?
    public let navigateTo: String?
    public let apiEndpoint: String?
}

public struct FilterSpecDTO: Codable {
    public let id: String
    public let label: String?
    public let type: String?
    public let values: [FilterValueDTO]?
}

public struct FilterValueDTO: Codable {
    public let id: String?
    public let label: String?
    public let value: String?
}

public struct SectionSpecDTO: Codable {
    public let id: String
    public let title: String?
    public let fields: [FieldSpecDTO]?
}

public struct FieldSpecDTO: Codable {
    public let name: String
    public let label: String?
    public let type: String
    public let required: Bool?
    public let maxLength: Int?
    public let pattern: String?
    public let validationMessage: String?
}
