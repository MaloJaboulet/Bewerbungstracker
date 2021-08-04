//
//  Test.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 21.03.21.
//

import SwiftUI

struct Test: View {
    var bewerbungListe:BewerbungsListe
    
    var body: some View {
        ForEach(bewerbungListe.bewerbungen){ bewerbung in
            HStack {
                Text(" \(bewerbung.firmenName)")
                Text(" \(bewerbung.bewerbungsGespraech!)")
            }
            
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test(bewerbungListe: testListe)
    }
}
