//
//  EmployeeSpecDomain.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

public struct EmployeeListSpec {
    public let title: String?
    public let columns: [ColumnSpecDTO]
    public let enableSearch: Bool
    public let searchPlaceholder: String?

    public init(from dto: ScreenSpecDTO) {
        self.title = dto.title
        self.columns = dto.columns ?? []
        self.enableSearch = dto.enableSearch ?? false
        self.searchPlaceholder = dto.searchPlaceholder
    }
}
