//
//  Budget.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/6/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import RealmSwift

// Budget model
class Budget: Object {

    // MARK: Properties
    dynamic var id = 0
    dynamic var limit = 0.0
    dynamic var date  = NSDate()
    dynamic var category: Category? = Category()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: incrementaID
    func incrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Budget).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
