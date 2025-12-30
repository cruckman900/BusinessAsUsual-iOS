//
//  BAUTopBar.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct BAUTopBar: View {
    @Environment(\.bauTheme) private var theme
    let title: String
    
    var body: some View {
        ZStack {
            theme.primary
                .ignoresSafeArea(edges: .top)
            
            Text(title)
                .font(.headline)
                .foregroundColor(theme.onPrimary)
        }
        .frame(height: 56)
    }
}
