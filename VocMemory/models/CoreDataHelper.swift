//
//  CoreDataHelper.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    static let shared = CoreDataHelper()
    
    private init() {}
    
    //TODO: - create group
    
    func createGroup(name: String, completionHandler: (_ result: Group, _ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: managedContext)!
        let group = NSManagedObject(entity: entity, insertInto: managedContext) as! Group
        group.title = name
        
        do {
            try managedContext.save()
            completionHandler(group, nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //TODO: - read group
    
    func readGroup() -> [Group]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        
        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    //TODO: - update group
    
    func updateGroup() {
        
    }
    
    //TODO: - delete group
    
    func deleteGroup(group: Group, completionHandler: (_ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        // let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        // fetchRequest.predicate = NSPredicate(format: "title = %@", name)
        
        do {
            managedContext.delete(group)
            try managedContext.save()
            completionHandler(nil)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //TODO: - create word
    
    func createWord() {
        
    }
    
    //TODO: - read word
    
    func readWord() {
        
    }
    
    //TODO: - update word
    
    func updateWord() {
        
    }
    
    //TODO: - delete word
    
    func deleteWord() {
        
    }
    
}
