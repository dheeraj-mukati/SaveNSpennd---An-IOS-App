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
    
    var categoryToBeEdited: String!
    var categoryToBeEditedType: String!
    
    let categoryTypeArray = ["Expense","Income"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("h")
        print(categoryToBeEdited)
        print(categoryToBeEditedType)
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
        
        let category = Category()
        category.id = category.incrementaID()
        category.name = categoryName.text!
        category.type = categoryTypeArray[categoryType.selectedRowInComponent(0)]
        let realm = try! Realm()
        // Add to the Realm inside a transaction
        try! realm.write {
            realm.add(category, update: true)
        }
        
        print(category)
        print("Object saved")
        print(category.id)
        showCategoryVC()
    }
    
    @IBAction func cancelAddCategory(sender: AnyObject) {
        
        showCategoryVC()
    }
    
    func showCategoryVC(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryVC = storyboard.instantiateViewControllerWithIdentifier("category_strb_id") as! CategoryVC
        self.presentViewController(categoryVC, animated: true, completion: nil)
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
