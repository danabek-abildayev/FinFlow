//
//  SecondViewController.swift
//  FinFlow
//
//  Created by Danabek Abildayev on 10/31/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class SecondViewController: UIViewController {
    
    let realm = try! Realm()
    
    var newDataArray : Results<ExpenseData>!
    
    var realBalance: Int {
        get {
            var sum = 0
            for i in newDataArray.indices {
                sum += Int(newDataArray[i].tranAmount)!
            }
            return sum
        }
    }
    
    let backgroundView = UIImageView()
    let balance = UILabel()
    let balanceText = UILabel()
    var tableView = UITableView()
    
    let pieChart = PieChartView()
    
    private var sections = [MonthSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setItems()
    }
    
    func setItems() {
        
        backgroundView.frame = view.frame
        backgroundView.image = UIImage(named: "background2")
        backgroundView.contentMode = .scaleAspectFill
        view.addSubview(backgroundView)
        
        title = "FinFlow"
        navigationItem.setRightBarButton(.init(image: UIImage(named: "log-out"), style: .plain, target: self, action: #selector(logOut)), animated: true)
        navigationItem.setLeftBarButton(.init(barButtonSystemItem: .add, target: self, action: #selector(addTransaction)), animated: true)
        
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = (navigationController?.navigationBar.frame.height)!
        
        print("Status bar height is \(statusBarHeight)\nNav bar height is \(navBarHeight)")
        
        balance.textColor = .white
        balance.font = .systemFont(ofSize: 40)
        balance.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balance)
        
        balanceText.text = "Total balance"
        balanceText.font = .systemFont(ofSize: 20)
        balanceText.textColor = .white
        balanceText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceText)
        
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pieChart)
        
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([balance.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     balance.topAnchor.constraint(equalTo: view.topAnchor, constant: navBarHeight + statusBarHeight + 5),
                                     balanceText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     balanceText.topAnchor.constraint(equalTo: balance.bottomAnchor, constant: 5),
                                     pieChart.topAnchor.constraint(equalTo: balanceText.bottomAnchor, constant: 0),
                                     pieChart.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     pieChart.widthAnchor.constraint(equalToConstant: 300),
                                     pieChart.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -5),
                                     tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     tableView.widthAnchor.constraint(equalToConstant: view.frame.width),
                                     tableView.heightAnchor.constraint(equalToConstant: 250),
                                     tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                                     
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.setHidesBackButton(true, animated: true)
        
        loadItems()
        updateChartData()
        sections = MonthSection.groupItems(transactions: newDataArray)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.hidesBackButton = false
    }
    
    @objc func addTransaction() {
        let destVC = NewTransactionViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc func logOut() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadItems() {
        newDataArray = realm.objects(ExpenseData.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    
    //MARK: - PieChart stuff
    
    var balanceDataEntry = PieChartDataEntry(value: 0)
    var petrolDataEntry = PieChartDataEntry(value: 0)
    var mealDataEntry = PieChartDataEntry(value: 0)
    var clothesDataEntry = PieChartDataEntry(value: 0)
    var otherDataEntry = PieChartDataEntry(value: 0)
    var allCategoriesDataEntries = [PieChartDataEntry]()
    
    func updateChartData() {
        
        balanceDataEntry.value = { () -> Double in
            return Double(realBalance)
        }()
        
        petrolDataEntry.value = { () -> Double in
            var number: Double = 0
            for i in newDataArray.indices {
                if newDataArray[i].category == "Petrol" {
                    number += Double(newDataArray[i].tranAmount)!
                }
            }
            return abs(number)
        }()
        
        mealDataEntry.value = { () -> Double in
            var number: Double = 0
            for i in newDataArray.indices {
                if newDataArray[i].category == "Meal" {
                    number += Double(newDataArray[i].tranAmount)!
                }
            }
            return abs(number)
        }()
        
        clothesDataEntry.value = { () -> Double in
            var number: Double = 0
            for i in newDataArray.indices {
                if newDataArray[i].category == "Clothes" {
                    number += Double(newDataArray[i].tranAmount)!
                }
            }
            return abs(number)
        }()
        
        otherDataEntry.value = { () -> Double in
            var number: Double = 0
            for i in newDataArray.indices {
                if newDataArray[i].category == "Other" {
                    number += Double(newDataArray[i].tranAmount)!
                }
            }
            return abs(number)
        }()
        
        balanceDataEntry.label = "Balance"
        petrolDataEntry.label = "Petrol"
        mealDataEntry.label = "Meal"
        clothesDataEntry.label = "Clothes"
        otherDataEntry.label = "Other"
        
        allCategoriesDataEntries = [balanceDataEntry, petrolDataEntry, mealDataEntry, clothesDataEntry, otherDataEntry]
        var anotherDataEntriesArray : [PieChartDataEntry] = []
        
        for entry in allCategoriesDataEntries.indices {
            if allCategoriesDataEntries[entry].value != 0 {
                anotherDataEntriesArray.append(allCategoriesDataEntries[entry])
            }
        }
        
        pieChart.drawEntryLabelsEnabled = false
        
        let pieChartDataSet = PieChartDataSet(entries: anotherDataEntriesArray, label: nil)
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let colors = [UIColor.green, UIColor.red, UIColor.blue, UIColor.yellow, UIColor.orange]
        pieChartDataSet.colors = colors
        
        pieChart.data = pieChartData
    }
}

//MARK: - Table View Delegates

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if sections.count == 0 {
            balance.text = "\(realBalance) 〒"
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if sections.count == 0 {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
            headerView.backgroundColor = .gray
            
            // code for adding centered title
            let headerTitle = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 28))
            headerTitle.textColor = UIColor.black
            
            return headerView
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .gray
        
        // code for adding centered title
        let headerTitle = UILabel(frame: CGRect(x: 10, y: 0, width: 200, height: 28))
        headerTitle.textColor = UIColor.black
        
        let section = sections[section]
        let date = section.month
        let df = DateFormatter()
        df.dateFormat = "MMMM yyyy"
        headerTitle.text = df.string(from: date)
        headerView.addSubview(headerTitle)
        
        // code for adding button to right corner of section header
        let seeAllButton: UIButton = UIButton(frame: CGRect(x:headerView.frame.size.width - 85, y:0, width: 80, height:28))
        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.setTitleColor(.white, for: .normal)
        seeAllButton.backgroundColor = UIColor(red: 0.54, green: 0.24, blue: 0.53, alpha: 1.00)
        seeAllButton.layer.cornerRadius = 8
        seeAllButton.addTarget(self, action: #selector(seeAll), for: .touchUpInside)
        headerView.addSubview(seeAllButton)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sections.count == 0 {
            return 1
        }
        
        let section = sections[section]
        return section.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if sections.count == 0 {
            
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EmptyCell")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCell", for: indexPath)
            
            cell.textLabel?.text = "Enter some value"
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionTableViewCell
        
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
        
        balance.text = "\(realBalance) 〒"
        
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    
    @objc func seeAll() {
        let destVC = AllTransactionsTableViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
}
