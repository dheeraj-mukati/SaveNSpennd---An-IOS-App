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
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            print("Is a first launch")
            createCategories()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstlaunch1.0")
            NSUserDefaults.standardUserDefaults().synchronize();
        }
        
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
    
    func createBankAccountUIView(leftConstraint: CGFloat) -> UIView {
        
        let customView = UIView()
        customView.backgroundColor = getRandomColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.cornerRadius = 5
        bankAccountsContentView.addSubview(customView)
        
        let topConstraint = NSLayoutConstraint(item: customView, attribute: .Top, relatedBy: .Equal, toItem: bankAccountsContentView, attribute: .Top, multiplier: 1, constant: 5)
        bankAccountsContentView.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: customView, attribute: .Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bankAccountsContentView, attribute: .Bottom, multiplier: 1, constant: -5)
        bankAccountsContentView.addConstraint(bottomConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: customView, attribute: .Left, relatedBy: .Equal, toItem: bankAccountsContentView, attribute: .Left, multiplier: 1, constant: leftConstraint)
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
    
    // to make entries when app launches first time
    func createCategories(){
        //creating category
        
        // Expense categories
        let category1 = Category()
        category1.id = 1
        category1.name = "Eating Out"
        category1.type = "Expense"

        let category2 = Category()
        category2.id = 2
        category2.name = "Groceries"
        category2.type = "Expense"
    
        let category3 = Category()
        category3.id = 3
        category3.name = "Entertainment"
        category3.type = "Expense"

        let category4 = Category()
        category4.id = 4
        category4.name = "Kids"
        category4.type = "Expense"

        let category5 = Category()
        category5.id = 5
        category5.name = "Fuel"
        category5.type = "Expense"
        
        let category6 = Category()
        category6.id = 6
        category6.name = "Movies"
        category6.type = "Expense"
        
        let category7 = Category()
        category7.id = 7
        category7.name = "Gifts"
        category7.type = "Expense"
    
        let category8 = Category()
        category8.id = 8
        category8.name = "Travel"
        category8.type = "Expense"
        
        let category9 = Category()
        category9.id = 9
        category9.name = "Clothes"
        category9.type = "Expense"
        
        let category10 = Category()
        category10.id = 10
        category10.name = "General"
        category10.type = "Expense"
        
        let category11 = Category()
        category11.id = 11
        category11.name = "Shopping"
        category11.type = "Expense"
        
        let category12 = Category()
        category12.id = 12
        category12.name = "Sports"
        category12.type = "Expense"
        
        //Income Categories
        let category13 = Category()
        category13.id = 13
        category13.name = "Salary"
        category13.type = "Income"
        
        let category14 = Category()
        category14.id = 14
        category14.name = "Lottery"
        category14.type = "Income"
                
        // Add to the Realm inside a transaction
        try! realm.write {
            realm.add(category1)
            realm.add(category2)
            realm.add(category3)
            realm.add(category4)
            realm.add(category5)
            realm.add(category6)
            realm.add(category7)
            realm.add(category8)
            realm.add(category9)
            realm.add(category10)
            realm.add(category11)
            realm.add(category12)
            realm.add(category13)
            realm.add(category14)
        }

    }
    
//    func scheduleLocal() {
//        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
//        
//        if settings!.types == .None {
//            let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(ac, animated: true, completion: nil)
//            return
//        }
//        
//        let notification = UILocalNotification()
//        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
//        notification.alertBody = "Time to add transactions!"
//        notification.alertAction = "be awesome!"
//        notification.soundName = UILocalNotificationDefaultSoundName
//        UIApplication.sharedApplication().scheduleLocalNotification(notification)
//    }
}
