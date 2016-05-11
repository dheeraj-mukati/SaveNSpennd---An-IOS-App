//
//  SettingsVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 5/11/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var openMenuItemBar: UIBarButtonItem!
    @IBOutlet weak var currencySymbolPicker: UIPickerView!
    
    var cirrencySymbols = ["$","£","¥","₨","฿"]
    
    override func viewDidLoad() {
        
        openMenuItemBar.target = self.revealViewController()
        openMenuItemBar.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    @IBAction func saveSettings(sender: UIBarButtonItem) {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setValue(cirrencySymbols[currencySymbolPicker.selectedRowInComponent(0)], forKey: "cirrencySymbol")
        
        showSuccessAlert()
    }
    
    func showSuccessAlert(){
        
        let alertController = UIAlertController(title: "success", message:
            "Settings have  been saved!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cirrencySymbols.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return cirrencySymbols[row]
    }
}
