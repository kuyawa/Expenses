//
//  ViewController.swift
//  Expenses
//
//  Created by Laptop on 7/5/17.
//  Copyright © 2017 Armonia. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var entries: [Entry] = []
    var year   : Int16   = Date().year
    var month  : Int16   = Date().month

    @IBOutlet weak var textMonth: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMonth()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onPrevMonth(_ sender: Any) {
        month -= 1
        if month < 1 { month = 12; year -= 1 }
        showMonth()
    }
    
    @IBAction func onNextMonth(_ sender: Any) {
        month += 1
        if month > 12 { month = 1; year += 1 }
        showMonth()
    }

    @IBAction func onThisMonth(_ sender: Any) {
        month = Date().month
        year  = Date().year
        showMonth()
    }
    
    @IBAction func onAddEntry(_ sender: Any) {
        // 
    }
    
    func modifyEntry(_ id: Int32) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let entryController = storyBoard.instantiateViewController(withIdentifier: "EntryController") as! EntryController
        entryController.entryId = id
        entryController.action  = .edit
        entryController.year    = year
        entryController.month   = month
        entryController.day     = 1
        present(entryController, animated: true, completion: nil)
    }
    
    func showMonth() {
        entries = EntryManager.getByMonth(year, month)
        textMonth.setTitle(getMonthName(), for: .normal)
        tableView.reloadData()
        calcTotal()
    }
    
    func getMonthName() -> String {
        let monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        var name = monthNames[Int(month-1)].uppercased()
        if year != Date().year {
            name += " " + year.str04
        }
        
        return name
    }
    
    func calcTotal() {
        var total = 0.0
        for entry in entries {
            total += entry.amount! as Double
        }
        textTotal.text = NSDecimalNumber(value: total).money
    }

}


// MARK: DATASOURCE

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row  = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        let labelNotes   = cell.contentView.viewWithTag(1) as? UILabel
        let labelAmount  = cell.contentView.viewWithTag(2) as? UILabel
        labelNotes?.text  = entries[row].notes
        labelAmount?.text = entries[row].amount?.money ?? "$0.00"
        
        return cell
    }
}


// MARK: DELEGATE

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modifyEntry(entries[indexPath.row].id)
    }

}


// END
