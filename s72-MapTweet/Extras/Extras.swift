//
//  Extras.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 03/02/2022.
//

import Foundation
import CoreLocation
import CoreData

extension CLLocationCoordinate2D: Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}

extension NSItemProvider{
    func asyncLoadObject(ofClass: NSItemProviderReading.Type) async throws -> NSItemProviderReading{
        try await withCheckedThrowingContinuation{continuation in
            self.loadObject(ofClass: ofClass){response, error in
                guard let response = response else {
                    return continuation.resume(throwing: error!)
                }
                continuation.resume(returning: response)
            }
        }
    }
}

extension URLSession{
    func asyncData(urlRequest: URLRequest) async throws -> Data {
        try await withCheckedThrowingContinuation{continuation in
            let task = self.dataTask(with: urlRequest){data, response, error in
                guard let data = data else {
                    return continuation.resume(throwing: error!)
                }
                continuation.resume(returning: data)
            }
            task.resume()
        }
    }
}

class CoreController{
    static let moc = {() -> NSPersistentContainer in
        let container = NSPersistentContainer(name: "MapTweet")
        container.loadPersistentStores(completionHandler: {description, error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
        })
        return container
    }()
}

