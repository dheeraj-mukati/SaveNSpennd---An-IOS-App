//
//  ViewController.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/6/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func clcik(sender: AnyObject) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //        // Get the default Realm
        //        let realm = try! Realm()
        //        // You only need to do this once (per thread)
        //
        //        //creating category
        //
        //        let category = Category()
        //        category.id = 1
        //        category.name = "Eating Out"
        //        category.type = "Expense"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(category)
        //        }
        //
        //        let category2 = Category()
        //        category2.id = 2
        //        category2.name = "Groceries"
        //        category2.type = "Expense"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(category2)
        //        }
        //
        //        let category3 = Category()
        //        category3.id = 3
        //        category3.name = "Entertainment"
        //        category3.type = "Expense"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(category3)
        //        }
        //
        //        let category4 = Category()
        //        category4.id = 4
        //        category4.name = "Kids"
        //        category4.type = "Expense"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(category4)
        //        }
        //
        //        let category5 = Category()
        //        category5.id = 5
        //        category5.name = "Fuel"
        //        category5.type = "Expense"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(category5)
        //        }
        //
        //        let category6 = Category()
        //        category6.id = 6
        //        category6.name = "Salary"
        //        category6.type = "Income"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(category6)
        //        }
        //
        //        //creating Account
        //
        //        let account = Account()
        //        account.id = 1
        //        account.balance = 3000
        //        account.bankName = "Chase Bank"
        //        account.type = "Debit"
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(account)
        //        }
        //
        //        // creating Transaction
        //
        //        let transaction = Transaction()
        //        transaction.id = 1
        //        transaction.category = category
        //        transaction.account = account
        //
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(transaction)
        //        }
        //        
        //        // Creating Budget
        //        let budget = Budget()
        //        budget.id = 1
        //        budget.category = category
        //        budget.limit = 400
        //        budget.month = "April"
        //        budget.month = "2016"
        //        
        //        // Add to the Realm inside a transaction
        //        try! realm.write {
        //            realm.add(budget)
        //        }
        //        
        //        print("Object Saved")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

