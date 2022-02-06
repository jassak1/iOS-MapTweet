//
//  HashtagsVM.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 05/02/2022.
//

import Foundation
import UIKit

class HashtagsVM: ObservableObject, NetworkCaller{
    @Published var shownView = ShownView.loading
    @Published var selectedHT = String()
    @Published var showSheet = false
    @Published var hashtagsVM = [PlaceTrends.HashTags]()
    
    func networkCall(woeid: Int){
        Task{
            do{
                let data = try await networkController(latitude: nil, longitude: nil, woeid: woeid)
                let response = try JSONDecoder().decode([PlaceTrends].self, from: data)
                hashtagsVM = response.first?.trends ?? [PlaceTrends.HashTags]()
                shownView = .success
            } catch{
                print(error)
                shownView = .error
                await UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    
    var worldPlace = {() -> Place in
        let world = Place(context: CoreController.moc.viewContext)
        world.id = UUID()
        world.woeid = 1
        world.country = "World"
        world.city = "World"
        return world
    }()
    
    enum ShownView{
        case success, loading, error
    }
    
    
}
