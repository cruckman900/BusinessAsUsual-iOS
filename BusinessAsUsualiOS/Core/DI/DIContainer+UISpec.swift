//
//  DIContainer+UISpec.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation

public enum DIContainer {
    // Lazily created shared instances for now. Replace with a proper DI framework later.
    public static var uiSpecService: UISpecServiceProtocol = UISpecService()
    public static var uiSpecRepository: UISpecRepositoryProtocol = UISpecRepositoryImpl(service: uiSpecService)
}
