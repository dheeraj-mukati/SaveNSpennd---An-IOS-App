//
//  TransactionVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/23/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class TransactionVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var transactionTableView: UITableView!
    
    @IBOutlet weak var incomeAmountTotal: UILabel!
    
    @IBOutlet weak var expenseAmountTotal: UILabel!
    
    let realm = try! Realm()
    
    var transactions = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        transactions = Array(realm.objects(Transaction))
        setTotalIncomeAndExpenseAmount()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return transactions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("transaction_cell", forIndexPath: indexPath) as! TransactionTableViewCell
        cell.transactionAmount.text = "$" + String(transactions[indexPath.row].amount)
        cell.transactionCategory.text = (transactions[indexPath.row]).category!.name
        cell.transactionDate.text = formatDate(transactions[indexPath.row].date)
        cell.bankName.text = transactions[indexPath.row].account!.bankName
        
        if (transactions[indexPath.row]).category!.type == "Income" {
            cell.transactionAmount.textColor = UIColor.greenColor()
        }else {
            cell.transactionAmount.textColor = UIColor.redColor()
        }
        
        return cell
    }
    
    func setTotalIncomeAndExpenseAmount() {
    
        var totalIncome = 0.0
        var totalExpense = 0.0
        
        for transaction in transactions {
        
            if transaction.category!.type == "Income" {
                totalIncome = totalIncome + transaction.amount
            }else {
                totalExpense = totalExpense + transaction.amount
            }
        }
        incomeAmountTotal.text = "$" + String(totalIncome)
        expenseAmountTotal.text = "$" + String(totalExpense)
    }
    
    private func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        return dateFormatter.stringFromDate(date)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
