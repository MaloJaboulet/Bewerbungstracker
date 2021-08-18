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
                        Spacer()
                    }
                }else{
                    
                    List{
                        ForEach(bewerbungen, id: \.id){ bewerbung in
                            BewerbungZeile(bewerbung: bewerbung)
                        }
                        .onDelete(perform: deleteBewerbung)
                        
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
                            NavigationLink(destination: EineBewerbungAdden(liste: liste)){
                                Text("Add")
                            }
                            
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
        }
    }
    
    
    func deleteBewerbung(at offsets: IndexSet) {
        for index in offsets {
            let bewerbung = bewerbungen[index]
            managedObjectContext.delete(bewerbung)
            deletePinLocation = CLLocationCoordinate2D(latitude: bewerbung.lat, longitude: bewerbung.long)
        }
    }
}

struct StartSeiteBewerbung_Previews: PreviewProvider {
    static var previews: some View {
        StartSeiteBewerbung(liste: testListe)
    }
}
