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
    @State private var speichern: Bool = false
    
    
    @State private var coordinates = CLLocationCoordinate2D()
    
    @Environment (\.presentationMode) var presentationMode: Binding <PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    var backButton : some View { Button(action: {
        self.presentationMode.wrappedValue.dismiss()
    }) {
        Label("Canel", systemImage: "chevron.backward")
        
    }
    }
    
    var body: some View {
        
        VStack{
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
            Button(action: {
                self.speichern = true
                self.presentationMode.wrappedValue.dismiss() // Geht eine View nach oben
            }, label: {
                Text("Speichern")
            })
        }
        
        .navigationBarTitle("Bewerbung hinzufügen", displayMode: .automatic)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .preferredColorScheme(.dark)
        .padding()
        .onDisappear(){
            if speichern{
                let bewerbungD = Bewerbungen(context: managedObjectContext)
                if bewerbungsGespraech{
                    if !firmenName.isEmpty { //Wenn der Name der Firma nicht eingetragen wurde, wird die Bewerbung nicht gespeichert.
                        //Speichert alle Daten, auch das Bewerbungsgespräch
                        datenSpeichern(Bewerbung: bewerbungD, Firmenname: firmenName, Absage: 0, Bewerbungsgespräch: datum, Adresse: adresse, Stadt: stadt)
                    }
                }else{
                    if !firmenName.isEmpty { //Wenn der Name der Firma nicht eingetragen wurde, wird die Bewerbung nicht gespeichert.
                        //Speichert alle Daten ohne das Bewerbungsgespräch
                        datenSpeichern(Bewerbung: bewerbungD, Firmenname: firmenName, Absage: 2, Bewerbungsgespräch: nil, Adresse: adresse, Stadt: stadt)
                    }
                }
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
                self.speichern = false
            }
        }
    }
    
    
    func getCoordinate(addressString: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void){
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(addressString) { (placemaks, error) in
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
    
    
    func datenSpeichern(Bewerbung bewerbung:Bewerbungen, Firmenname firmenname: String, Absage absage: Int16, Bewerbungsgespräch bewerbungsgespraech: Date?, Adresse adresse: String, Stadt stadt: String){
        bewerbung.id = UUID()
        bewerbung.firmenName = firmenname
        bewerbung.eingabeDatum = Date()
        bewerbung.absage = absage
        bewerbung.bewerbungsGespraech = bewerbungsgespraech
        bewerbung.antwortAusstehen = true
        bewerbung.adresse = "\(adresse), \(stadt), Switzerland"
        bewerbung.stadt = stadt
    }
}

struct EineBewerbungAdden_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            //EineBewerbungAdden(liste: testListe)
        }
    }
}
