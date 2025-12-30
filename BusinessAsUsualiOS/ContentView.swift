//
//  ContentView.swift
//  BusinessAsUsualiOS
//
//  Created by Christopher Ruckman on 12/29/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("BAUPrimary")
                .ignoresSafeArea()
            
            Text("Business As Usual")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    ContentView()
}
