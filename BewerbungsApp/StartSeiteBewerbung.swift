//
//  StartSeiteBewerbung.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 20.03.21.
//

import SwiftUI

struct StartSeiteBewerbung: View {    
    @ObservedObject var liste: BewerbungsListe
    @State private var isActive: Bool = false
    @FetchRequest(entity: Bewerbungen.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Bewerbungen.absage, ascending: true), NSSortDescriptor(keyPath: \Bewerbungen.firmenName, ascending: true)]) var bewerbungen: FetchedResults<Bewerbungen>
    @Environment(\.managedObjectContext) var managedObjectContext
    var body: some View {
        
        NavigationView{
            if bewerbungen.count == 0 {
                
                VStack {
                    Text("Bewerbungstracker")
                        .font(.title)
                    Spacer()
                    NavigationLink(destination: EineBewerbungAdden(liste: liste)){
                        Text("Bewerbung hinzufügen")
                            .font(.title)
                        
                    }
                    .isDetailLink(false)
                    Spacer()
                }
            }else{
                /*List{
                    ForEach(liste.bewerbungen){ bewerbung in
                        BewerbungZeile(bewerbung: bewerbung)
                    }
                    .onDelete(perform: deleteBewerbung)
                    .onMove(perform: moveBewerbung)
                    
                    HStack{
                        Spacer()
                        Text("\(liste.bewerbungen.count) Bewerbungen")
                        Spacer()
                    }
                    
                }*/
                List{
                    ForEach(bewerbungen, id: \.id){ bewerbung in
                        //Text(bewerbung.firmenName ?? "Unknown")
                        BewerbungZeile(bewerbung: bewerbung)
                    }
                    .onDelete(perform: deleteBewerbung)
                    //.onMove(perform: moveBewerbung)
                    
                    HStack{
                        Spacer()
                        Text("\(bewerbungen.count) Bewerbungen")
                        Spacer()
                    }
                    
                }
                .navigationBarTitle("Bewerbungstracker")
                .toolbar{
                    #if os(iOS)
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading){
                        EditButton()
                        
                    }
                    #endif
                    
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing){
                        NavigationLink(
                            destination: EineBewerbungAdden(liste: liste)){
                            Text("Add")
                            
                        }
                        .isDetailLink(false)
                        
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        
        
        
        
        
        
        
    }
    
    func deleteBewerbung(at offsets: IndexSet) {
        for index in offsets {
                let bewerbung = bewerbungen[index]
                managedObjectContext.delete(bewerbung)
            }
    }
    
    /*func moveBewerbung(from: IndexSet ,to: Int) {
        liste.bewerbungen.move(fromOffsets: from, toOffset: to)
    }*/
}

struct StartSeiteBewerbung_Previews: PreviewProvider {
    static var previews: some View {
        StartSeiteBewerbung(liste: testListe)
    }
}
