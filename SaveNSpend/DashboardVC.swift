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
    
    @IBOutlet weak var totalSpentBarUIView: UIView!
    
    @IBOutlet weak var totalEarnedBarUIView: UIView!
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    @IBOutlet weak var transactionsMonth: UILabel!
    
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
        totalSpentBarUIView.layer.cornerRadius = 5
        totalEarnedBarUIView.layer.cornerRadius = 5
        //bankAccountsContentView.backgroundColor = UIColor.lightGrayColor()
        
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
        }
        print("scrol width: \(scrollView.contentSize.width)")
        print("scrol width: \(bankAccountsContentView.frame.width)")
        print("view width: \(view.frame.width)")
        //scrollView.contentSize = bankAccountsContentView.frame.size
        print("scrol width1: \(scrollView.contentSize.width)")
        print("scrol width1: \(bankAccountsContentView.frame.width)")
        print("view width1: \(view.frame.width)")
        
        
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
        
        let widthConstraint = NSLayoutConstraint(item: customView, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: bankAccountUIViewWidth)
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
        
        //let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        //let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        var categories = [String]()
        var transactionsAmount = [Double]()
        
        for transaction in transactions {
            categories.append((transaction.category?.name)!)
            transactionsAmount.append(transaction.amount)
        }
        setChart(categories, values: transactionsAmount)
        
        setTransactionMonth()
    }
    
    private func setTransactionMonth(){
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: currentDate)
        
        let year =  components.year
        let monthName = NSDateFormatter().monthSymbols[components.month - 1]
        
        transactionsMonth.text = monthName + " " + String(year)
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<transactions.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Units Sold")
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
        
        pieChartDataSet.colors = colors
    }
}
