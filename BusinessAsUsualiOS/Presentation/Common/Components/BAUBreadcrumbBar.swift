//
//  BAUBreadcrumbBar.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/30/25.
//
//  SwiftUI port of the Android BreadcrumbBar: a primary-colored footer showing
//  the navigation trail, where all but the last crumb are tappable.
//

import Foundation
import SwiftUI

struct BAUBreadcrumbBar: View {
    @Environment(\.bauTheme) private var theme
    let crumbs: [String]
    var onCrumbTap: (Int) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(crumbs.indices, id: \.self) { index in
                let isLast = index == crumbs.count - 1

                Text(crumbs[index])
                    .font(.subheadline)
                    .foregroundColor(theme.onPrimary.opacity(isLast ? 1.0 : 0.8))
                    .onTapGesture {
                        if !isLast { onCrumbTap(index) }
                    }

                if !isLast {
                    Text(">")
                        .font(.subheadline)
                        .foregroundColor(theme.onPrimary.opacity(0.5))
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(theme.primary)
    }
}
