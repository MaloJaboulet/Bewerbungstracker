//
//  EineBwerbungAdden.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 20.03.21.
//

import SwiftUI
import CoreLocation

struct EineBewerbungAdden: View {
    @State private var rueckmeldung = 0
    @State private var firmenName = ""
    @State private var datum = Date()
    @State private var bewerbungsGespraech = false
    @State private var adresse: String = ""
    @State private var stadt: String = ""
    @ObservedObject var liste: BewerbungsListe
    
    
    @State private var coordinates = CLLocationCoordinate2D()
    
    @Environment (\.presentationMode) var presentationMode: Binding <PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    var body: some View {
        
        VStack{
            Text("Eine Bewerbung hinzufügen")
                .font(.title)
            Spacer()
            
            //Eingabe Firmenname
            TextField("Firmennamen eingeben", text: $firmenName)
                .padding()
                .border(Color.gray)
                .autocapitalization(.none)
            
            //Die Adresse eingeben
            TextField("Adresse der Firma eingeben", text: $adresse)
                .padding()
                .border(Color.gray)
            
            //Die Stadt eingeben
            TextField("Die Stadt der Firma eingeben", text: $stadt)
                .padding()
                .border(Color.gray)
            
            
            
            // Auswählen ob schon ein Bewerbungsgespräche geplant wurde
            Toggle(isOn: $bewerbungsGespraech) {
                Text("Bewerbungsgespräche")
                
            }
            .toggleStyle(SwitchToggleStyle())
            
            
            //Ein Datum auswählen
            if bewerbungsGespraech{
                DatePicker("Datum des Bewerbunggespräches", selection: $datum, in: Date()...)
            }
            Spacer()
            
            //Bewerbung speichern
            if bewerbungsGespraech{
                Button(action: {
                    //liste.bewerbungen.append(EineBewerbung(FirmenName: firmenName, EingabeDatum: Date(), BewerbungsGespraech: datum, Absage: 0, AntwortAusstehen: true))
                    if !firmenName.isEmpty { //Wenn der Name der Firma nicht eingetragen wurde, wird die Bewerbung nicht gespeichert.
                        let bewerbungD = Bewerbungen(context: managedObjectContext)
                        bewerbungD.id = UUID()
                        bewerbungD.firmenName = firmenName
                        bewerbungD.eingabeDatum = Date()
                        bewerbungD.absage = 0
                        bewerbungD.antwortAusstehen = true
                        bewerbungD.bewerbungsGespraech = datum
                        bewerbungD.adresse = "\(adresse), \(stadt), Switzerland"
                        bewerbungD.stadt = stadt
                        
                        
                        self.getCoordinate(addressString: adresse){ (responseCoordinate, error) in
                            if error == nil {
                                self.coordinates = responseCoordinate
                                bewerbungD.lat = self.coordinates.latitude
                                bewerbungD.long = self.coordinates.longitude
                                print("Done \(self.adresse)")
                            }
                        }
                        
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print("Bewerbung konnte nicht gespeichert werden.")
                        }
                    }
                    
                    self.presentationMode.wrappedValue.dismiss() // Geht eine View nach oben
                }, label: {
                    Text("Speichern")
                })
            } else{
                Button(action: {
                    //liste.bewerbungen.append(EineBewerbung(FirmenName: firmenName, EingabeDatum: Date(), AntwortAusstehen: true))
                    if !firmenName.isEmpty { //Wenn der Name der Firma nicht eingetragen wurde, wird die Bewerbung nicht gespeichert.
                        let bewerbungD = Bewerbungen(context: managedObjectContext)
                        bewerbungD.id = UUID()
                        bewerbungD.firmenName = firmenName
                        bewerbungD.eingabeDatum = Date()
                        bewerbungD.absage = 0
                        bewerbungD.antwortAusstehen = true
                        bewerbungD.bewerbungsGespraech = nil
                        bewerbungD.adresse = "\(adresse), \(stadt), Switzerland"
                        bewerbungD.stadt = stadt

                        self.getCoordinate(addressString: adresse){ (responseCoordinate, error) in
                            if error == nil {
                                self.coordinates = responseCoordinate
                                bewerbungD.lat = self.coordinates.latitude
                                bewerbungD.long = self.coordinates.longitude
                                print("Done \(self.adresse)")
                            }
                        }
                        
                        do{
                            try self.managedObjectContext.save()
                        }catch{
                            print("Bewerbung konnte nicht gespeichert werden.")
                        }
                    }
                    self.presentationMode.wrappedValue.dismiss() // Geht eine View nach oben
                    
                }, label: {
                    Text("Speichern")
                })
                
                
            }
        }
        .preferredColorScheme(.dark)
        .padding()
    }
    
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemaks, error) in
            
            //print("Placemark \(placemaks)")
            if error == nil {
                if let placemark = placemaks?[0]{
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
            
        }
    }
}

struct EineBewerbungAdden_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            //EineBewerbungAdden(liste: testListe)
        }
    }
}
