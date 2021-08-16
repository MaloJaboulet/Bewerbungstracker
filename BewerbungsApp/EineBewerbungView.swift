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
            }
            .padding()
            
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    //Zeigt ob Bewerbung angenommen, abgesagt oder ausstehend ist
                    Label(eineBewerbung.absage != 0 ? (eineBewerbung.absage == 1 ? "Angenommen": "Abgelehnt") : "Ausstehend", systemImage: eineBewerbung.absage != 0 ? (eineBewerbung.absage == 1 ? "checkmark.circle.fill": "xmark.octagon.fill") : "hourglass.tophalf.fill")
                        
                        .padding(10)
                    Spacer()
                }
                .background(eineBewerbung.absage != 0 ? (eineBewerbung.absage == 1 ? Color.green: Color.red) : Color.yellow)
            }
            .offset(x: 0, y: -30)
        }
        .edgesIgnoringSafeArea(.bottom)
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
