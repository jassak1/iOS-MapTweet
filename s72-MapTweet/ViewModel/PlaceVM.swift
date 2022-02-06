//
//  PlaceVM.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 04/02/2022.
//

import Foundation
import UIKit
import SwiftUI

class PlaceVM: ObservableObject, NetworkCaller{
    var moc = CoreController.moc.viewContext
    @Published var noConnection = false
    @Published var showSheet = false
    @Published var isLoading = true
    @Published var showAlert = false
    @Published var place: Place
    @Published var placeVM = NearPlace(name: "City", country: "Country", woeid: 1)
    @Published var image: UIImage
    
    func networkCall(latitude: Double, longitude: Double){
        Task{
            do{
                let data = try await networkController(latitude: latitude, longitude: longitude, woeid: nil)
                let response = try JSONDecoder().decode([NearPlace].self, from: data)
                placeVM = response.first ?? NearPlace(name: "NA", country: "NA", woeid: 1)
                isLoading = false
                noConnection = false
            }
            catch{
                print(error)
                noConnection = true
            }
        }
    }
    
    func saveLocation(){
        place.woeid = Int32(placeVM.woeid)
        place.image = image.jpegData(compressionQuality: 0.1)
        if moc.hasChanges{
            try? moc.save()
        }
    }
    
    func removeLocation(){
        moc.delete(place)
        try? moc.save()
    }
    
    init(place: Place, image: UIImage){
        self.place = place
        self.image = image
    }
}
