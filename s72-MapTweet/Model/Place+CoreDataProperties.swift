//
//  Place+CoreDataProperties.swift
//  s72-MapTweet
//
//  Created by Adam Jassak on 04/02/2022.
//
//

import Foundation
import CoreData


extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var woeid: Int32
    
    var cityU: String{
        city ?? "NA"
    }
    var countryU: String{
        country ?? "NA"
    }
    var imageU: Data{
        image ?? Data()
    }

}

extension Place : Identifiable {

}
