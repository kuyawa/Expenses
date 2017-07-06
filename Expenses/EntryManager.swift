//
//  EntryManager.swift
//  Expenses
//
//  Created by Laptop on 7/6/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import UIKit
import CoreData

class EntryManager {

    struct Record {
        var id     : Int32  = 0
        var time   : NSDate = NSDate()
        var year   : Int16  = 0
        var month  : Int16  = 0
        var day    : Int16  = 0
        var yymm   : String = ""
        var amount : NSDecimalNumber = 0.0
        var notes  : String = ""
    }
    
    static func nextId() -> Int32 {
        var nextId: Int32 = 1

        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return nextId
        }
        
        let context = app.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        var entries = [Entry]()
        
        do {
            entries = try context.fetch(request) as! [Entry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if let entry = entries.first {
            nextId = entry.id + 1
        } else {
            print("No entries")
        }
        
        return nextId
    }
    
    static func get(_ id: Int32) -> Entry? {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let context = app.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        let predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1
        request.predicate  = predicate
        
        var entries = [Entry]()
        
        do {
            entries = try context.fetch(request) as! [Entry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }

        if let entry = entries.first {
            return entry
        } else {
            print("Entry not found")
            return nil
        }
        
    }

    static func getByMonth(_ year: Int16, _ month: Int16) -> [Entry] {
        var entries = [Entry]()
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            print("Unknown error loading entries")
            return entries
        }
        
        let yymm = year.str04 + month.str02
        let context = app.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        let predicate = NSPredicate(format: "yymm == %@", yymm)
        request.predicate  = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: false)]

        do {
            entries = try context.fetch(request) as! [Entry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return entries
    }
    
    func getAll() -> [Entry] {
        var entries = [Entry]()
        
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            print("Unknown error loading entries")
            return entries
        }
        
        let context = app.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Entry")
        
        do {
            entries = try context.fetch(request) as! [Entry]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return entries
    }

    @discardableResult
    static func insert(_ data: Record) -> Int32 {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return 0
        }
        
        let context = app.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Entry", in: context)!
        let entry  = NSManagedObject(entity: entity, insertInto: context) as! Entry
        
        entry.id     = data.id
        entry.amount = data.amount
        entry.notes  = data.notes
        entry.time   = data.time
        entry.year   = data.year
        entry.month  = data.month
        entry.day    = data.day
        entry.yymm   = data.yymm
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Could not insert. \(error), \(error.userInfo)")
            return 0
        }
        
        return entry.id
    }

    @discardableResult
    static func delete(_ id: Int32) -> Bool {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            return false
        }
        
        let context = app.persistentContainer.viewContext
        
        // get entry by id, then delete
        if let entry = get(id) {
            context.delete(entry)
        
            do {
                try context.save()
            } catch {
                print("Error deleting entry: ", error.localizedDescription)
                return false
            }
            return true
        }
        
        // Not found
        return false
    }

}

// END
