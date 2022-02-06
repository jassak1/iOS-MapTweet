//
//  MapVM.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 01/02/2022.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

class MapVM: ObservableObject{
    var moc = CoreController.moc.viewContext
    @Published var place = Place()
    @Published var showSheet = false
    @Published var showAlert = false
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20))
    @Published var selectedPin = CLLocationCoordinate2D()
    @Published var scaleSize:CGFloat = 0
    @Published var rotDegrees = Double()
    @Published var addNotation = false
    
    func decodeLocation(latitude: Double, longitude: Double) async throws -> (city: String, country: String) {
        try await (CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)).first?.locality ?? "NA",
                   CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)).first?.country ?? "NA")
    }
    
    @MainActor
    func newLocation(){
        let latitude = mapRegion.center.latitude
        let longitude = mapRegion.center.longitude
        Task{
            do{
                let city = try await decodeLocation(latitude: latitude, longitude: longitude)
                let newPlace = Place(context: moc)
                newPlace.id = UUID()
                newPlace.latitude = latitude
                newPlace.longitude = longitude
                newPlace.city = city.city
                newPlace.country = city.country
                if moc.hasChanges{
                    try? moc.save()
                }
            } catch{
                showAlert = true
            }
        }
    }
    
    func topIcon() -> String {
        return addNotation ? "mappin.slash" : "mappin"
    }
    
    func spinEffect(){
        withAnimation(.easeOut(duration: 1)){
            rotDegrees += 360
        }
        withAnimation(.easeInOut(duration: 0.5)){
            if addNotation {
                scaleSize = 1
            } else{
                scaleSize = 0
            }
        }
    }
}
