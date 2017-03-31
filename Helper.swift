//
//  Helper.swift
//  LMS
//
//  Created by Ramesh Kolamala on 27/03/17.
//  Copyright © 2017 tokkalo.com. All rights reserved.
//

import Foundation
import UIKit

class Helper{

    
    static func customizetextField(_ textField: UITextField!) {
        textField.backgroundColor = UIColor.clear
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        
        textField.leftView = paddingView
        
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    static func customizetextField2(_ textField: UITextField!) {
        textField.backgroundColor = UIColor.clear
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        
        textField.leftView = paddingView
        
        textField.leftViewMode = UITextFieldViewMode.always
    }
    
    static func customizetextField3(_ textField: UITextField!) {
        textField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        textField.layer.cornerRadius = 3
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.white.cgColor
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        
        textField.leftView = paddingView
        
        textField.leftViewMode = UITextFieldViewMode.always
        
        textField.tintColor = UIColor.white
    }
    
    static func customButton(_ button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    static func customButton2(_ button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitleColor(UIColor.yellow, for: UIControlState.normal)
    }
    
    static func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func loadImageFromUrl(_ url: String, view: UIImageView){
        
        // Create Url from string
        let url = URL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                DispatchQueue.main.async(execute: { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        })
        
        // Run task
        task.resume()
    }
}
