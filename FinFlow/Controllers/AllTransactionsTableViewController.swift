//
//  AllTransactionsTableViewController.swift
//  FinFlow
//
//  Created by Danabek Abildayev on 1/25/21.
//  Copyright © 2021 macbook. All rights reserved.
//

import UIKit
import RealmSwift

class AllTransactionsTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var allTransactionsArray : Results<ExpenseData>!
    
    private var sections = [MonthSection]()
    
    var exportArray : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "NewCell")
        
        navigationItem.setRightBarButton(.init(barButtonSystemItem: .action, target: self, action: #selector(exportData)), animated: true)
        
        loadAllTransactions()
        sections = MonthSection.groupItems(transactions: allTransactionsArray)
        tableView.reloadData()
    }
    
    @objc func exportData() {
        
        for section in sections {
            for transaction in section.transactions {
                
                let df = DateFormatter()
                df.dateFormat = "dd MMM yyyy HH:mm:ss"
                let dateString = df.string(from: transaction.date)
                
                exportArray.append("Date: \(dateString)   Description: \(transaction.tranDescription)    Amount: \(transaction.tranAmount)")
            }
        }
                
        let arrayCombinedToString = exportArray.joined(separator: "\n")
                
        let activityVC = UIActivityViewController(activityItems: [arrayCombinedToString], applicationActivities: .none)
        
        activityVC.completionWithItemsHandler = { (nil, completed, _, error)
            in
            if completed {
                print("Transaction was completed successfully")
            } else {
                print("Cancelled or error appeared")
            }
        }
        
        present(activityVC, animated: true) {
            print("Presented successfully")
        }
        
    }
    
    func loadAllTransactions() {
        allTransactionsArray = realm.objects(ExpenseData.self).sorted(byKeyPath: "date", ascending: false)
    }
    

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = sections[section]
        let date = section.month
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        return df.string(from: date)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = sections[section]
        return section.transactions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCell", for: indexPath) as! TransactionTableViewCell
        
        let section = sections[indexPath.section]
        let transaction = section.transactions[indexPath.row]

        cell.imageLogo.image = UIImage(named: transaction.category.lowercased())
        
        cell.expense.text = transaction.tranDescription
        
        let date = transaction.date
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy HH:mm:ss"
        let dateString = df.string(from: date)
        cell.date.text = dateString
        
        cell.number.text = transaction.tranAmount
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let section = sections[indexPath.section]
            let transaction = section.transactions[indexPath.row]
            
            let objectThatIsGoingToBeDeleted : ExpenseData = transaction
            
            print("Object to be deleted: \(objectThatIsGoingToBeDeleted)")

            do {
                try realm.write {
                    realm.delete(objectThatIsGoingToBeDeleted)
                    print("Deleted successfully!")
                }
            } catch {
                print("Error while deleting object from table view \(error)")
            }
            
            loadAllTransactions()
            sections = MonthSection.groupItems(transactions: allTransactionsArray)
            
            if tableView.numberOfRows(inSection: indexPath.section) > 1 {
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section) // This line was wrong in above code.
                tableView.deleteSections(indexSet as IndexSet, with: .fade)
            }
            
        }
    }

}
