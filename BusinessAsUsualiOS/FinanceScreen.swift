//
//  FinanceScreen.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct FinanceScreen: View {
    var body: some View {
        BAUScreenShell(
            title: "Finance",
            breadcrumbs: ["Dashboard", "Finance"],
            currentRoute: .finance
        ) {
            Text("Finance Module")
                .padding()
        }
    }
}
