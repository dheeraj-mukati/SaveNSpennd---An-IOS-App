//
//  CategoryVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/20/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryType: UISegmentedControl!
    @IBOutlet weak var categoryData: UITableView!
    
    
    let realm = try! Realm()
    var categories: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        shoeCategoryData()
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let categoryCell = tableView.dequeueReusableCellWithIdentifier("category_cell", forIndexPath: indexPath)
        
        categoryCell.textLabel?.text = categories[indexPath.row]
        
        return categoryCell

    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedCategory = categories[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addCategoryVC = storyboard.instantiateViewControllerWithIdentifier("add_category_strb_id") as! AddCategoryVC
        let category = Category()
        category.name = selectedCategory
        category.type = categoryType.titleForSegmentAtIndex(categoryType.selectedSegmentIndex)!
        addCategoryVC.categoryToBeEdit = category
        self.presentViewController(addCategoryVC, animated: true, completion: nil)
    }
    
    @IBAction func changeCategoryData(sender: UISegmentedControl) {

        shoeCategoryData()
        categoryData.reloadData()
    }
    
    func shoeCategoryData(){
    
        let SelectedCategoryType = categoryType.titleForSegmentAtIndex(categoryType.selectedSegmentIndex)!
        print(SelectedCategoryType)
        // Do any additional setup after loading the view.
        let predict = NSPredicate(format: "type = %@", SelectedCategoryType)
        categories = realm.objects(Category).filter(predict).valueForKey("name") as! [String]
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
