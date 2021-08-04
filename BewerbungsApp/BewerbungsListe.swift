//
//  BewerbungsListe.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 20.03.21.
//

import Foundation

class BewerbungsListe: ObservableObject {
    @Published var bewerbungen:[EineBewerbung]
    
    init(bewerbungen: [EineBewerbung] = []) {
        self.bewerbungen = bewerbungen
    }
}



let testListe = BewerbungsListe(bewerbungen: testDaten)

