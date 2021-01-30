//
//  ViewController.swift
//  My Finance
//
//  Created by Danabek Abildayev on 10/31/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    let backgroundView = UIImageView()
    
    let appName = UILabel()
    let appText = UILabel()
    let start = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func setItems() {
        backgroundView.frame = view.frame
        backgroundView.image = UIImage(named: "coin-1481018_1920")
        backgroundView.contentMode = .scaleAspectFill
        view.addSubview(backgroundView)
        
        appName.text = "FinFlow"
        appName.font = .systemFont(ofSize: 50)
        appName.textColor = .white
        appName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appName)
        
        appText.text = "Advanced Finance App"
        appText.font = .systemFont(ofSize: 20)
        appText.textColor = .white
        appText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(appText)
        
        start.setTitle("Get Started", for: .normal)
        start.setTitleColor(.white, for: .normal)
        start.titleLabel?.font = .systemFont(ofSize: 25)
        start.backgroundColor = UIColor(red: 0.52, green: 0.25, blue: 0.14, alpha: 1.00)
        start.layer.cornerRadius = 15
        start.addTarget(self, action: #selector(getStarted), for: .touchUpInside)
        start.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(start)
        
        NSLayoutConstraint.activate([appName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     appName.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                                     appName.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                                     appName.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                                     appText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     appText.topAnchor.constraint(equalTo: appName.bottomAnchor, constant: 5),
                                     appText.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                                     appText.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                                     start.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     start.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
                                     start.widthAnchor.constraint(greaterThanOrEqualToConstant: 150)
        ])
    }
    
    @objc func getStarted() {
        
        var password = UITextField()
        
        let alert = UIAlertController(title: "Enter password", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.keyboardType = .numberPad
            alertTextField.textAlignment = .center
            alertTextField.isSecureTextEntry = true
            password = alertTextField
        }
        
        password.text = "1111"
        
        let action = UIAlertAction(title: "Proceed", style: .default) { (action) in
            if password.text! == "1111" {
                let destVC = SecondViewController()
                destVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                self.tryAgain()
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            return
        }
        
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true)
    }
    
    func tryAgain() {
        let alert = UIAlertController(title: "Wrong password!", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Try again", style: .default) { (action) in
            self.getStarted()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }


}

