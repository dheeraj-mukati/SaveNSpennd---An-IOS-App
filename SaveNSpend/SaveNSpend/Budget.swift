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
    dynamic var limit = 0
    dynamic var month  = ""
    dynamic var year  = ""
    dynamic var category: Category? = Category()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
