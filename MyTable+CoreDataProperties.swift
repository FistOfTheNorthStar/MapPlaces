//
//  MyTable+CoreDataProperties.swift
//  MapPlaces
//
//  Created by KAK2164 on 10/11/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//
//

import Foundation
import CoreData


extension MyTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyTable> {
        return NSFetchRequest<MyTable>(entityName: "MyTable")
    }

    @NSManaged public var sheetID: String?

}
