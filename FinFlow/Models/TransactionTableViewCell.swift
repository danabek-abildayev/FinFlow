//
//  TransactionTableViewCell.swift
//  FinFlow
//
//  Created by Danabek Abildayev on 11/1/20.
//  Copyright © 2020 macbook. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    
    let imageLogo = UIImageView()
    let expense = UILabel()
    let date = UILabel()
    let number = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        imageLogo.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageLogo)
        
        expense.textColor = .label
        expense.font = .boldSystemFont(ofSize: 20)
        expense.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(expense)
        
        date.textColor = .gray
        date.font = .systemFont(ofSize: 15)
        date.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(date)
        
        number.textColor = .label
        number.font = .boldSystemFont(ofSize: 20)
        number.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(number)
        
        NSLayoutConstraint.activate([imageLogo.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
                                     imageLogo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     imageLogo.widthAnchor.constraint(equalToConstant: 30),
                                     imageLogo.heightAnchor.constraint(equalToConstant: 30),
                                     expense.leftAnchor.constraint(equalTo: imageLogo.rightAnchor, constant: 15),
                                     expense.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
                                     expense.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                                     expense.heightAnchor.constraint(equalToConstant: 30),
                                     date.leftAnchor.constraint(equalTo: expense.leftAnchor),
                                     date.topAnchor.constraint(equalTo: expense.bottomAnchor),
                                     number.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                                     number.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
                                     number.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
                                     
        
        ])
    }

}
