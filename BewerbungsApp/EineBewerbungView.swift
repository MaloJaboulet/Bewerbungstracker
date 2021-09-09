//
//  EineBewerbungView.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 18.03.21.
//

import SwiftUI

struct EineBewerbungView: View {
    @State var eineBewerbung: Bewerbungen
    
    var body: some View {
        let formatterJahre = DateFormatter()
        formatterJahre.dateFormat = "dd.MM.yyyy"
        
        let formatterStunden = DateFormatter()
        formatterStunden.dateFormat = "dd.MM.yyyy HH:mm"
        
        
        return VStack(alignment: .leading, spacing: 10){
            
            Spacer()
            //Firmenname anzeigen
            VStack (alignment: .leading, spacing: 10){
                Text(eineBewerbung.firmenName ?? "Unknown")
                    .font(.title)
                
                //Eingabedatum anzeigen
                Text("Eingabedatum: \t\t\t\(formatterJahre.string(from: eineBewerbung.eingabeDatum!))")
                
                //Datum Bewerbungsgespräch anzeigen
                Text("Bewerbungsgespräche: \t\(eineBewerbung.bewerbungsGespraech != nil ? formatterStunden.string(from: eineBewerbung.bewerbungsGespraech!) : "Kein Datum")")
                Text("Antwort:  \t\t\t\t\t\(eineBewerbung.antwortAusstehen ? "ausstehened" : "eingegangen")")
                Text("Adresse:  \t\t\t\t\t\(eineBewerbung.adresse ?? "Unknown")")
                Text("Stadt:  \t\t\t\t\t\t\(eineBewerbung.stadt ?? "Unknown")")
            }
            .padding()
            
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    //Zeigt ob Bewerbung angenommen, abgesagt, aussteht oder eine Bewerbungsgespräch geplant, ist
                    Label(eineBewerbung.absage != 0 ? (eineBewerbung.absage != 1 ? (eineBewerbung.absage == 2 ? "Ausstehend" : "Abgeleht") : "Angenommen" ) : "Bewerbungsgespräch", systemImage: eineBewerbung.absage != 0 ? (eineBewerbung.absage != 1 ? (eineBewerbung.absage == 2 ? "hourglass.tophalf.fill" : "xmark.octagon") : "checkmark.circle" ) : "person.2.circle")
                        
                        .padding(10)
                    Spacer()
                }
                .background(eineBewerbung.absage != 0 ? (eineBewerbung.absage != 1 ? (eineBewerbung.absage == 2 ? Color.yellow : Color.red) : Color.green) : Color.purple)
            }
            .offset(x: 0, y: 0)
        }
        //.edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        .toolbar(content: {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                NavigationLink(
                    destination: EineBewerbungEinstellungen(eineBewerbung: eineBewerbung),
                    label: {
                        Text("Edit")
                    })
            }
        })
        
    }
}

/*struct EineBewerbungView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            EineBewerbungView(eineBewerbung: testDaten[0] )
        }
        
    }
}*/
