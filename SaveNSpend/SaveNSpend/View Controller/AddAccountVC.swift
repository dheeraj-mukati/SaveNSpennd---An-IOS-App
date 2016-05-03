//
//  AddAccountController.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/16/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

protocol AccountAddedDelegate{
    func accountAdded(bankAccount:Account, editedSegmentControlIndex:Int)
}
class AddAccountVC: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var accountName: UITextField!
    
    @IBOutlet weak var balance: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
     var delegate:AccountAddedDelegate? = nil
    
    var bankAccountToBeEdit: Account!
    
    var editedSegmentControlIndex = -1
    
    // Get the default Realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bankAccountToBeEdit != nil {
            
            navigationBar.topItem?.title = "Edit Account"
            
            let predict = NSPredicate(format: "bankName = %@", bankAccountToBeEdit.bankName)
            bankAccountToBeEdit = realm.objects(Account).filter(predict)[0]
            print(bankAccountToBeEdit.bankName)
            accountName.text = bankAccountToBeEdit.bankName
            balance.text = String(bankAccountToBeEdit.balance)
        }
    }
    
    @IBAction func addAccountToDB(sender: UIBarButtonItem) {
        
        //creating category
        if accountName.text == "" || balance.text == "" {
            showErrorAlert()
        }else{
            let account = Account()
            account.bankName = accountName.text!
            account.balance = Double(balance.text!)!
            
            if bankAccountToBeEdit != nil {
                account.id = bankAccountToBeEdit.id
            }else{
                account.id = account.incrementaID()
            }
            
            // Add to the Realm inside a transaction
            try! realm.write {
                realm.add(account, update: true)
            }
            
            if bankAccountToBeEdit != nil {
                delegate?.accountAdded(account, editedSegmentControlIndex: editedSegmentControlIndex)
            }else{
                delegate?.accountAdded(account, editedSegmentControlIndex: editedSegmentControlIndex)
            }
            
            if (delegate != nil){
                showAccountsVC()
            }
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        showAccountsVC()
    }
    
    func showErrorAlert(){
    
        let alertController = UIAlertController(title: "Error", message:
            "Fields can not be blank!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showAccountsVC(){
        self.navigationController?.popViewControllerAnimated(true)
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let accountVC = storyboard.instantiateViewControllerWithIdentifier("accounts_strb_id") as! AccountVC
        //self.presentViewController(accountVC, animated: true, completion: nil)
    }
}
