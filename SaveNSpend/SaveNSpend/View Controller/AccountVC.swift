//
//  AccountVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/16/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class AccountVC: UIViewController, AccountAddedDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var activityBar: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var openMenuItemBar: UIBarButtonItem!
    
    var customSC: UISegmentedControl!
    var accountBalanceLabel: UILabel!
    var addAccountUILabel: UILabel!
    let realm = try! Realm()
    var accounts: Results<(Account)>!
    
    // MARK: - Super class Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to delete default.real
        
        //        if let path = Realm.Configuration.defaultConfiguration.path {
        //            try! NSFileManager().removeItemAtPath(path)
        //        }
        
        openMenuItemBar.target = self.revealViewController()
        openMenuItemBar.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        activityBar.hidden = true
        accounts = realm.objects(Account)
        if accounts.count > 0 {
            createSubViews()
        } else {
            createCustomLabel()
        }
    }
    
    func accountAdded(bankAccount: Account, editedSegmentControlIndex: Int) {
        if accounts.count == 1 {
            if editedSegmentControlIndex == -1 {
                createSubViews()
                addAccountUILabel.removeFromSuperview()
            }else{
                customSC.setTitle(bankAccount.bankName, forSegmentAtIndex: editedSegmentControlIndex)
                accountBalanceLabel.text = "$" + String(bankAccount.balance)
            }
        } else {
            if editedSegmentControlIndex == -1 {
                customSC.insertSegmentWithTitle(bankAccount.bankName, atIndex: accounts.count, animated: true)
            }else{
                customSC.setTitle(bankAccount.bankName, forSegmentAtIndex: editedSegmentControlIndex)
                accountBalanceLabel.text = "$" + String(bankAccount.balance)
            }
            scrollView.contentSize = customSC.frame.size // updating scrolView width
        }
    }
    
    func createSubViews(){
        
        activityBar.hidden = false
        activityBar.startAnimating()
    
        if accounts.count > 0 {
            createCustomSegmentControl(accounts)
            let customView = createCustomView()
            createBalanceLabel(customView)
            createEditBankAccountIcon(customView)
            createAccountBalanceLabel(customView)
            setBankAccountBalanceText((accounts.first?.bankName)!)
            
        } else {
            createCustomLabel()
        }
        activityBar.stopAnimating()
        activityBar.hidden = true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let addAccountVC = segue.destinationViewController as! AddAccountVC
        addAccountVC.delegate = self
    }
    // MARK: - Custom UIView Functions
    
    func createCustomLabel(){
        
        addAccountUILabel = UILabel()
        addAccountUILabel.textAlignment = .Center
        addAccountUILabel.font = addAccountUILabel.font.fontWithSize(18)
        addAccountUILabel.text = "Click on + sign to add a new account"
        addAccountUILabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(addAccountUILabel)
        
        let widthConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400)
        addAccountUILabel.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        addAccountUILabel.addConstraint(heightConstraint)
        
        let xConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: addAccountUILabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        
        self.view.addConstraint(xConstraint)
        self.view.addConstraint(yConstraint)
    }
    
    
    func createCustomSegmentControl(accounts: Results<(Account)>) {
        
        let bankNames = accounts.valueForKey("bankName") as! [String]
        customSC = UISegmentedControl(items: bankNames)
        customSC.selectedSegmentIndex = 0
        customSC.translatesAutoresizingMaskIntoConstraints = false
        customSC.addTarget(self, action: #selector(AccountVC.bankAccountChanged(_:)), forControlEvents: .ValueChanged)
        let attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 17.0)!, forKey: NSFontAttributeName)
        customSC.setTitleTextAttributes(attr as [NSObject : AnyObject] , forState: .Normal)
        self.scrollView.addSubview(customSC)
        
        scrollView.contentSize = customSC.frame.size
        var xConstraint = NSLayoutConstraint()
        var yConstraint = NSLayoutConstraint()
        if customSC.frame.width <= self.view.frame.width {
            xConstraint = NSLayoutConstraint(item: customSC, attribute: .CenterX, relatedBy: .Equal, toItem: self.scrollView, attribute: .CenterX, multiplier: 1, constant: 0)
            
            yConstraint = NSLayoutConstraint(item: customSC, attribute: .Top, relatedBy: .Equal, toItem: self.scrollView, attribute: .Top, multiplier: 1, constant: 8)
        }else {
            xConstraint = NSLayoutConstraint(item: customSC, attribute: .Left, relatedBy: .Equal, toItem: self.scrollView, attribute: .Left, multiplier: 1, constant: 8)
            
            yConstraint = NSLayoutConstraint(item: customSC, attribute: .CenterY, relatedBy: .Equal, toItem: self.scrollView, attribute: .CenterY, multiplier: 1, constant: 5)
        }
        
        let heightConstraint = NSLayoutConstraint(item: customSC, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 55)
        
        self.scrollView.addConstraint(heightConstraint)
        self.scrollView.addConstraint(xConstraint)
        self.scrollView.addConstraint(yConstraint)
    }
    
    func createCustomView() -> UIView {
        
        let customView = UIView()
        customView.backgroundColor = UIColor.lightGrayColor()
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.layer.cornerRadius = 5
        view.addSubview(customView)
        
        let horizontalConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        view.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: customView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 150)
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
    
    func createEditBankAccountIcon(superView : UIView){
        
        let editBankAccount = UIImage(named: "edit.png")
        let editBankAccountView = UIImageView(image: editBankAccount)
        editBankAccountView.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AccountVC.editBankAccount(_:)))
        editBankAccountView.userInteractionEnabled = true
        editBankAccountView.addGestureRecognizer(tapGestureRecognizer)
        superView.addSubview(editBankAccountView)
        
        let heightConstraint = NSLayoutConstraint(item: editBankAccountView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        editBankAccountView.addConstraint(heightConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: editBankAccountView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        editBankAccountView.addConstraint(widthConstraint)
        
        let xConstraint = NSLayoutConstraint(item: editBankAccountView, attribute: .Top, relatedBy: .Equal, toItem: superView, attribute: .Top, multiplier: 1, constant: 8)
        
        let yConstraint = NSLayoutConstraint(item: editBankAccountView, attribute: .Right, relatedBy: .Equal, toItem: superView, attribute: .Right, multiplier: 1, constant: -8)
        
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
    
    func editBankAccount(img: AnyObject){
        
        let selectedBankAcount = customSC.titleForSegmentAtIndex(customSC.selectedSegmentIndex)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addAccountVC = storyboard.instantiateViewControllerWithIdentifier("add_account_strb_id") as! AddAccountVC
        let account = Account()
        account.bankName = selectedBankAcount
        addAccountVC.bankAccountToBeEdit = account
        addAccountVC.editedSegmentControlIndex = customSC.selectedSegmentIndex
        addAccountVC.delegate = self
        self.navigationController?.pushViewController(addAccountVC, animated: true)
    }
}
