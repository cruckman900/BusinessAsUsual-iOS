//
//  HRScreen.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct HRScreen: View {
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        BAUScreenShell(
            title: "HR",
            breadcrumbs: ["Dashboard", "HR"],
            currentRoute: .hr
        ) {
            VStack {
                Text("HR Module")
                Button("Go to Employee Detail") {
                    router.navigate(to: .detail("123"))
                }
            }
            .padding()
        }
    }
}
