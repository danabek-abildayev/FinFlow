//
//  MonthSection.swift
//  FinFlow
//
//  Created by Danabek Abildayev on 1/30/21.
//  Copyright © 2021 macbook. All rights reserved.
//

import Foundation
import RealmSwift

struct MonthSection: Comparable {
    var month: Date
    var transactions: [ExpenseData]
    
    static func < (lhs: MonthSection, rhs: MonthSection) -> Bool {
        return lhs.month > rhs.month
    }
    
    static func groupItems(transactions : Results<ExpenseData>) -> [MonthSection] {
        
        let groups = Dictionary(grouping: transactions) { (expense) -> Date in
           return firstDayOfMonth(date: expense.date)
       }
        return groups.map(MonthSection.init(month:transactions:)).sorted()
   }
    
}

fileprivate func firstDayOfMonth(date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    return calendar.date(from: components)!
}
