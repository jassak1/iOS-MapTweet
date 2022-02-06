//
//  Protocols.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 06/02/2022.
//

import Foundation

protocol NetworkCaller{
    func networkController(latitude: Double?, longitude: Double?, woeid: Int?) async throws -> Data
}

extension NetworkCaller{
    @MainActor
    func networkController(latitude: Double?, longitude: Double?, woeid: Int?) async throws -> Data{
        var url: URL{
            guard let woeid = woeid else {
                return URL(string: "https://api.twitter.com/1.1/trends/closest.json?lat=\(latitude!)&long=\(longitude!)")!
            }
            return URL(string:"https://api.twitter.com/1.1/trends/place.json?id=\(woeid)")!
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer YOUR_API_TOKEN_GOES_HERE", forHTTPHeaderField: "Authorization")
        let data = try await URLSession.shared.asyncData(urlRequest: request)
        return data
    }
}
