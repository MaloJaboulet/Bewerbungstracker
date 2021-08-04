//
//  EineBwerbungAdden.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 20.03.21.
//

import SwiftUI

struct EineBewerbungAdden: View {
    @State private var rueckmeldung = 0
    @State private var firmenName = ""
    @State private var datum = Date()
    @State private var bewerbungsGespraech = false
    @ObservedObject var liste: BewerbungsListe
    
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
}

struct EineBewerbungAdden_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            //EineBewerbungAdden(liste: testListe)
        }
    }
}
