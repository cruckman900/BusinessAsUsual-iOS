//
//  NavigationRouter.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI
import Combine

class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }

    /// Selects a top-level module from the drawer/breadcrumbs: returns to the
    /// dashboard root, then pushes the module (unless it *is* the dashboard).
    /// Mirrors the Android drawer navigation behavior.
    func select(_ route: Route) {
        popToRoot()
        if route != .dashboard {
            navigate(to: route)
        }
    }
}
