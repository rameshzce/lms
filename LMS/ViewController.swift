//
//  ViewController.swift
//  Loan Management
//
//  Created by Ramesh Kolamala on 18/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var newLoan: UIButton!
    @IBOutlet var allLoans: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.barTintColor = Helper.hexStringToUIColor("#006400")
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        
        Helper.customButton(newLoan)
        Helper.customButton(allLoans)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

