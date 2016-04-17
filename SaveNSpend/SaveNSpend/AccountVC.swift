//
//  AccountVC.swift
//  SaveNSpend
//
//  Created by Dheeraj Mukati on 4/16/16.
//  Copyright © 2016 Dheeraj Mukati. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Initialize
        let items = ["Purple", "Green", "Blue"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        let frame = UIScreen.mainScreen().bounds
        customSC.frame = CGRectMake(frame.minX + 10, frame.minY + 70,
                                    frame.width - 20, frame.height*0.1)
        
        let xConstraint = NSLayoutConstraint(item: customSC, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)        // Add this custom Segmented Control to our view
        
        customSC.addConstraint(xConstraint)
        self.view.addSubview(customSC)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
