//
//  DashboardVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/29/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift
import Charts

class DashboardVC: UIViewController {

    @IBOutlet weak var bankAccountMainUIView: UIView!
    @IBOutlet weak var bankAccountsContentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openMenuItemBar: UIBarButtonItem!
    
    @IBOutlet weak var cashFlowUIView: UIView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var transactionsMonth: UILabel!
    
    @IBOutlet weak var cashFlowMonthLabel: UILabel!
    
    @IBOutlet weak var totalEarnedLabel: UILabel!
    
    @IBOutlet weak var totalSpentLabel: UILabel!
    
    @IBOutlet weak var cashFlowContentView: UIView!
    
    @IBOutlet weak var cashFlowAmountLabel: UILabel!
    
    @IBOutlet weak var totalSpentPRogressBar: UIProgressView!
    
    @IBOutlet weak var totalEarnedProgressBar: UIProgressView!
    
    @IBOutlet weak var noTransactionLabelInCashFlow: UILabel!
    
    @IBOutlet weak var noAccountsLabel: UILabel!
    
    @IBOutlet weak var noTransactionLabelInPieChartSection: UILabel!
    
    let currencySymbol = "$"
    
    let dateUtils = DateUtils()
    var currentDate = NSDate()
    
    var transactions = [Transaction]()
    
    let realm = try! Realm()
    let bankAccountUIViewWidth = CGFloat(150)

    override func viewDidLoad() {
        
        openMenuItemBar.target = self.revealViewController()
        openMenuItemBar.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        bankAccountMainUIView.layer.cornerRadius = 5
        bankAccountsContentView.layer.cornerRadius = 5
        cashFlowUIView.layer.cornerRadius = 5
        //bankAccountsContentView.backgroundColor = UIColor.lightGrayColor()
        
        noTransactionLabelInCashFlow.hidden = true
        noAccountsLabel.hidden = true
        noTransactionLabelInPieChartSection.hidden = true
        
        let accounts = Array(realm.objects(Account))
        print(accounts.count)
        if accounts.count > 0 {
        
            var bankAccountCount = CGFloat(0)
            var fisrAccountFlag = true
            let bankAccountUIViewLeftMargin = CGFloat(8)
            
            var totalWidth = CGFloat(0)
            for account in accounts {
                var bankAccountUIView:UIView
                if fisrAccountFlag {
                    bankAccountUIView = createBankAccountUIView(CGFloat(bankAccountCount * bankAccountUIViewLeftMargin))
                    fisrAccountFlag = false
                }else{
                    bankAccountUIView = createBankAccountUIView(CGFloat((bankAccountCount * bankAccountUIViewWidth) + (bankAccountCount * bankAccountUIViewLeftMargin)))
                }
                
                createBankAccountNameUILabel(bankAccountUIView, bankName: account.bankName)
                createAccountBalanceUILabel(bankAccountUIView, balance: String(account.balance))
                bankAccountCount += 1
                
                totalWidth = totalWidth + bankAccountUIView.frame.width
            }
            print("totalWidth: \(totalWidth)")
        }else {
            noAccountsLabel.hidden = false
        }
        print("scrol width: \(scrollView.contentSize.width)")
        print("scrol width: \(bankAccountsContentView.frame.width)")
        print("view width: \(view.frame.width)")
        //scrollView.contentSize = bankAccountsContentView.frame.size
        print("scrol width1: \(scrollView.contentSize.width)")
        print("scrol width1: \(bankAccountsContentView.frame.width)")
        print("view width1: \(view.frame.width)")
        
        totalEarnedProgressBar.clipsToBounds = true
        totalSpentPRogressBar.clipsToBounds = true
        
        totalEarnedProgressBar.progress = 0
        totalSpentPRogressBar.progress = 0
        
        setCashFlowData()
        
        pieChartView.alpha = 1
        
        let legend = pieChartView.legend
        legend.position = ChartLegend.Position.LeftOfChart
        legend.xEntrySpace = 7.0
        legend.yEntrySpace = 0.0
        legend.yOffset = 0.0
        pieChartView.drawSliceTextEnabled = false
        pieChartView.noDataText = "No transactions in this month"
        setPieChartData(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
    }
    
    func createBankAccountUIView(leftConstant: CGFloat) -> UIView {
        
        let customView = UIView()
        customView.backgroundColor = getRandomColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.cornerRadius = 5
        bankAccountsContentView.addSubview(customView)
        
        let topConstraint = NSLayoutConstraint(item: customView, attribute: .Top, relatedBy: .Equal, toItem: bankAccountsContentView, attribute: .Top, multiplier: 1, constant: 5)
        bankAccountsContentView.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: customView, attribute: .Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bankAccountsContentView, attribute: .Bottom, multiplier: 1, constant: -5)
        bankAccountsContentView.addConstraint(bottomConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: customView, attribute: .Left, relatedBy: .Equal, toItem: bankAccountsContentView, attribute: .Left, multiplier: 1, constant: leftConstant)
        bankAccountsContentView.addConstraint(leftConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: customView, attribute: .Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: bankAccountUIViewWidth)
        bankAccountsContentView.addConstraint(widthConstraint)
        
        return customView
    }
    
    func createBankAccountNameUILabel(bankAccountUIView: UIView, bankName: String){
        
        let bankNameLabel = UILabel()
        bankNameLabel.text = bankName
        //balanceLabel.numberOfLines = 1
        bankNameLabel.textColor = UIColor.whiteColor()
        bankNameLabel.textAlignment = .Left
        bankNameLabel.font = bankNameLabel.font.fontWithSize(15)
        bankNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bankNameLabel.adjustsFontSizeToFitWidth = true
        bankNameLabel.minimumScaleFactor = 0.5
        bankAccountUIView.addSubview(bankNameLabel)
        
        let xConstraint = NSLayoutConstraint(item: bankNameLabel, attribute: .Top, relatedBy: .Equal, toItem: bankAccountUIView, attribute: .Top, multiplier: 1, constant: 5)
        
        let yConstraint = NSLayoutConstraint(item: bankNameLabel, attribute: .Left, relatedBy: .Equal, toItem: bankAccountUIView, attribute: .Left, multiplier: 1, constant: 8)
        
        bankAccountUIView.addConstraint(xConstraint)
        bankAccountUIView.addConstraint(yConstraint)
    }
    
    func createAccountBalanceUILabel(bankAccountUIView : UIView, balance: String){
        
        let accountBalanceLabel = UILabel()
        accountBalanceLabel.text = "$" + balance
        accountBalanceLabel.textColor = UIColor.whiteColor()
        accountBalanceLabel.textAlignment = .Center
        accountBalanceLabel.font = accountBalanceLabel.font.fontWithSize(17)
        accountBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        bankAccountUIView.addSubview(accountBalanceLabel)
        
        let xConstraint = NSLayoutConstraint(item: accountBalanceLabel, attribute: .Top, relatedBy: .Equal, toItem: bankAccountUIView, attribute: .Top, multiplier: 1, constant: 25)
        
        let yConstraint = NSLayoutConstraint(item: accountBalanceLabel, attribute: .Left, relatedBy: .Equal, toItem: bankAccountUIView, attribute: .Left, multiplier: 1, constant: 8)
        
        bankAccountUIView.addConstraint(xConstraint)
        bankAccountUIView.addConstraint(yConstraint)
    }
    
    func getRandomColor() -> UIColor{
        
        let randomRed:CGFloat = CGFloat(drand48())
        let randomGreen:CGFloat = CGFloat(drand48())
        let randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    @IBAction func nextMonthTransactions() {
        
        currentDate = dateUtils.dateByAddingMonths(1, currentDate: currentDate)!
        setTransactionMonth()
        setPieChartData(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
    }
    
    @IBAction func previousMonthTransactions(sender: AnyObject) {
        
        currentDate = dateUtils.dateByAddingMonths(-1, currentDate: currentDate)!
        setTransactionMonth()
        setPieChartData(dateUtils.startOfMonth(currentDate)!, endDate: dateUtils.endOfMonth(currentDate)!)
    }
    
    func setPieChartData(startDate: NSDate, endDate: NSDate){
        
        let categoryType = "Expense"
        transactions = Array(realm.objects(Transaction).filter("date > %@ AND date <= %@", startDate, endDate).filter("category.type = %@",categoryType))
        
        var transactionsDisctionary = [String:Double]()
        var totalTransactionAmount = 0.0
        for transaction in transactions {
            if transactionsDisctionary[(transaction.category?.name)!] == nil {
                transactionsDisctionary[(transaction.category?.name)!] = transaction.amount
            }else {
                transactionsDisctionary[(transaction.category?.name)!] = transactionsDisctionary[(transaction.category?.name)!]! + transaction.amount
            }
            totalTransactionAmount = totalTransactionAmount + transaction.amount
        }
        setChart(Array(transactionsDisctionary.keys), values: Array(transactionsDisctionary.values), totalAmount: totalTransactionAmount)
        setTransactionMonth()
    }
    
    private func setTransactionMonth(){
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
        
        let year =  components.year
        let monthName = NSDateFormatter().monthSymbols[components.month - 1]
        
        transactionsMonth.text = monthName + " " + String(year)
    }
    
    func setCashFlowData(){
        setCashFlowMonth()
        setCashFlowAmount()
    }
    
    func setCashFlowMonth(){
    
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: NSDate())
        
        let monthName = NSDateFormatter().monthSymbols[components.month - 1]
        cashFlowMonthLabel.text = monthName
    }
    
    func setCashFlowAmount(){
        
        let date = NSDate()
        let transactions = Array(realm.objects(Transaction).filter("date > %@ AND date <= %@", dateUtils.startOfMonth(date)!, dateUtils.endOfMonth(date)!))
        
        var totalSpent = 0.0
        var totalEarned = 0.0
        
        for transaction in transactions {
            if transaction.category?.type == "Expense"{
                totalSpent = totalSpent + transaction.amount
            }else{
                totalEarned = totalEarned + transaction.amount
            }
        }
        
        if transactions.count == 0 {
            cashFlowContentView.removeFromSuperview()
            noTransactionLabelInCashFlow.hidden = false
        }
        
        let totalCashFlow = totalEarned - totalSpent
        
        totalSpentLabel.text = "-" + currencySymbol + String(totalSpent)
        totalEarnedLabel.text = currencySymbol + String(totalEarned)
        
        if totalCashFlow < 0 {
            let ratio = Float(totalEarned) / Float(totalSpent)
            totalEarnedProgressBar.progress = Float(ratio)
            totalSpentPRogressBar.progress = Float(totalSpent)
            
            cashFlowAmountLabel.textColor = UIColor.redColor()
            cashFlowAmountLabel.text = "-" + currencySymbol + String(abs(totalCashFlow))
        }else if totalCashFlow > 0{
            let ratio = Float(totalSpent) / Float(totalEarned)
            totalEarnedProgressBar.progress = Float(totalEarned)
            totalSpentPRogressBar.progress = Float(ratio)
            
            cashFlowAmountLabel.text = currencySymbol + String(totalCashFlow)

        }
    }
    
//    func createNoTransactionUIlabelInCashFlowSection(){
//        
//        let addAccountUILabel = UILabel()
//        addAccountUILabel.textAlignment = .Center
//        addAccountUILabel.font = addAccountUILabel.font.fontWithSize(15)
//        addAccountUILabel.text = "No transactions for this month"
//        addAccountUILabel.translatesAutoresizingMaskIntoConstraints = false
//        self.cashFlowUIView.addSubview(addAccountUILabel)
//        
//        let widthConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400)
//        addAccountUILabel.addConstraint(widthConstraint)
//        
//        let heightConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
//        addAccountUILabel.addConstraint(heightConstraint)
//        
//        let xConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.cashFlowUIView, attribute: .CenterX, multiplier: 1, constant: 0)
//        
//        let yConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.cashFlowUIView, attribute: .CenterY, multiplier: 1, constant: 0)
//        
//        self.cashFlowUIView.addConstraint(xConstraint)
//        self.cashFlowUIView.addConstraint(yConstraint)
//    }
    func setChart(dataPoints: [String], values: [Double], totalAmount: Double) {

        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for i in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        pieChartView.animate(xAxisDuration: 2.0)
        if totalAmount != 0.0 {
            pieChartView.centerText = currencySymbol + String(totalAmount)
            noTransactionLabelInPieChartSection.hidden = true
        }else {
            noTransactionLabelInPieChartSection.hidden = false
            pieChartView.centerText = ""
        }
        pieChartDataSet.colors = colors
        pieChartView.notifyDataSetChanged()
    }
}
