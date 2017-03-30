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
import UICircularProgressRing

class ViewLoanInfoController: UIViewController, UICircularProgressRingDelegate {
    
    var loanName: String?
    
    @IBOutlet var loanNameLabel: UILabel!
    @IBOutlet var loanAmount: UILabel!
    @IBOutlet var loanTenure: UILabel!
    @IBOutlet var loanStartDate: UILabel!
    @IBOutlet var loanEndDate: UILabel!
    @IBOutlet var loanEmi: UILabel!
    
    var loanCompletion = 0
    var totalMonths = 0
    
    @IBOutlet weak var ring2: UICircularProgressRingView!

    
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
                    
                    if let loanTenure1 = result.value(forKey: "tenure") as? Int {
                        self.loanTenure.text = String("\(loanTenure1)")
                        self.totalMonths = loanTenure1
                    }
                    
                    if let loanStartDate = result.value(forKey: "startDate") as? String {
                        self.loanStartDate.text = "\(loanStartDate)"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm"
                        //dateFormatter.dateFormat = "MMM dd, yyyy hh:mm"
                        let date2 = dateFormatter.date(from: "\(loanStartDate) 00:00")
                        let date = Date()
                        let months = date.months(from: (date2)!)
                        
                        let m: Float = Float(months + 1)
                        let tm: Float = Float(self.totalMonths)
                        var k: Float = 0.0
                        k = Float (m/tm)
                        var s: Float = 0
                        if(m <= tm){
                            s = k * 100
                        }else{
                            s = 100
                        }
                        

                        self.loanCompletion = Int (s)
                        
                    }
                    print(self.loanCompletion)
                    if let loanEndDate = result.value(forKey: "endDate") as? String {
                        self.loanEndDate.text = "\(loanEndDate)"
                        //self.loanCompletion = 60
                        
                        
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
        
        //ring2.fontColor = UIColor.white
        
        ring2.setProgress(value: 0, animationDuration: 2) { [unowned self] in
            // Increase it more, and customize some properties
            self.ring2.viewStyle = 4
            self.ring2.setProgress(value: CGFloat(self.loanCompletion), animationDuration: 3) {
                //self.ring2.font = UIFont.systemFont(ofSize: 50)
            }
        }
        
        // Set the delegate
        ring2.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The delegate method!
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
        if ring === ring2 {
            //print("From delegate: Ring 2 finished")
        }
    }
    
    func getDate(_ dateString: String) -> Date {
        let date = Date()
        
        return date
    }
    
   // func getCompletion(_ totalMonths: Int, _ endDate: Date) -> Int {
        
        
        
    //}

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: Date()).month ?? 0
    }
    /// Returns the amount of months from two dates
    func months2(from dateFrom: Date, to dateTo: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: dateFrom, to: dateTo).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}


