//
//  ContentView.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 18.03.21.
//

import SwiftUI

struct ContentView: View {
    var index = 0
    var body: some View {
        NavigationView{
            List{
                Text("Hello")
                Text("Hello")
                Text("Hello")
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
