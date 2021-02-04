//
//  ViewController.swift
//  My Finance
//
//  Created by Danabek Abildayev on 10/31/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit
import LocalAuthentication

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
        backgroundView.image = UIImage(named: "coin")
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
        start.addTarget(self, action: #selector(touchID), for: .touchUpInside)
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
    
    @objc func touchID() {
        
        let context : LAContext = LAContext()
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Touch ID") { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        let destVC = SecondViewController()
                        destVC.modalPresentationStyle = .fullScreen
                        self.navigationController?.pushViewController(destVC, animated: true)
                        print("It worked")
                    }
                } else {
                    print("Error occured. \(error?.localizedDescription ?? "Try again")")
                }
            }
        }
        
    }
    
}

