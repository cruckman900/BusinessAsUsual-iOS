//
//  BAUScreenShell.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//

import Foundation
import SwiftUI

struct BAUScreenShell<Content: View>: View {
    let title: String
    let breadcrumbs: [String]
    let content: Content
    
    @Environment(\.bauTheme) private var theme
    
    init(
        title: String,
        breadcrumbs: [String],
        @ViewBuilder _ content: () -> Content
    ) {
        self.title = title
        self.breadcrumbs = breadcrumbs
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BAUTopBar(title: title)
            
            Content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.background)
            
            BAUBreadcrumbBar(crumbs: breadcrumbs)
        }
        .background(theme.background)
    }
}
