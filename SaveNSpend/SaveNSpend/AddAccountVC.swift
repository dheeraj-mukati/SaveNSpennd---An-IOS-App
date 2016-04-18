//
//  AddAccountController.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/16/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class AddAccountVC: UIViewController {

    
    @IBOutlet weak var accountName: UITextField!
    
    @IBOutlet weak var balance: UITextField!
    
    // Get the default Realm
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAccountToDB(sender: UIBarButtonItem) {
        
        //creating category
        
        let account = Account()
        account.id = account.incrementaID()
        account.bankName = accountName.text!
        account.balance = Int(balance.text!)!
        
        // Add to the Realm inside a transaction
        try! realm.write {
            realm.add(account)
        }
        
        print("Object saved")
        print(account.id)
        showAccountsVC()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        showAccountsVC()
        
    }
    
    func showAccountsVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountVC = storyboard.instantiateViewControllerWithIdentifier("accounts_strb_id") as! AccountVC
        self.presentViewController(accountVC, animated: true, completion: nil)
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
