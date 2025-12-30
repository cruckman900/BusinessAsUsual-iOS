//
//  ContentView.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/29/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.bauTheme) private var theme
    
    var body: some View {
        ZStack {
            theme.background
                .ignoresSafeArea()
            
            Text("Business As Usual")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(theme.onBackground)
        }
    }
}

#Preview {
    ContentView()
}
