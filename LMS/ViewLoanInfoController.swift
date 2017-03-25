//
//  ViewLoanInfoController.swift
//  Loan Management
//
//  Created by Ramesh Kolamala on 18/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import  CoreData
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
    @IBOutlet var progressBar: UIProgressView!
    
    @IBAction func updatePayment(_ sender: Any) {
        
    }
    
    @IBAction func setReminder(_ sender: UISwitch) {
        if (sender.isOn == true){
            reminderLabel.text = "Disable reminder"
        } else {
            reminderLabel.text = "Enable reminder"
        }
        
        /*let content = UNMutableNotificationContent()
        
        content.title = "Loan emi is due in 3 days"
        content.subtitle = "Loan for the month of march"
        content.body = "Please check your bank account to avoid charges"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Done", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)*/

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
        
        progressBar.progress = 0.3
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
