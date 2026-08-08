//
//  EmployeeListSpecViewModel.swift
//  BusinessAsUsualiOS
//
//  Created by automated assistant on 7/16/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
public class EmployeeListSpecViewModel: ObservableObject {
    @Published public var spec: ScreenSpecDTO?
    @Published public var errorMessage: String?

    private let getSpecUseCase: GetEmployeeListSpecUseCase

    public init(getSpecUseCase: GetEmployeeListSpecUseCase) {
        self.getSpecUseCase = getSpecUseCase
    }

    public func load(specUrl: String) async {
        do {
            let screenSpec = try await getSpecUseCase.execute(specUrl: specUrl)
            self.spec = screenSpec
        } catch {
            self.errorMessage = "Failed to load spec: \(error)"
        }
    }
}
