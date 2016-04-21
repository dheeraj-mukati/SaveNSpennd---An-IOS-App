//
//  Category.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/6/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import RealmSwift

// Category model
class Category: Object {

    dynamic var id = 0
    dynamic var name = ""
    dynamic var type = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: incrementaID
    func incrementaID() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Category).sorted("id"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("id") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
}


