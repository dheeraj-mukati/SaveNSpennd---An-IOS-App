//
//  AddBudgetVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 5/10/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class AddBudgetVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPicker: UIPickerView!
    
    @IBOutlet weak var budgetLimitField: UITextField!
    
    let realm = try! Realm()
    
    var categories = [String]()
    
    override func viewDidLoad() {
    
        fillCategoryPicker()
    }
    
    @IBAction func saveBudget(sender: UIBarButtonItem) {
        
        if budgetLimitField.text == "" {
            showErrorAlert()
        }else{
        
            let categoryType = "Expense"
            let selectedCategory = categories[self.categoryPicker.selectedRowInComponent(0)]
            
            let categoryTypePredict = NSPredicate(format: "type = %@", categoryType)
            let categoryNamePredict = NSPredicate(format: "name = %@", selectedCategory)
            let category = realm.objects(Category).filter(categoryTypePredict).filter(categoryNamePredict)[0]
            
            let budget = Budget()
            budget.id = budget.incrementaID()
            budget.limit = Double(budgetLimitField.text!)!
            budget.category = category
            
            // Add to the Realm inside a transaction
            try! realm.write {
                realm.add(budget)
            }
            showBudgetVC()
        }
    }
    
    @IBAction func cancelBudget(sender: UIBarButtonItem) {
        
        showBudgetVC()
    }
    
    func showBudgetVC(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func fillCategoryPicker(){
    
        let categoryType = "Expense"
        let predict = NSPredicate(format: "type = %@", categoryType)
        categories = realm.objects(Category).filter(predict).valueForKey("name") as! [String]
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return categories[row]
    }
    
    func showErrorAlert(){
        
        let alertController = UIAlertController(title: "Error", message:
            "Fields can not be blank!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
