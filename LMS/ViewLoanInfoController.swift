//
//  ViewLoanInfoController.swift
//  Loan Management
//
//  Created by Ramesh Kolamala on 18/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class ViewLoanInfoController: UIViewController {
    
    var loanName: String?
    
    @IBOutlet var loanNameLabel: UILabel!
    @IBOutlet var loanAmount: UILabel!
    @IBOutlet var loanTenure: UILabel!
    @IBOutlet var loanStartDate: UILabel!
    @IBOutlet var loanEndDate: UILabel!
    @IBOutlet var loanEmi: UILabel!
    @IBOutlet var reminderLabel: UILabel!

    
    @IBAction func deleteLoan(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "LMS", message: "Are you sure to delete?", preferredStyle: .alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            deleteAlert.dismiss(animated: true, completion: nil)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Loans")
            
            request.predicate = NSPredicate(format: "name = %@", self.loanName!)
            
            request.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(request)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        
                       context.delete(result)
                        
                        do {
                            try context.save()
                            
                            //print("Deleted: " + self.loanName!)
                            self.performSegue(withIdentifier: "deleteLoan", sender: nil)
                        } catch {
                            print("Error")
                        }

                    }
                } else {
                    print("No data")
                }
            } catch {
                print("Delete error")
            }

            
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            deleteAlert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        
        
        //loanName = "Loan 1"
        
        self.title = loanName
        
        loanNameLabel.text = loanName
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Loans")
        
        request.predicate = NSPredicate(format: "name = %@", loanName!)
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    
                    if let loanAmount = result.value(forKey: "amount") as? Int {
                        self.loanAmount.text = String("\(loanAmount)")
                    }
                    
                    if let loanTenure = result.value(forKey: "tenure") as? Int {
                        self.loanTenure.text = String("\(loanTenure)")
                    }
                    
                    if let loanStartDate = result.value(forKey: "startDate") as? String {
                        self.loanStartDate.text = "\(loanStartDate)"
                    }
                    
                    if let loanEndDate = result.value(forKey: "endDate") as? String {
                        self.loanEndDate.text = "\(loanEndDate)"
                    }
                    
                    if let loanEmi = result.value(forKey: "emi") as? Int {
                        self.loanEmi.text = String("\(loanEmi)")
                    }
                }
            } else {
                print("No data")
            }
        } catch {
            print("Could not fetch data")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
