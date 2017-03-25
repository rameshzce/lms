//
//  File.swift
//  LMS
//
//  Created by Ramesh Kolamala on 25/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class NotificationManager: NSObject {
    
    
    //Shared instance
    static let shared:NotificationManager = {
        
        return NotificationManager()
        
    }()
    
    
    
    //Let's keep tracking the status of the authorization
    var isAuthorized = false
    
    
    //1- We need to authorize the app before we do anything. When you ask for authorization an alert will show to user to either approve or not
    
    //With this function we can ask for the authorization from anywhere in our app
    //But in our case we will be calling this method once our app get launched
    
    func requestAuthorization(){
        
        //Here we prepare our notification option so the system know that we will having those types of notifications
        let options:UNAuthorizationOptions = [.badge,.alert,.sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted:Bool, error:Error?) in
            
            if granted{
                
                print("Notification Authorized")
                self.isAuthorized = true
                
            }else{
                
                self.isAuthorized = false
                print("Notification Not Authorized")
            }
            
        }
        
        
        //Now we need to become the delegate for the NotificationCenter so we can get calls as we explained in the intro
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    
    
    //Now let's implement our schdule function
    
    
    func schdule(date:Date,repeats:Bool)->Date?{
        
        
        //Since we only have one notification in our App that will be schduled so it's good if we cancel all first before we set new one
        cancelAllNotifcations()
        
        
        //1- Create Content
        let content = UNMutableNotificationContent()
        content.title = "SwiftyLab"
        content.body = "Local Notification with Swift 3 and iOS 10"
        content.userInfo = ["testInfo":"hello"] // Here you can attache extra info with content
        
        
        //We will also attache an image to our notification as we saw in the intro
        
        guard let filePath = Bundle.main.path(forResource: "banner", ofType: "png") else{
            
            print("Image not found")
            return nil
        }
        
        let attachement = try! UNNotificationAttachment(identifier: "attachement", url: URL.init(fileURLWithPath: filePath), options: nil)
        
        content.attachments = [attachement]
        
        //2- Create Trigger
        
        //In order to init the trigger we need a dateComponent
        
        let components = Calendar.current.dateComponents([.minute,.hour], from: date)
        
        
        var newComponent = DateComponents()
        newComponent.hour = components.hour
        newComponent.minute = components.minute
        newComponent.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponent, repeats: repeats)
        
        
        
        //3- Create the request so we can add it to the NotificationCenter
        
        let request = UNNotificationRequest(identifier: "TestNotificationId", content: content, trigger: trigger)
        
        
        
        
        //4- Add the request
        
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error == nil{
                
                //Let's format our date so it matches our device time
                print("Notification Schduled",trigger.nextTriggerDate()?.formattedDate ?? "Date nil")
                
            }else{
                
                print("Error schduling a notification",error?.localizedDescription ?? "")
            }
        }
        
        return trigger.nextTriggerDate()
    }
    
    
    
    //Now let's implement our get pending notifcation function
    
    func getAllPendingNotifications(completion:@escaping ([UNNotificationRequest]?)->Void){
        
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests:[UNNotificationRequest]) in
            return completion(requests)
        }
        
        
    }
    
    
    
    
    //We need to cancel the notifcation also sometime
    
    func cancelAllNotifcations(){
        
        getAllPendingNotifications { (requests:[UNNotificationRequest]?) in
            
            if let requestsIds = requests{
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestsIds.map{$0.identifier})
            }
            
        }
        
    }
    
}


//Now let's impelement the delegate methods

extension NotificationManager:UNUserNotificationCenterDelegate{
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Local Notifcation Received while app is open",notification.request.content)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Did tap on the notification",response.notification.request.content)
        
        
        //Also we should call the completionHandler as soon as we're done from this call
        completionHandler()
    }
    
    
    
}






extension Date{
    
    
    var formattedDate:String{
        
        
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.timeStyle = .medium
        format.dateStyle = .medium
        
        
        return format.string(from: self)
        
    }
    
    
}



