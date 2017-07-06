//
//  EntryController.swift
//  Expenses
//
//  Created by Laptop on 7/5/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import UIKit
import CoreData

enum ActionType { case new, edit, delete }

class EntryController: UIViewController {

    var action: ActionType = .new
    var entryId: Int32 = 0
    var date   = Date()
    var year   = Date().year
    var month  = Date().month
    var day    = Date().day
    
    @IBOutlet weak var textTitle  : UILabel!
    @IBOutlet weak var textAmount : UITextField!
    @IBOutlet weak var textNotes  : UITextField!
    @IBOutlet weak var datePicker : UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch action {
        case .new   : newEntry()
        case .edit  : editEntry()
        case .delete: break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: ACTIONS

    @IBAction func onDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onSave(_ sender: Any) {
        if action == .edit {
            updateEntry()
        } else {
            insertEntry()
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        if action == .edit {
            EntryManager.delete(entryId)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDatePicked(_ sender: UIDatePicker) {
        date = sender.date
    }
    

    // MARK: METHODS
    
    func newEntry() {
        textTitle.text = "NEW ENTRY"
        entryId = EntryManager.nextId()
        date = Date()
    }
    
    func editEntry() {
        textTitle.text = "EDIT ENTRY"
        
        if let entry = EntryManager.get(entryId) {
            textNotes.text  = entry.notes
            textAmount.text = entry.amount?.str
            date = (entry.time as Date?) ?? Date()
            datePicker.setDate(date, animated: true)
        } else {
            print("Entry not found: ", entryId)
        }
    }

    func insertEntry() {
        var entry = EntryManager.Record()
        
        entry.id     = entryId
        entry.amount = textAmount.text?.decimal ?? 0.0
        entry.notes  = textNotes.text?.or("?") ?? "?"
        entry.time   = date as NSDate
        entry.year   = Int16(date.year)
        entry.month  = Int16(date.month)
        entry.day    = Int16(date.day)
        entry.yymm   = date.yymm
        
        EntryManager.insert(entry)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateEntry() {
        if let entry = EntryManager.get(entryId) {
            entry.amount = textAmount.text?.decimal ?? 0.0
            entry.notes  = textNotes.text?.or("?") ?? "?"
            entry.time   = date as NSDate
            entry.year   = Int16(date.year)
            entry.month  = Int16(date.month)
            entry.day    = Int16(date.day)
            entry.yymm   = date.yymm
            
            do {
                try entry.managedObjectContext?.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            print("Entry not found: ", entryId)
        }
        
        self.dismiss(animated: true, completion: nil)
    }

}


// END
