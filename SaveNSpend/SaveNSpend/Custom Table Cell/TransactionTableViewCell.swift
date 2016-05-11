//
//  TransactionTableViewCell.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/23/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var transactionCategory: UILabel!
    
    @IBOutlet weak var transactionDate: UILabel!
    
    @IBOutlet weak var transactionAmount: UILabel!
    
    @IBOutlet weak var bankName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
