//
//  AddTransactionVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/23/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class AddTransactionVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK:- Properties
    
    @IBOutlet weak var transactionType: UISegmentedControl!
    
    @IBOutlet weak var transactionDate: UIDatePicker!
    
    @IBOutlet weak var category: UIPickerView!
    
    @IBOutlet weak var transactionAmount: UITextField!
    
    @IBOutlet weak var bankAccount: UIPickerView!
    
    let realm = try! Realm()
    
    var categories = [String]()
    var bankAccounts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        category.tag = 0
        bankAccount.tag = 1
        
        updateCategoryTypeData()
        
    }

    @IBAction func saveTransaction(sender: UIBarButtonItem) {
        
        let transaction = Transaction()
        transaction.id = transaction.incrementaID()
        transaction.amount = Double(transactionAmount.text!)!
        transaction.date = transactionDate.date
        print(transaction.date)
    
        let selectedTransactionType = transactionType.titleForSegmentAtIndex(transactionType.selectedSegmentIndex)!
        
        let selectedCategory = categories[self.category.selectedRowInComponent(0)]
        
        let categoryTypePredict = NSPredicate(format: "type = %@", selectedTransactionType)
        let categoryNamePredict = NSPredicate(format: "name = %@", selectedCategory)
        let category = realm.objects(Category).filter(categoryTypePredict).filter(categoryNamePredict)[0]
        
        transaction.category = category
        
        let selectedBankAccount = bankAccounts[self.bankAccount.selectedRowInComponent(0)]
        let bankAccountNamePredict = NSPredicate(format: "bankName = %@", selectedBankAccount)
        
        let bankAccount = realm.objects(Account).filter(bankAccountNamePredict)[0]
        transaction.account = bankAccount
        
        // Add to the Realm inside a transaction
        try! realm.write {
            realm.add(transaction, update: true)
        }
        
        print(transaction)
        
        showTransactionVC()
    }
    
    @IBAction func cancelTransaction(sender: AnyObject) {
        showTransactionVC()
        
    }
    @IBAction func transactionTypeChanged(sender: UISegmentedControl) {
        updateCategoryTypeData()
        category.reloadComponent(0)
    }
    
    
    func updateCategoryTypeData() {
        
        let selectedTransactionType = transactionType.titleForSegmentAtIndex(transactionType.selectedSegmentIndex)!
        
        let predict = NSPredicate(format: "type = %@", selectedTransactionType)
        categories = realm.objects(Category).filter(predict).valueForKey("name") as! [String]
        
        bankAccounts = realm.objects(Account).valueForKey("bankName") as! [String]
    }
    
    func showTransactionVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let transactionVC = storyboard.instantiateViewControllerWithIdentifier("transaction_strb_id") as! TransactionVC
        self.presentViewController(transactionVC, animated: true, completion: nil)
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return categories.count
        } else if pickerView.tag == 1 {
            return bankAccounts.count
        }
        return 1
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 0 {
            return categories[row]
        } else if pickerView.tag == 1 {
            return bankAccounts[row]
        }
        return ""
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
