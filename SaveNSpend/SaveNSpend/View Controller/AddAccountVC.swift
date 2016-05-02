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
    func accountAdded(bankName:String, isAccountEdited:Bool)
}
class AddAccountVC: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var accountName: UITextField!
    
    @IBOutlet weak var balance: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
     var delegate:AccountAddedDelegate? = nil
    
    var bankAccountToBeEdit: Account!
    
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
            if bankAccountToBeEdit != nil {
                delegate?.accountAdded(accountName.text!, isAccountEdited: true)
                account.id = bankAccountToBeEdit.id
            }else{
                delegate?.accountAdded(accountName.text!, isAccountEdited: false)
                account.id = account.incrementaID()
            }
            account.bankName = accountName.text!
            account.balance = Int(balance.text!)!
            
            // Add to the Realm inside a transaction
            try! realm.write {
                realm.add(account, update: true)
            }
            
            print("Object saved")
            print(account.id)
            
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
