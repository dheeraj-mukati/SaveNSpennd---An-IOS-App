//
//  DashboardVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/29/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class DashboardVC: UIViewController {

    @IBOutlet weak var bankAccountMainUIView: UIView!
    @IBOutlet weak var bankAccountsContentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        
        bankAccountMainUIView.layer.cornerRadius = 5
        bankAccountsContentView.layer.cornerRadius = 5
        bankAccountsContentView.backgroundColor = UIColor.lightGrayColor()
        
        let accounts = Array(realm.objects(Account))
        print(accounts.count)
        if accounts.count > 0 {
        
            var bankAccountCount = 0
            var fisrAccountFlag = true
            for account in accounts {
                var bankAccountUIView:UIView
                if fisrAccountFlag {
                    bankAccountUIView = createBankAccountUIView(CGFloat(bankAccountCount * 5))
                    fisrAccountFlag = false
                }else{
                    bankAccountUIView = createBankAccountUIView(CGFloat((bankAccountCount * 150) + (bankAccountCount * 5)))
                }
                createBankAccountNameUILabel(bankAccountUIView, bankName: account.bankName)
                createAccountBalanceUILabel(bankAccountUIView, balance: String(account.balance))
                bankAccountCount += 1
            }
        }
        print("scrol width: \(scrollView.contentSize.width)")
        print("scrol width: \(bankAccountsContentView.frame.width)")
        print("view width: \(view.frame.width)")
        scrollView.contentSize = bankAccountsContentView.frame.size
        print("scrol width1: \(scrollView.contentSize.width)")
        print("scrol width1: \(bankAccountsContentView.frame.width)")
        print("view width1: \(view.frame.width)")
    }
    
    func createBankAccountUIView(leftConstant: CGFloat) -> UIView {
        
        let customView = UIView()
        customView.backgroundColor = UIColor.blueColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.cornerRadius = 5
        bankAccountsContentView.addSubview(customView)
        
        let topConstraint = NSLayoutConstraint(item: customView, attribute: .Top, relatedBy: .Equal, toItem: bankAccountsContentView, attribute: .Top, multiplier: 1, constant: 5)
        bankAccountsContentView.addConstraint(topConstraint)
        
        let bottomConstraint = NSLayoutConstraint(item: customView, attribute: .Bottom, relatedBy: NSLayoutRelation.Equal, toItem: bankAccountsContentView, attribute: .Bottom, multiplier: 1, constant: -5)
        bankAccountsContentView.addConstraint(bottomConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: customView, attribute: .Left, relatedBy: .Equal, toItem: bankAccountsContentView, attribute: .Left, multiplier: 1, constant: leftConstant)
        bankAccountsContentView.addConstraint(leftConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: customView, attribute: .Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 150)
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
}
