//
//  NewTransactionViewController.swift
//  FinFlow
//
//  Created by Danabek Abildayev on 11/2/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import RealmSwift

class NewTransactionViewController: UIViewController {
    
    let realm = try! Realm()
    
    let newTranData = ExpenseData()
    
    let categoryText = UILabel()
    let category = UIPickerView()
    let expenseDescription = UITextField()
    var date : Date?
    let number = UITextField()
    let button = UIButton()
        
    let categories = ["Salary", "Petrol", "Meal", "Clothes", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .gray
        
        setItems()
        
    }
    
    func setItems() {
        
        categoryText.text = "Please choose category:"
        categoryText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryText)
        
        category.dataSource = self
        category.delegate = self
        category.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(category)
        
        expenseDescription.placeholder = "Enter description"
        expenseDescription.delegate = self
        expenseDescription.borderStyle = .roundedRect
        expenseDescription.autocorrectionType = .no
        expenseDescription.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expenseDescription)
        
        number.delegate = self
        number.placeholder = "0"
        number.keyboardType = .numbersAndPunctuation
        number.borderStyle = .roundedRect
        number.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(number)
        
        button.setTitle("Add Transaction", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        
        NSLayoutConstraint.activate([categoryText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
                                     categoryText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     category.topAnchor.constraint(equalTo: categoryText.bottomAnchor,constant: 20),
                                     expenseDescription.topAnchor.constraint(equalTo: category.bottomAnchor, constant: 20),
                                     expenseDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     number.topAnchor.constraint(equalTo: expenseDescription.bottomAnchor, constant: 20),
                                     number.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     button.topAnchor.constraint(equalTo: number.bottomAnchor, constant: 20),
                                     button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     
        ])
        
    }
    
    @objc func buttonPressed() {
        
        date = Date()
        
        if expenseDescription.text != "", number.text != "", let _ = Int(number.text!), let _ = date {
            save()
            navigationController?.popViewController(animated: true)
        } else {
            
            let alert = UIAlertController(title: "Try again", message: "Wrong description or amount. Please try again.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            
        }
    }
    
    func save() {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        newTranData.category = categories[category.selectedRow(inComponent: 0)]
        newTranData.tranDescription = expenseDescription.text!
        newTranData.date = date!
        newTranData.tranAmount = number.text!
        
        do{
            try realm.write {
                realm.add(newTranData)
                print("Transaction saved successfully")
            }
        } catch {
            print("Error while saving data to Realm \(error)")
        }
    }
    
    
}

//MARK: - PickerView Protocols

extension NewTransactionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    
}


//MARK: - TextField Protocols

extension NewTransactionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.endEditing(true)
        return true
    }
}
