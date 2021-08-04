//
//  EineBewerbungEinstellungen.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 21.03.21.
//

import SwiftUI

struct EineBewerbungEinstellungen: View {
    
    var eineBewerbung: Bewerbungen
    @State private var bewerbungsStatus:Int = 0
    @State private var bewerbungsGespraechDatum:Date = Date()
    @State private var firmenName = ""
    @State private var bewerbungsGespraech = false
    @Environment (\.presentationMode) var presentationMode: Binding <PresentationMode>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    
    var body: some View {
        VStack{
            Spacer()
            
            TextField("Firmennamen eingeben", text: $firmenName)
                .padding()
                .border(Color.gray)
         
            
            //Wählt den Bewerbungsstatus aus
            VStack {
                Text("Bewerbungsstatus")
                    .offset(x: 0, y: 75)
                    .font(.headline)
                Picker(selection: $bewerbungsStatus, label: Text("Bewerbungsstatus")){
                    Text("Ausstehend").tag(0)
                    Text("Angenommen").tag(1)
                    Text("Abgelehnt").tag(2)
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
                    print(bewerbungsStatus)
                    
                    if bewerbungsGespraech {
                        eineBewerbung.bewerbungsGespraech = bewerbungsGespraechDatum
                    }
                    if !firmenName.isEmpty{
                        eineBewerbung.firmenName = firmenName
                    }
                    if bewerbungsStatus != eineBewerbung.absage{
                        eineBewerbung.absage = Int16(bewerbungsStatus)
                    }
                    
                    
                    /*do{
                        try self.managedObjectContext.save()
                    }catch{
                        print("Bewerbung konnte nicht gespeichert werden.")
                    }*/
                    
                   /* if bewerbungsGespraech{
                        eineBewerbung.setDatum(Datum: bewerbungsGespraechDatum)
                    }
                    if !firmenName.isEmpty{
                        eineBewerbung.firmenName = firmenName
                    }
                    eineBewerbung.setStatus(Status: bewerbungsStatus)
 */
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

/*struct EineBewerbungEinstellungen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            EineBewerbungEinstellungen(eineBewerbung: testDaten[1])
        }
    }
}*/
