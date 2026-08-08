//
//  CRMScreen.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct CRMScreen: View {
    var body: some View {
        BAUScreenShell(
            title: "CRM",
            breadcrumbs: ["Dashboard", "CRM"],
            currentRoute: .crm
        ) {
            Text("CRM Module")
                .padding()
        }
    }
}
