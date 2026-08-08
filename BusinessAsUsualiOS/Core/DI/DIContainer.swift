//
//  Container.swift
//  BusinessAsUsualiOS
//
//  Dependency injection container for the app. Provides factories for
//  repositories, use cases, and view models (matches Android's Koin modules).
//

import Foundation

/// Singleton dependency injection container.
final class DIContainer {
    static let shared = DIContainer()
    
    // MARK: - Core Services
    
        lazy var apiClient: APIClient = {
        APIClient(baseURL: Configuration.apiBaseURL)
    }()
    
    // MARK: - Repositories
    
        lazy var moduleRepository: ModuleRepository = {
        ModuleRepositoryImpl(apiClient: apiClient)
    }()
    
        lazy var mobileUIRepository: MobileUIRepository = {
        MobileUIRepositoryImpl(apiClient: apiClient)
    }()
    
        lazy var uiSpecRepository: UISpecRepositoryProtocol = {
        UISpecRepositoryImpl(service: uiSpecService)
    }()
    
    private lazy var uiSpecService: UISpecServiceProtocol = {
        UISpecService()
    }()
    
    // MARK: - Use Cases
    
        lazy var getModulesUseCase: GetModulesUseCase = {
        GetModulesUseCase(repository: moduleRepository)
    }()
    
        lazy var getModuleUIContractUseCase: GetModuleUIContractUseCase = {
        GetModuleUIContractUseCase(repository: mobileUIRepository)
    }()
    
        lazy var getScreenDataUseCase: GetScreenDataUseCase = {
        GetScreenDataUseCase(repository: mobileUIRepository)
    }()
    
    private init() {}
}
