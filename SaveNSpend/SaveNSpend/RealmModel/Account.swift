//
//  Account.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/6/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import RealmSwift

// Account model
class Account: Object {

    // MARK: Properties
    dynamic var id = 0
    dynamic var bankName = ""
    dynamic var balance = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: incrementaID
    func incrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Account).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}
