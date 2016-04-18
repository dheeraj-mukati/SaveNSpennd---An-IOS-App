//
//  AccountVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/16/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class AccountVC: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var activityBar: UIActivityIndicatorView!
    
    var accountBalanceLabel: UILabel!
    let realm = try! Realm()
    
    // MARK: - Super class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // to delete default.real
        
//        if let path = Realm.Configuration.defaultConfiguration.path {
//            try! NSFileManager().removeItemAtPath(path)
//        }
        
        activityBar.hidden = false
        activityBar.startAnimating()
        
        let accounts = realm.objects(Account)
        
        if accounts.count > 0 {
            createCustomSegmentControl(accounts)
            let customView = createCustomView()
            createBalanceLabel(customView)
            createAccountBalanceLabel(customView)
            setBankAccountBalanceText((accounts.first?.bankName)!)
            
            
        } else {
            createCustomLabel()
        }
        activityBar.stopAnimating()
        activityBar.hidden = true
        
    }
    
    // MARK: - Custom UIView Functions
    
    func createCustomLabel(){
    
        let customLabel = UILabel()
        customLabel.textAlignment = .Center
        customLabel.font = customLabel.font.fontWithSize(18)
        customLabel.text = "Click on + sign to add a new account"
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(customLabel)
        
        let widthConstraint = NSLayoutConstraint(item: customLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400)
        customLabel.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: customLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        customLabel.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: customLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: customLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)
    }
    
    
    func createCustomSegmentControl(accounts: Results<(Account)>) {
        
        let bankNames = accounts.valueForKey("bankName") as! [String]
        let customSC = UISegmentedControl(items: bankNames)
        customSC.selectedSegmentIndex = 0
        customSC.translatesAutoresizingMaskIntoConstraints = false
        customSC.addTarget(self, action: #selector(AccountVC.bankAccountChanged(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(customSC)
        
        let xConstraint = NSLayoutConstraint(item: customSC, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: customSC, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: navigationBar.frame.size.height + 10)
        
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)
    }
    
    func createCustomView() -> UIView {
    
        let customView = UIView()
        customView.backgroundColor = UIColor.lightGrayColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.cornerRadius = 5
        view.addSubview(customView)
        
        let horizontalConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 120)
        view.addConstraint(verticalConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 10)
        view.addConstraint(leftConstraint)
        
        let rightConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -10)
        view.addConstraint(rightConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
        view.addConstraint(heightConstraint)
        
        return customView
    }
    
    func createBalanceLabel(superView : UIView) {
        
        let balanceLabel = UILabel()
        balanceLabel.text = "Balance"
        balanceLabel.textAlignment = .Center
        balanceLabel.font = balanceLabel.font.fontWithSize(18)
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(balanceLabel)
        
        let xConstraint = NSLayoutConstraint(item: balanceLabel, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1, constant: 8)
        
        let yConstraint = NSLayoutConstraint(item: balanceLabel, attribute: .Left, relatedBy: .Equal, toItem: superView, attribute: .Left, multiplier: 1, constant: 8)
        
        superView.addConstraint(xConstraint)
        superView.addConstraint(yConstraint)
    }
    
    func createAccountBalanceLabel(superView : UIView){
    
        accountBalanceLabel = UILabel()
        accountBalanceLabel.textAlignment = .Center
        accountBalanceLabel.font = accountBalanceLabel.font.fontWithSize(30)
        accountBalanceLabel.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(accountBalanceLabel)
        
        let xConstraint = NSLayoutConstraint(item: accountBalanceLabel, attribute: .CenterX, relatedBy: .Equal, toItem: superView, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: accountBalanceLabel, attribute: .CenterY, relatedBy: .Equal, toItem: superView, attribute: .CenterY, multiplier: 1, constant: 0)
        
        superView.addConstraint(xConstraint)
        superView.addConstraint(yConstraint)
    }
    
    func bankAccountChanged(sender:UISegmentedControl!){
        print(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)
        setBankAccountBalanceText(sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)!)
    }
    
    func setBankAccountBalanceText(bankName: String){
        
        let predict = NSPredicate(format: "bankName = %@", bankName)
        let firstBankAccountBalance = realm.objects(Account).filter(predict).valueForKey("balance") as! NSArray
        print(firstBankAccountBalance[0])
        accountBalanceLabel.text = "$" + String(firstBankAccountBalance[0])
    }
}
