//
//  DetailScreen.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct DetailScreen: View {
    let id: String
    
    var body: some View {
        BAUScreenShell(
            title: "Detail",
            breadcrumbs: ["Dashboard", "HR", "Employee \(id)"],
            currentRoute: .hr
        ) {
            Text("Employee Detail for \(id)")
                .padding()
        }
    }
}
