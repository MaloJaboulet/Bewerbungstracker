//
//  StartSeiteBewerbung.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 20.03.21.
//

import SwiftUI
import CoreLocation

struct StartSeiteBewerbung: View {    
    @ObservedObject var liste: BewerbungsListe
    @FetchRequest(entity: Bewerbungen.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Bewerbungen.absage, ascending: true), NSSortDescriptor(keyPath: \Bewerbungen.firmenName, ascending: true)]) var bewerbungen: FetchedResults<Bewerbungen>
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State private var deletePinLocation: CLLocationCoordinate2D?
    
    @State private var isActive: Bool = true
    
    private var lat: Double{
        return locationManager.lastLocation?.coordinate.latitude ?? 0
    }
    private var long : Double {
        return locationManager.lastLocation?.coordinate.longitude ?? 0
    }
    
    
    @StateObject var locationManager = LocationManager()
    
    
    
    
    var body: some View {
        
        TabView{
            
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
                    
                    List{
                        ForEach(bewerbungen, id: \.id){ bewerbung in
                            //Text(bewerbung.firmenName ?? "Unknown")
                            Text("\(bewerbung.lat) \(bewerbung.long)")
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
                            /*NavigationLink(destination: EineBewerbungAdden(liste: liste)){
                             Text("Add")
                             }
                             .isDetailLink(false)*/
                            
                            
                            
                            NavigationLink(destination: EineBewerbungAdden(liste: liste)){
                                Text("Add")
                            }
                            .isDetailLink(false)
                            .disabled(!isActive)
                            
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .tabItem {
                Label("Bewerbungen", systemImage: "list.bullet")
            }
            
            NavigationView{
                MapDisplay(bewerbungen: bewerbungen, centerCoordinate:   CLLocationCoordinate2D(latitude: lat, longitude: long), deletePinLocation: $deletePinLocation)
            }
            .tabItem {
                Label("Map", systemImage: "map")
            }
        }
        .preferredColorScheme(.dark)
        .onAppear(){
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                locationManager.startUpdatingLocation(isActive: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                locationManager.startUpdatingLocation(isActive: false)
            }
            
            //isActive = true
        }
        
        
        
        
        
        
        
        
    }
    
    func deleteBewerbung(at offsets: IndexSet) {
        for index in offsets {
            let bewerbung = bewerbungen[index]
            managedObjectContext.delete(bewerbung)
            deletePinLocation = CLLocationCoordinate2D(latitude: bewerbung.lat, longitude: bewerbung.long)
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
