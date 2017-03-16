//
//  MDDataController.swift
//  master detail test
//
//  Created by DPlatov on 3/16/17.
//  Copyright © 2017 dplatov. All rights reserved.
//

import UIKit

import UIKit
import CoreData

class MDDataController: NSObject {
    
    static let sharedDataController = MDDataController()
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "MDDataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]

        let storeURL = docURL.appendingPathComponent("MDDataModel.sqlite")//docURL.URLByAppendingPathComponent("DataModel.sqlite")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
    }
    
    func fetchOrCreateUser(_ userID:String) -> MDUser {
        
        let userFetch:NSFetchRequest<MDUser> = MDUser.fetchRequest()//NSFetchRequest<NSFetchRequestResult>(entityName: "MDUser")
        userFetch.predicate = NSPredicate(format: "userID == %@", userID)
        
        var fetchedUses:[MDUser]
        
        do {
            fetchedUses = try managedObjectContext.fetch(userFetch)
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        
        if let user = fetchedUses.first {
            
            return user
            
        }else{
            
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "MDUser", into: managedObjectContext) as! MDUser
            newUser.userID = userID
            return newUser
        }
    }
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    // MARK: - Setup default data
    
    func  loadInitialDataIfNeeded() {
        
        if UserDefaults.standard.bool(forKey: "DataLoaded") {
            return
        }
        
        if let dataUrl = Bundle.main.url(forResource: "initialData", withExtension: "JSON") {
            if let jsonData = NSData(contentsOf: dataUrl) {
                var usersArray:Array<Dictionary<String, Any>>
                do {
                    usersArray = try JSONSerialization.jsonObject(with: jsonData as Data, options: .allowFragments) as! Array<Dictionary<String, Any>>
                } catch {
                    print("Invalid JSON")
                    return
                }
                
                
                for userDictionary in usersArray  {
                    
                    if let userID = userDictionary["id"] as? String {
                        let user = fetchOrCreateUser(userID)
                        user.firstName = userDictionary["firstName"] as? String
                        user.secondName = userDictionary["secondName"] as? String
                        user.email = userDictionary["email"] as? String
                        
                    }else {
                        print("Incorrect data in JSON \(userDictionary)")
                    }
                    
                }
                
                saveContext()
                UserDefaults.standard.set(true, forKey: "DataLoaded")
                UserDefaults.standard.synchronize()
            }
        }
        
    }
}
