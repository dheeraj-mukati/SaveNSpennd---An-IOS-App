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
    
    @IBOutlet weak var openMenuItemBar: UIBarButtonItem!
    
    @IBOutlet weak var transactionMonth: UILabel!
    
    let realm = try! Realm()
    
    var transactions = [Transaction]()
    
    var currentDate = NSDate()
    
    let dateUtils = DateUtils()
    
    let currencySymbol = NSUserDefaults.standardUserDefaults().stringForKey("cirrencySymbol")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openMenuItemBar.target = self.revealViewController()
        openMenuItemBar.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        
        setTransactionMonth()
        setTransactions(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
        setTotalIncomeAndExpenseAmount()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        setTransactions(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
        transactionTableView.reloadData()
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
        cell.transactionAmount.text = currencySymbol + String(transactions[indexPath.row].amount)
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
        incomeAmountTotal.text = currencySymbol + String(totalIncome)
        expenseAmountTotal.text = currencySymbol + String(totalExpense)
    }
    
    private func setTransactions(startDate: NSDate, endDate: NSDate){
    
        //filter("timestamp > %@ AND timestamp <= %@", startDate, endDate)
        //let predicate = NSPredicate(format: "date>= \(startDate) AND date<= \(endDate)")
        
        transactions = Array(realm.objects(Transaction).filter("date > %@ AND date <= %@", startDate, endDate))
    }
    private func formatDate(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        return dateFormatter.stringFromDate(date)
    }
    
    @IBAction func nextMonthTransactions() {
        
        currentDate = dateUtils.dateByAddingMonths(1, currentDate: currentDate)!
        setTransactionMonth()
        setTransactions(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
        transactionTableView.reloadData()
        setTotalIncomeAndExpenseAmount()
    }
    
    @IBAction func previousMonthTransactions() {
        
        currentDate = dateUtils.dateByAddingMonths(-1, currentDate: currentDate)!
        setTransactionMonth()
        setTransactions(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
        transactionTableView.reloadData()
        setTotalIncomeAndExpenseAmount()
    }
    
    private func setTransactionMonth(){
    
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
        
        let year =  components.year
        let monthName = NSDateFormatter().monthSymbols[components.month - 1]
        
        transactionMonth.text = monthName + " " + String(year)
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
