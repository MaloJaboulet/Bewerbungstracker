//
//  BewerbungZeile.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 20.03.21.
//
import SwiftUI

struct BewerbungZeile: View {
    @ObservedObject var bewerbung: Bewerbungen
    
    var body: some View {
        NavigationLink(destination: EineBewerbungView(eineBewerbung: bewerbung)){
            HStack(){
                Text(bewerbung.firmenName ?? "Unknown")
                    .font(.title)
                    .padding()
                Spacer()
            }.background(bewerbung.absage != 0 ? (bewerbung.absage != 1 ? (bewerbung.absage == 2 ? Color.yellow : Color.red) : Color.green) : Color.purple)
        }
    
    }
}

/*struct BewerbungZeile_Previews: PreviewProvider {
    static var previews: some View {
        BewerbungZeile(bewerbung: testDaten[1])
    }
}
*/
