//
//  coreDataHelper.swift
//  MapPlaces
//
//  Created by KAK2164 on 09/10/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

//needs more work
import CoreData
import Foundation
import UIKit

class dbHelper: NSObject{
    
    static let sharedIns = dbHelper()
    
    override init(){
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "MapPlaces")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("\(error)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    /*
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("\(nserror)")
            }
        }
    }
     */
    func createManagedObject( entityName: String )->NSManagedObject {
        
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let item = NSManagedObject(entity: entity, insertInto: managedContext)
        return item
    }
    
    func saveDatabase(completion:(_ result: Bool ) -> Void) {
        
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            print(" \(error)")
            completion(false)
        }
    }
    
    func deleteManagedObject( managedObject: NSManagedObject, completion:(_ result: Bool ) -> Void) {
        
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        managedContext.delete(managedObject)
        
        do {
            try managedContext.save()
            completion(true)
        } catch let error as NSError {
            print("\(error)")
            completion(false)
        }
        
    }
    
    func resetContext(){
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        managedContext.reset()
    }
    
    func fetchAllResults() -> [MarkerListsMO] {
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkerLists")
        var markerLists: [MarkerListsMO] = []
        
        do {
            let fetchedMarkers = try managedContext.fetch(fetchAll) as! [MarkerListsMO]
            markerLists = fetchedMarkers
        } catch {
            print("\(error)")
        }
        print(markerLists.count)
        return markerLists
    }
    
    func fetchLargestRow() -> (rowNo: Int16, sheetID: String) {
        var returnMaxRow: Int16 = -1
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        let sheetID = getOwnSheetID()
        if sheetID == "none" || sheetID == "" {
            return (returnMaxRow, sheetID)
        }
        
        let fetchRow = NSFetchRequest<NSFetchRequestResult>(entityName: "MarkerLists")
        fetchRow.predicate = NSPredicate(format: "sheetID == %@", sheetID)
        fetchRow.fetchLimit = 1
        let sorter = NSSortDescriptor(key: "rowNo", ascending: false)
        fetchRow.sortDescriptors = [sorter]
        
        do {
            let maxRows = try managedContext.fetch(fetchRow) as! [MarkerListsMO]
            if maxRows.count > 0 {
                let maxRow = maxRows.first
                returnMaxRow = (maxRow?.rowNo)!
            } else {
                returnMaxRow = 0
            }
        } catch {
            print("failed fetch for largest row")
            returnMaxRow = 0
        }
        
        return (returnMaxRow, sheetID)
    }
        
    func getOwnSheetID() -> String {
        let managedContext = dbHelper.sharedIns.persistentContainer.viewContext
        let fetchAll = NSFetchRequest<NSFetchRequestResult>(entityName: "MyTable")
        var sheetID = "none"
        
        do {
            let fetchedMarkers = try managedContext.fetch(fetchAll) as! [MyTable]
            if fetchedMarkers.count > 0 {
                if let sheetIDTMP = fetchedMarkers[0].sheetID {
                    sheetID = sheetIDTMP
                }
            }
        } catch {
            print("\(error)")
        }
        return sheetID
    }
    
   
}

