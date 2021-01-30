//
//  ExpenseData.swift
//  FinFlow
//
//  Created by Danabek Abildayev on 11/3/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import Foundation
import RealmSwift

class ExpenseData : Object {
    
    @objc dynamic var category : String = ""
    @objc dynamic var tranDescription : String = ""
    @objc dynamic var tranAmount : String = ""
    @objc dynamic var date = Date()
}
