//
//  Event+CoreDataProperties.swift
//  FavouriteEvents
//
//  Created by Charlie Nguyen on 04/11/2020.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var image: String?

}

extension Event : Identifiable {

}
