//
//  BudgetVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 5/10/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class BudgetVC: UIViewController {

    @IBOutlet weak var openMenuItemBar: UIBarButtonItem!
    
    @IBOutlet weak var contentView: UIView!
    
    let realm = try! Realm()
    var budgets = [Budget]()
    let dateUtils = DateUtils()
    
    var addBudgetUILabel = UILabel()
    
    let customBdgetsUIViewHeight = CGFloat(70)
    let topConstraints = CGFloat(15)
    override func viewDidLoad() {
        
        openMenuItemBar.target = self.revealViewController()
        openMenuItemBar.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        createBudgets()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        createBudgets()
    }
    
    func createBudgets(){
        
        let date = NSDate()
        budgets = Array(realm.objects(Budget).filter("date > %@ AND date <= %@", dateUtils.startOfMonth(date)!, dateUtils.endOfMonth(date)!))
        
        addBudgetUILabel.text = ""
        
        if budgets.count > 0 {
            
            var toalLimitOfMonth = 0.0
            var totalTransactionAmoutOfMonth = 0.0
            
            var budgetCount = CGFloat(1)
            for budget in budgets {
                
                toalLimitOfMonth = toalLimitOfMonth + budget.limit
                let customBudgetUIView = createBudgetsUIView((budgetCount * (topConstraints + customBdgetsUIViewHeight)))
                let totalTransactionAmount = getTotalTransactionAmount(budget.category!)
                totalTransactionAmoutOfMonth = totalTransactionAmoutOfMonth + totalTransactionAmount
                
                createBudgetsElement(customBudgetUIView, progressBarLabel: (budget.category?.name)!, totalTransactionAmount: totalTransactionAmount, limit: budget.limit)
                budgetCount += 1
            }
            
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
            let monthName = NSDateFormatter().monthSymbols[components.month - 1]
            let progressBarLabel = monthName + " " + String(year)
            
            let customBudgetUIView = createMonthBudgetUIView(CGFloat(0))
            createBudgetsElement(customBudgetUIView, progressBarLabel: progressBarLabel, totalTransactionAmount: totalTransactionAmoutOfMonth, limit: toalLimitOfMonth)
            
        } else {
            createNoBudgetCustomLabel()
        }
    }
    
    func createBudgetsElement(customBudgetUIView: UIView, progressBarLabel: String, totalTransactionAmount: Double, limit:Double){
    
        careateCategoryLabelInBudgetUIView(customBudgetUIView, categoryName: progressBarLabel)
        
        var isLimitCrossed = false
        var isTotalReachedNearToLimit = false
        
        var leftLimitLabelText = "$"
        if totalTransactionAmount <= limit {
            leftLimitLabelText = leftLimitLabelText + String(limit - totalTransactionAmount) + " Left"
        }else{
            isLimitCrossed = true
            leftLimitLabelText = leftLimitLabelText + String(totalTransactionAmount - limit) + " Over"
        }
        
        if totalTransactionAmount > ((limit) * (80/100)){
            isTotalReachedNearToLimit = true
        }
        createLeftLimitUILabel(customBudgetUIView, leftLimit: leftLimitLabelText)
        
        createBudgetProgressBar(customBudgetUIView, limit: limit, totalTransactionAmount: Float(totalTransactionAmount),isLimitCrossed: isLimitCrossed,isTotalReachedNearToLimit: isTotalReachedNearToLimit)
        
        let limitLabelText = "$" + String(totalTransactionAmount) + " of " + "$" + String(limit)
        createLimitUILabel(customBudgetUIView, limit: limitLabelText)
    }
    
    func getTotalTransactionAmount(category: Category) -> Double{
        
        var totalTransactionAmount = 0.0
        let date = NSDate()
        let transactions = Array(realm.objects(Transaction).filter("date > %@ AND date <= %@", dateUtils.startOfMonth(date)!, dateUtils.endOfMonth(date)!).filter("category = %@",category))
        
        for transaction in transactions{
            totalTransactionAmount = totalTransactionAmount + transaction.amount
        }
        return totalTransactionAmount
    }
    
    func createNoBudgetCustomLabel(){
        
        addBudgetUILabel = UILabel()
        addBudgetUILabel.textAlignment = .Center
        addBudgetUILabel.font = addBudgetUILabel.font.fontWithSize(18)
        addBudgetUILabel.text = "Click on + sign to add a new budget"
        addBudgetUILabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addBudgetUILabel)
        
        let widthConstraint = NSLayoutConstraint(item: addBudgetUILabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400)
        addBudgetUILabel.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: addBudgetUILabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        addBudgetUILabel.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: addBudgetUILabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: addBudgetUILabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)
    }
    
    func createMonthBudgetUIView(topConstraint: CGFloat) -> UIView{
        
        let customView = UIView()
        customView.backgroundColor = UIColor.whiteColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        //customView.layer.cornerRadius = 5
        customView.layer.borderWidth = 0.5
        contentView.addSubview(customView)
        
        let horizontalConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        contentView.addConstraint(horizontalConstraint)
        
        let topConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topConstraint)
        contentView.addConstraint(topConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        contentView.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        contentView.addConstraint(rightConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: customBdgetsUIViewHeight)
        contentView.addConstraint(heightConstraint)
        
        return customView
    }
    
    func createBudgetsUIView(topConstraint: CGFloat) -> UIView{

        let customView = UIView()
        customView.backgroundColor = UIColor.whiteColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.cornerRadius = 5
        customView.layer.borderWidth = 0.5
        contentView.addSubview(customView)
        
        let horizontalConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        contentView.addConstraint(horizontalConstraint)
        
        let topConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: topConstraint)
        contentView.addConstraint(topConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 15)
        contentView.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -15)
        contentView.addConstraint(rightConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: customBdgetsUIViewHeight)
        contentView.addConstraint(heightConstraint)
        
        return customView
    }
    
    func createBudgetProgressBar(customBudgetUIView : UIView, limit: Double, totalTransactionAmount: Float,isLimitCrossed : Bool,isTotalReachedNearToLimit :Bool){
        // Create Progress View Control
        let progressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        customBudgetUIView.addSubview(progressView)
        
        progressView.tintColor = UIColor(hue: 0.3806, saturation: 1, brightness: 0.79, alpha: 1.0) /* #00c939 */
        
        if isTotalReachedNearToLimit {
            progressView.tintColor = UIColor(hue: 0.15, saturation: 0.83, brightness: 0.95, alpha: 1.0) /* #f2de29 */
        }
        
        if isLimitCrossed {
            progressView.tintColor = UIColor(hue: 0.0222, saturation: 0.8, brightness: 0.97, alpha: 1.0) /* #f74b31 */
        }
        
        let ratio = Float(totalTransactionAmount) / Float(limit)
        progressView.setProgress(ratio, animated: true)
        
        let topConstraint = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 35)
        customBudgetUIView.addConstraint(topConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 15)
        customBudgetUIView.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -15)
        customBudgetUIView.addConstraint(rightConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: progressView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 26)
        progressView.addConstraint(heightConstraint)
    }
    
    func careateCategoryLabelInBudgetUIView(customBudgetUIView : UIView, categoryName: String){
        
        let categoryUILabel = UILabel()
        categoryUILabel.textAlignment = .Center
        categoryUILabel.font = categoryUILabel.font.fontWithSize(18 )
        categoryUILabel.text = categoryName
        categoryUILabel.translatesAutoresizingMaskIntoConstraints = false
        customBudgetUIView.addSubview(categoryUILabel)
        
        let leftConstraint = NSLayoutConstraint(item: categoryUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 15)
        customBudgetUIView.addConstraint(leftConstraint)
        
        let topConstraint = NSLayoutConstraint(item: categoryUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 8)
        customBudgetUIView.addConstraint(topConstraint)
    }
    
    func createLimitUILabel(customBudgetUIView : UIView, limit: String){
        
        let limitUILabel = UILabel()
        limitUILabel.textAlignment = .Center
        limitUILabel.textColor = UIColor.whiteColor()
        limitUILabel.font = limitUILabel.font.fontWithSize(14)
        limitUILabel.text = limit
        limitUILabel.translatesAutoresizingMaskIntoConstraints = false
        customBudgetUIView.addSubview(limitUILabel)
        
        let leftConstraint = NSLayoutConstraint(item: limitUILabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
        customBudgetUIView.addConstraint(leftConstraint)
        
        let topConstraint = NSLayoutConstraint(item: limitUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 40)
        customBudgetUIView.addConstraint(topConstraint)
    }
    
    func createLeftLimitUILabel(customBudgetUIView : UIView, leftLimit: String){
        
        let leftLimitUILabel = UILabel()
        leftLimitUILabel.textAlignment = .Center
        leftLimitUILabel.font = leftLimitUILabel.font.fontWithSize(17)
        leftLimitUILabel.text = leftLimit
        leftLimitUILabel.translatesAutoresizingMaskIntoConstraints = false
        customBudgetUIView.addSubview(leftLimitUILabel)
        
        let rightConstraint = NSLayoutConstraint(item: leftLimitUILabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
        customBudgetUIView.addConstraint(rightConstraint)
        
        let topConstraint = NSLayoutConstraint(item: leftLimitUILabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: customBudgetUIView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 8)
        customBudgetUIView.addConstraint(topConstraint)
    }
}
