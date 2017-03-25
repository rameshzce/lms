//
//  CreateNewLoanController.swift
//  Loan Management
//
//  Created by Ramesh Kolamala on 18/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import CoreData
import  UserNotifications

class CreateNewLoanController: UIViewController {
    var lName: String = ""
    var lAmount: Int = 0;
    var lTenure: Int = 0;
    var lStartDate: String = ""
    var lEndDate: String = ""
    var lEmi: Int = 0;
    
    @IBOutlet var loanName: UITextField!
    @IBOutlet var loanAmount: UITextField!
    @IBOutlet var loanTenure: UITextField!
    @IBOutlet var showMessage: UILabel!
    @IBOutlet var loanStartMonth: UITextField!
    @IBOutlet var loanEmi: UITextField!
    
    let loanMonth = UIDatePicker()
    
    @IBAction func createLoan(_ sender: Any) {
        if (loanName.text?.isEmpty)! {
            showMessage.text = "Please enter a loan name"
        } else if (loanAmount.text?.isEmpty)! {
            showMessage.text = "Please enter a loan amount"
        } else if (loanTenure.text?.isEmpty)! {
            showMessage.text = "Please enter a loan tenure"
        } else if (loanStartMonth.text?.isEmpty)! {
            showMessage.text = "Please select loan start date"
        } else if (loanEmi.text?.isEmpty)! {
            showMessage.text = "Please enter loan emi"
        } else {
            self.lName = loanName.text!
            self.lAmount = Int(loanAmount.text!)!
            self.lTenure = Int(loanTenure.text!)!
            self.lStartDate = loanStartMonth.text!
            self.lEmi = Int(loanEmi.text!)!
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = appDelegate.persistentContainer.viewContext
            
            let newLoan = NSEntityDescription.insertNewObject(forEntityName: "Loans", into: context)
            
            newLoan.setValue(1, forKey: "id")
            newLoan.setValue(self.lName, forKey: "name")
            newLoan.setValue(self.lAmount, forKey: "amount")
            newLoan.setValue(self.lTenure, forKey: "tenure")
            newLoan.setValue(self.lStartDate, forKey: "startDate")
            newLoan.setValue(self.lEndDate, forKey: "endDate")
            newLoan.setValue(self.lEmi, forKey: "emi")
            
            do {
                try context.save()
                
                showMessage.text = self.lName + " has been saved"
                
                // set notification
                
                let center = UNUserNotificationCenter.current()
                
                let content = UNMutableNotificationContent()
                content.title = "EMI for the loan " + self.lName + " is due in 7 days."
                content.body = "Please check your bank account to avoid charges"
                content.sound = UNNotificationSound.default()
                print(loanMonth.date)
                
                let notificationDate = Calendar.current.date(byAdding: .day, value: -7, to: loanMonth.date)

                let triggerTime = Calendar.current.dateComponents([.month, .day, .hour, .minute, .second], from: notificationDate!)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
                
                let identifier = "Notification_" + self.lName.replacingOccurrences(of: " ", with: "_")
                print(identifier)
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    if error != nil {
                        print(error!)
                    }
                }
                
                loanName.text = ""
                loanAmount.text = ""
                loanTenure.text = ""
                loanStartMonth.text = ""
                loanEmi.text = ""
            } catch {
                showMessage.text = "Sorry, something went wrong"
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePickerMonth()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createDatePickerMonth() {
        
        loanMonth.datePickerMode = .date
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //done
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(monthDonePressed))
        
        toolbar.setItems([doneButton], animated: true)
        
        loanStartMonth.inputAccessoryView = toolbar
        loanStartMonth.inputView = loanMonth
    }
    
    func monthDonePressed() {
        let formatDate = DateFormatter()
        formatDate.dateStyle = .medium
        formatDate.timeStyle = .none
        
        loanStartMonth.text = formatDate.string(from: loanMonth.date)
        
        let date = Calendar.current.date(byAdding: .month, value: Int(loanTenure.text!)! - 1, to: loanMonth.date)
        
        lEndDate = formatDate.string(from: date!)
        
        self.view.endEditing(true)
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
