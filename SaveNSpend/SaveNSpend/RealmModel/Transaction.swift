//
//  Transaction.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/6/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import RealmSwift

// Transaction model
class Transaction: Object {

    // MARK: Properties
    dynamic var id = 0
    dynamic var amount = 0.00
    dynamic var date  = NSDate()
    dynamic var category: Category? = Category()
    dynamic var account: Account? = Account()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: incrementaID
    func incrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Transaction).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
