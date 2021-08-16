//
//  MapClass.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 06.08.21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var centerCoordinate: CLLocationCoordinate2D
    var annotations: [MKPointAnnotation]
    
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(MKCoordinateRegion(center: centerCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        mapView.showsUserLocation = true
        return mapView
    }

    //Setzt neue Pins
    func updateUIView(_ view: MKMapView, context: Context) {
        //view.setRegion(MKCoordinateRegion(center: centerCoordinate,span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: false)
        if annotations.count != view.annotations.count {
                print("Pin Count \(annotations)")
                view.removeAnnotations(view.annotations)
                view.addAnnotations(annotations)
            }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
                parent.centerCoordinate = mapView.centerCoordinate
        }
    }
}

