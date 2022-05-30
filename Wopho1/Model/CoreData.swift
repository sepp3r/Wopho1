//
//  CoreData.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 11.05.20.
//  Copyright © 2020 Sebastian Schmitt. All rights reserved.
//

import Foundation
import CoreData


class CoreData {
    
    // MARK: - Singleton Pattern
    static let defaults = CoreData()
    
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        
    }
    
    // MARK: - PersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - CRUD - Create / Read / Update / Delete
    
    // Create
    func createData(_postUid: String) -> CompanyUser {
        let user = CompanyUser(context: context)
        user.postUid = _postUid
//        user.postLike = _postLike
        saveContext()
        return user
    }
    
//    func payedInfo(_payed: Bool) -> CompanyUser {
//        let user = CompanyUser(context: context)
//        user.payed = _payed
//        saveContext()
//        return user
//    }
    
    // delete Ausflug -> test
    func deleteData(_postUid: String, _postLike: Int16) -> CompanyUser {
        let user = CompanyUser(context: context)
        user.postUid = _postUid
        user.postLike = _postLike
        
        return user
    }
    
    // Read
    func loadData() -> [CompanyUser]? {
        let fetchRequest: NSFetchRequest<CompanyUser> = CompanyUser.fetchRequest() // Nur die Anfrage
        
        do {
            let resultArray = try context.fetch(fetchRequest)
            return resultArray
        } catch {
            print("Fehler beim lader der Daten", error.localizedDescription)
        }
        
        return nil
    }
    
    // delete all stuff
    func deleteCoreDataStuff() {
        let deleteData = NSFetchRequest<NSFetchRequestResult>(entityName: "CompanyUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteData)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Fehler beim löschen", error.localizedDescription)
        }
    }
    
    // delete V4
//    func deleteVFour () {
//        let fetchRequest = NSFetchRequest<CompanyUser>(entityName: "CompanyUser")
//        fetchRequest.predicate = NSPredicate(format: , )
//    }
    
    // delete one Stuff
    func deleteCompanyFromData(indexPath: IndexPath, companyArray: inout [CompanyUser]) {
        // inout -> In Swift sind Parameter Standart Konstant. Wenn man einen Wert innerhalb der Methode verändern will dann inout nutzen!
        context.delete(companyArray[indexPath.row])
        companyArray.remove(at: indexPath.row)
        saveContext()
    }
    
    // delete single records V1
    func deleteSingleRecords(array: inout [CompanyUser]) {
        context.delete(array[1])
    }
    
    // delete V3
    func deleteRecords() -> Void {
        let dataContext = context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CompanyUser")
        
        let result = try? dataContext.fetch(fetchRequest)
        let resultData = result as! [CompanyUser]
        
        for object in resultData {
            dataContext.delete(object)
        }
        
        do {
            try context.save()
        } catch {
            print("Fehler beim löschen", error.localizedDescription)
        }
    }
}
