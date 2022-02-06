//
//  Model.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 01/02/2022.
//

import Foundation
import CoreLocation
import UIKit



struct NearPlace: Codable{
    let name: String
    let country: String
    let woeid: Int
}

struct PlaceTrends: Codable{
    let trends: [HashTags]
    
    struct HashTags: Codable, Hashable{
        let name: String
        let tweet_volume: Int?
    }
}
