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
    
    func createWord(group: Group, front: String, back: String, favori: Bool, completionHandler: (_ result: Word, _ error: Error?) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Word", in: managedContext)!
        let word = NSManagedObject(entity: entity, insertInto: managedContext) as! Word
        word.front = front
        word.back = back
        word.favoris = favori
        word.lastDate = Date()
        
        group.addToWords(word)
        
        do {
            try managedContext.save()
            completionHandler(word, nil)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func readWord(group: Group) -> [Word]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Group>(entityName: "Group")
        fetchRequest.predicate = NSPredicate(format: "title = %@", group.title!)
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
    
    // #TODO: Incomplete implementation update word
    func updateWord() {
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
    
}
