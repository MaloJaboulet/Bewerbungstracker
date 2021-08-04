//
//  EineBewerbungDaten.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 18.03.21.
//
import Combine
import Foundation

class EineBewerbung: ObservableObject, Identifiable {
    var id = UUID()
    @Published var firmenName:String
    var eingabeDatum: Date
    @Published var bewerbungsGespraech:Date?
    @Published var absage:Int16
    var antwortAusstehen: Bool
    
    
    init(FirmenName firmenName :String, EingabeDatum eingabeDatum:Date, AntwortAusstehen antwortAusstehen:Bool) {
        self.firmenName = firmenName
        self.eingabeDatum = eingabeDatum
        self.antwortAusstehen = antwortAusstehen
        self.absage = 0
        self.bewerbungsGespraech = nil
    }
    
    init(FirmenName firmenName :String, EingabeDatum eingabeDatum:Date, BewerbungsGespraech bewerbungsGespraech:Date, Absage absage:Int16, AntwortAusstehen antwortAusstehen:Bool){
        self.firmenName = firmenName
        self.eingabeDatum = eingabeDatum
        self.bewerbungsGespraech = bewerbungsGespraech
        self.absage = absage
        self.antwortAusstehen = antwortAusstehen
    }
    
    func setDatum(Datum datum:Date){
        bewerbungsGespraech = datum
    }
    
    func setStatus(Status status:Int16){
        absage = status
    }
}



let testDaten = [
    EineBewerbung.init(FirmenName: "Google",EingabeDatum: Date(), AntwortAusstehen: false),
    EineBewerbung.init(FirmenName: "Migros", EingabeDatum: Date(), BewerbungsGespraech: Date(), Absage: 1, AntwortAusstehen: true),
    EineBewerbung.init(FirmenName: "Coop", EingabeDatum: Date(), BewerbungsGespraech: Date(), Absage: 2, AntwortAusstehen: false)
]
