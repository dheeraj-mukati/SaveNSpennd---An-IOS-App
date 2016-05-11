//
//  AddCategoryVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/20/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class AddCategoryVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK:- Properties
    
    @IBOutlet weak var categoryType: UIPickerView!
    @IBOutlet weak var categoryName: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var categoryToBeEdit: Category!
    
    let categoryTypeArray = ["Expense","Income"]

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if categoryToBeEdit != nil {
            
            navigationBar.topItem?.title = "Edit Category"
            
            let predict = NSPredicate(format: "name = %@", categoryToBeEdit.name)
            categoryToBeEdit = realm.objects(Category).filter(predict)[0]
            print(categoryToBeEdit.name)
            categoryName.text = categoryToBeEdit.name
            categoryType.selectRow(categoryTypeArray.indexOf(categoryToBeEdit.type)!, inComponent: 0, animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryTypeArray.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryTypeArray[row]
    }
    
    @IBAction func addCategory(sender: AnyObject) {
        
        //creating category
        if categoryName.text == "" {
            showErrorAlert()
            
        }else{
        
            let category = Category()
            if categoryToBeEdit != nil {
                category.id = categoryToBeEdit.id
            }else {
                category.id = category.incrementaID()
            }
            
            category.name = categoryName.text!
            category.type = categoryTypeArray[categoryType.selectedRowInComponent(0)]
            
            // Add to the Realm inside a transaction
            try! realm.write {
                realm.add(category, update: true)
            }
            
            showCategoryVC()
        }
    }
    
    @IBAction func cancelAddCategory(sender: AnyObject) {
        
        showCategoryVC()
    }
    
    func showCategoryVC(){
        
        self.navigationController?.popViewControllerAnimated(true)
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let categoryVC = storyboard.instantiateViewControllerWithIdentifier("category_strb_id") as! CategoryVC
        //self.presentViewController(categoryVC, animated: true, completion: nil)
    }

    func showErrorAlert(){
        
        let alertController = UIAlertController(title: "Error", message:
            "Fields can not be blank!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
