//
//  EineBewerbungEinstellungen.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 21.03.21.
//

import SwiftUI
import CoreLocation

struct EineBewerbungEinstellungen: View {
    
    var eineBewerbung: Bewerbungen
    @State private var bewerbungsStatus:Int = 0
    @State private var bewerbungsGespraechDatum:Date = Date()
    @State private var firmenName = ""
    @State private var adresse: String = ""
    @State private var stadt: String = ""
    @State private var bewerbungsGespraech = false
    @Environment (\.presentationMode) var presentationMode: Binding <PresentationMode>
    @State private var coordinates = CLLocationCoordinate2D()
    
    
    
    var body: some View {
        VStack{
            Spacer()
            
            TextField("Firmennamen eingeben", text: $firmenName)
                .padding()
                .border(Color.gray)
            
            //Die Adresse eingeben
            TextField("Adresse der Firma eingeben", text: $adresse)
                .padding()
                .border(Color.gray)
            
            //Die Stadt eingeben
            TextField("Die Stadt der Firma eingeben", text: $stadt)
                .padding()
                .border(Color.gray)
            
            
            //Wählt den Bewerbungsstatus aus
            VStack {
                Text("Bewerbungsstatus")
                    .offset(x: 0, y: 75)
                    .font(.headline)
                Picker(selection: $bewerbungsStatus, label: Text("Bewerbungsstatus")){
                    Text("Ausstehend").tag(4)
                    Text("Angenommen").tag(2)
                    Text("Abgelehnt").tag(3)
                }
                .labelsHidden()
            }
            
            Toggle(isOn: $bewerbungsGespraech) {
                Text("Bewerbungsgespräche")
            }
            .toggleStyle(SwitchToggleStyle())
            
            
            //Ein Datum auswählen
            if bewerbungsGespraech{
                DatePicker("Datum des Bewerbunggespräches", selection: $bewerbungsGespraechDatum , in: Date()...)
            }
            
            Spacer()
            
        }
        .navigationBarTitle("Einstellungen")
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
        .padding()
        .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing, content: {
                Button("Done") {
                    
                    if !firmenName.isEmpty{
                        eineBewerbung.firmenName = firmenName
                    }
                    
                    if bewerbungsStatus != eineBewerbung.absage{
                        if bewerbungsStatus == 4 {
                            bewerbungsStatus = 0
                        }
                        eineBewerbung.absage = Int16(bewerbungsStatus)
                        eineBewerbung.antwortAusstehen = false
                        
                    }
                    if !adresse.isEmpty {
                        eineBewerbung.adresse = adresse
                        
                        getCoordinate(addressString: "\(adresse), \(eineBewerbung.stadt ?? "Unknown"), Switzerland"){ (responseCoordinate, error) in
                            if error == nil {
                                self.coordinates = responseCoordinate
                                eineBewerbung.lat = self.coordinates.latitude
                                eineBewerbung.long = self.coordinates.longitude
                                print("Done \(self.adresse)")
                            }
                        }
                    }
                    
                    if !stadt.isEmpty{
                        eineBewerbung.stadt = stadt
                    }
                    if bewerbungsGespraech {
                        eineBewerbung.bewerbungsGespraech = bewerbungsGespraechDatum
                        eineBewerbung.absage = 1
                        eineBewerbung.antwortAusstehen = false
                    }
                    
                    self.presentationMode.wrappedValue.dismiss() // Geht eine View nach oben
                }
            })
            
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading, content: {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss() // Geht eine View nach oben
                }
            })
        })
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

/*struct EineBewerbungEinstellungen_Previews: PreviewProvider {
 static var previews: some View {
 NavigationView{
 EineBewerbungEinstellungen(eineBewerbung: testDaten[1])
 }
 }
 }*/
