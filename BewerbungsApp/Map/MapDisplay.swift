//
//  MapView.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 05.08.21.
//

import SwiftUI
import MapKit


struct MapDisplay: View {
    var bewerbungen: FetchedResults<Bewerbungen>
    let geocoder = CLGeocoder()
    @State var centerCoordinate: CLLocationCoordinate2D
    @State private var locations = [MKPointAnnotation]()
    @Binding var deletePinLocation: CLLocationCoordinate2D?
    @State private var coordinates = CLLocationCoordinate2D()
    
    
    
    
    
    var body: some View {
        VStack{
            MapView(centerCoordinate: $centerCoordinate, annotations: locations)
                .edgesIgnoringSafeArea(.all)
        }
        .navigationTitle("Orte")
        .onAppear(perform: {
            locations = []
            
            //Löscht die Pins, die auf 0.0 sind
            var i = 0
            while (i < locations.count) {
                if locations[i].coordinate.latitude == 0.0 && locations[i].coordinate.longitude == 0.0 {
                    self.locations.remove(at: i)
                }
                i += 1
            }
            
            
            deletePin(deletePinLoaction: deletePinLocation)
            
            
            //Updatet alle Koordinaten der Bewerbungen
            setCoordinatesBewerbungen(bewerbungenListe: bewerbungen)
        })
    }
    
    
    
    
    //Löscht den Pin, wenn die Bewerbung gelöscht wurde.
    func deletePin(deletePinLoaction: CLLocationCoordinate2D?){
        for _ in bewerbungen {
            if self.deletePinLocation != nil{
                var i = 0
                while i < locations.count {
                    if deletePinLocation!.latitude == locations[i].coordinate.latitude && deletePinLocation!.longitude == locations[i].coordinate.longitude {
                        locations.remove(at: i)
                    }
                    i += 1
                }
            }
        }
        self.deletePinLocation = nil
    }
    
    
    func setCoordinatesBewerbungen(bewerbungenListe: FetchedResults<Bewerbungen>){
        for bewerbung in bewerbungenListe{
            //Wenn die Koordinaten nicht vorhanden sind, werden sie hier erzeugt
            if bewerbung.lat == 0.0 || bewerbung.long == 0.0{
                
                
                getCoordinate(addressString: bewerbung.adresse ?? "Unknown"){ (responseCoordinate, error) in
                    if error == nil {
                        coordinates = responseCoordinate
                        bewerbung.lat = coordinates.latitude
                        bewerbung.long = coordinates.longitude
                        print("Done \(bewerbung.adresse ?? "unknown")")
                    }
                }
            }
            
            //Macht einen neuen Pin auf der Map
            let newLocation = MKPointAnnotation()
            newLocation.title = bewerbung.firmenName
            newLocation.subtitle = bewerbung.adresse
            newLocation.coordinate = CLLocationCoordinate2D(latitude: bewerbung.lat, longitude: bewerbung.long)
            self.locations.append(newLocation)
        }
    }
    
    
    //Convertiert die Adresse zu den Koordinaten
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
}

