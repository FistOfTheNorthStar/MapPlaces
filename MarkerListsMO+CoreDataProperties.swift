//
//  MarkerListsMO+CoreDataProperties.swift
//  MapPlaces
//
//  Created by KAK2164 on 10/11/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension MarkerListsMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarkerListsMO> {
        return NSFetchRequest<MarkerListsMO>(entityName: "MarkerLists")
    }

    @NSManaged public var icon: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var rowNo: Int16
    @NSManaged public var sheetID: String?
    @NSManaged public var snippet: String?
    @NSManaged public var title: String?

}
