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
        
    func createGroup(name: String, completionHandler: (_ result: Group, _ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Group", in: managedContext)!
        let group = NSManagedObject(entity: entity, insertInto: managedContext) as! Group
        group.title = name
        group.id = UUID()
        do {
            try managedContext.save()
            completionHandler(group, nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
        
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
    
    // #TODO: Incomplete implementation update group
    func updateGroup() {
    }
    
    func deleteGroup(group: Group, completionHandler: (_ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            managedContext.delete(group)
            try managedContext.save()
            completionHandler(nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllGroup(completionHandler: (_ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                managedContext.delete(managedObject)
            }
            try managedContext.save()
            completionHandler(nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func createWord(group: Group, id: UUID, front: String, back: String, favori: Bool, completionHandler: (_ result: Word, _ error: Error?) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: managedContext)!
        let word = NSManagedObject(entity: entity, insertInto: managedContext) as! Word
        word.id = id
        word.front = front
        word.back = back
        word.favoris = favori
        word.memorisation = -1
        
        word.lastDate = Date()
        
        group.addToWords(word)
        
        do {
            try managedContext.save()
            completionHandler(word, nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func readWord(id: UUID) -> [Word]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        let sortByDate = NSSortDescriptor(key: "lastDate", ascending: true)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            let words = fetchedResults.first?.words
            let wordsResults = words!.sortedArray(using: [sortByDate]) as? [Word]
            
            return wordsResults
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    func updateWord(id: UUID, front: String, back: String, favori: Bool, lastDate: Date,  completionHandler: (_ word: Word, _ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if let first = fetchedResults.first {
                first.front = front
                first.back = back
                first.favoris = favori
                first.lastDate = lastDate
                
                try managedContext.save()
                completionHandler(first, nil)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func updateMemorisationWord(id: UUID, memorisation: Memorisation, completionHandler: (_ error: Error?) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            if let first = fetchedResults.first {
                
                if memorisation == .fail {
                    first.memorisation = 0
                } else if memorisation == .hard {
                    first.memorisation = 1
                } else if memorisation == .medium {
                    first.memorisation = 2
                } else if memorisation == .easy {
                    first.memorisation = 3
                }
                
                try managedContext.save()
                completionHandler(nil)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func updateAllMemorisationWord(id: UUID, completionHandler: (_ error: Error?) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            let words = fetchedResults.first?.words?.allObjects as? [Word]
            
            if words?.filter({ $0.memorisation == 0 }).count == 0 {
                for word in words! {
                    word.memorisation -= 1
                }
            }
            
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteWord(word: Word, completionHandler: (_ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            managedContext.delete(word)
            try managedContext.save()
            completionHandler(nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllWord(completionHandler: (_ error: Error?) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Word>(entityName: "Word")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                managedContext.delete(managedObject)
            }
            try managedContext.save()
            completionHandler(nil)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
