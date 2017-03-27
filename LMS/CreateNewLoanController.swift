//
//  CreateNewLoanController.swift
//  Loan Management
//
//  Created by Ramesh Kolamala on 18/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class CreateNewLoanController: UIViewController, UITextFieldDelegate {
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
    @IBOutlet var createLoanBtn: UIButton!
    
    let loanMonth = UIDatePicker()
    
    let amountToolbar: UIToolbar = UIToolbar()
    let tenureToolbar: UIToolbar = UIToolbar()
    let emiToolbar: UIToolbar = UIToolbar()
    
    @IBAction func createLoan(_ sender: Any) {
        if (loanName.text?.isEmpty)! {
            showAlert("Please enter a loan name")
        } else if (loanAmount.text?.isEmpty)! {
            showAlert("Please enter a loan amount")
        } else if (loanTenure.text?.isEmpty)! {
            showAlert("Please enter a loan tenure")
        } else if (loanEmi.text?.isEmpty)! {
            showAlert("Please enter loan emi")
        } else if (loanStartMonth.text?.isEmpty)! {
            showAlert("Please select loan start date")
        } else {
            self.lName = loanName.text!
            self.lAmount = Int(loanAmount.text!)!
            self.lTenure = Int(loanTenure.text!)!
            self.lStartDate = loanStartMonth.text!
            self.lEmi = Int(loanEmi.text!)!
            
            let date = Calendar.current.date(byAdding: .month, value: Int(self.lTenure) - 1, to: loanMonth.date)
            let formatDate = DateFormatter()
            formatDate.dateStyle = .medium
            formatDate.timeStyle = .none
            
            lEndDate = formatDate.string(from: date!)
            print(lEndDate)
            
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
                
                //showMessage.text = self.lName + " has been saved"
                
                showAlert("Loan \'" + self.lName + "\' has been created")
                
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
        
        self.loanName.delegate = self
        self.loanAmount.delegate = self
        self.loanTenure.delegate = self
        self.loanEmi.delegate = self
        self.loanStartMonth.delegate = self
        
        self.createLoanBtn.layer.cornerRadius = 15
        self.createLoanBtn.clipsToBounds = true
        
        self.createLoanBtn.layer.borderWidth = 2
        self.createLoanBtn.layer.borderColor = UIColor.white.cgColor
        
        amountToolbar.barStyle = UIBarStyle.blackTranslucent
        amountToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancel)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.done))
        ]
        
        amountToolbar.sizeToFit()
        
        loanAmount.inputAccessoryView = amountToolbar
        
        tenureToolbar.barStyle = UIBarStyle.blackTranslucent
        tenureToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancel2)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.done2))
        ]
        
        tenureToolbar.sizeToFit()
        
        loanTenure.inputAccessoryView = tenureToolbar
        
        emiToolbar.barStyle = UIBarStyle.blackTranslucent
        emiToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancel3)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.done3))
        ]
        
        emiToolbar.sizeToFit()
        
        loanEmi.inputAccessoryView = emiToolbar
        //loanTenure.inputAccessoryView = numberToolbar
        //loanEmi.inputAccessoryView = numberToolbar
        
        createDatePickerMonth()
        
        // Do any additional setup after loading the view.
    }
    
    func done (_ textField: UITextField!) {
        loanAmount.resignFirstResponder()
    }
    
    func cancel (_ textField: UITextField!) {
        loanAmount.text=""
        loanAmount.resignFirstResponder()
    }
    
    func done2 (_ textField: UITextField!) {
        loanTenure.resignFirstResponder()
    }
    
    func cancel2 (_ textField: UITextField!) {
        loanTenure.text=""
        loanTenure.resignFirstResponder()
    }
    
    func done3 (_ textField: UITextField!) {
        loanEmi.resignFirstResponder()
    }
    
    func cancel3 (_ textField: UITextField!) {
        loanEmi.text=""
        loanEmi.resignFirstResponder()
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
        
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func  textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loanName.resignFirstResponder()
        loanAmount.resignFirstResponder()
        return true
    }
    
    func showAlert(_ msg: String){
        let alertController = UIAlertController(title: "LMS",
                                                message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style:
            UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion:
            nil)
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
