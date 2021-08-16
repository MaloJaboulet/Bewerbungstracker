//
//  EineBewerbungDaten.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 18.03.21.
//
import Combine
import Foundation
import CoreLocation

class EineBewerbung: ObservableObject, Identifiable {
    var id = UUID()
    @Published var firmenName:String
    var eingabeDatum: Date
    @Published var bewerbungsGespraech:Date?
    @Published var absage:Int16
    var antwortAusstehen: Bool
    @Published var lat: Double
    @Published var long: Double
    var adresse:String
    var stadt:String
    
    
    
    init(FirmenName firmenName :String, EingabeDatum eingabeDatum:Date, AntwortAusstehen antwortAusstehen:Bool, Adresse adresse:String, Stadt stadt:String, Latitude latitude: Double, Longitude longitude: Double) {
        self.firmenName = firmenName
        self.eingabeDatum = eingabeDatum
        self.antwortAusstehen = antwortAusstehen
        self.absage = 0
        self.bewerbungsGespraech = nil
        self.lat = latitude
        self.long = longitude
        self.adresse = "\(adresse), \(stadt)"
        self.stadt = stadt
        
    }
    
    init(FirmenName firmenName :String, EingabeDatum eingabeDatum:Date, BewerbungsGespraech bewerbungsGespraech:Date, Absage absage:Int16, AntwortAusstehen antwortAusstehen:Bool, Adresse adresse:String, Stadt stadt:String, Latitude latitude: Double, Longitude longitude: Double){
        self.firmenName = firmenName
        self.eingabeDatum = eingabeDatum
        self.bewerbungsGespraech = bewerbungsGespraech
        self.absage = absage
        self.antwortAusstehen = antwortAusstehen
        self.lat = latitude
        self.long = longitude
        self.adresse = "\(adresse), \(stadt)"
        self.stadt = stadt
    }
    
    func setDatum(Datum datum:Date){
        bewerbungsGespraech = datum
    }
    
    func setStatus(Status status:Int16){
        absage = status
    }
}



let testDaten = [
    EineBewerbung.init(FirmenName: "Google",EingabeDatum: Date(), AntwortAusstehen: false, Adresse: "Brandschenkestrasse 110", Stadt: "Zürich", Latitude: 47.36550, Longitude: 8.52446),
    EineBewerbung.init(FirmenName: "Migros", EingabeDatum: Date(), BewerbungsGespraech: Date(), Absage: 1, AntwortAusstehen: true, Adresse: "Limmatstrasse 152",Stadt: "Zürich", Latitude: 47.38555, Longitude: 8.53109),
    EineBewerbung.init(FirmenName: "Coop", EingabeDatum: Date(), BewerbungsGespraech: Date(), Absage: 2, AntwortAusstehen: false, Adresse: "Baslerstrasse 50", Stadt: "Zürich",Latitude: 47.38775, Longitude: 8.49803)
]
