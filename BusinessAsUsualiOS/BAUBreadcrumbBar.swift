//
//  BAUBreadcrumbBar.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct BAUBreadcrumbBar: View {
    @Environment(\.bauTheme) private var theme
    let crumbs: [String]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(crumbs.indices, id: \.self) { index in
                Text(crumbs[index])
                    .font(.caption)
                    .foregroundColor(theme.onPrimary.opacity(0.9))
                
                if index < crumbs.count - 1 {
                    Text(">")
                        .foregroundColor(theme.onPrimary.opacity(0.6))
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(theme.primary)
    }
}
