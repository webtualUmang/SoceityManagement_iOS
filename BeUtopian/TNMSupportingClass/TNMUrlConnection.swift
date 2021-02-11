//
//  TNMUrlConnection.swift
//  APlantApprove
//
//  Created by TNM3 on 10/4/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import Foundation

func TNMPost(_ params : Dictionary<String, String>, url : String, postCompleted : @escaping (_ succeeded: Bool, _ msg: String) -> ()) {
    //appDelegate.ShowProgress()
    
    var request = URLRequest(url: URL(string: url)!)
    let session = URLSession.shared
    request.httpMethod = "POST"
    
    request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
        //appDelegate.HideProgress()
        print("Response: \(String(describing: response))")
        let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        print("Body: \(String(describing: strData))")
        
        let json: AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject?
        
        // check and make sure that json has a value using optional binding.
        if let parseJSON = json {
            // Okay, the parsedJSON is here, let's get the value for 'success' out of it
            if let success = parseJSON["success"] as? Bool {
                print("Succes: \(success)")
                postCompleted(success, "Logged in.")
            }
            
        }
        else {
            // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
            let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("Error could not parse JSON: \(String(describing: jsonStr))")
            postCompleted(false, "Error")
        }
        
        
    })
    
    task.resume()
}

func TNMWSMethod(_ params : AnyObject?, url : String,isMethod : String, AuthToken : String,viewController : UIViewController, postCompleted : @escaping (_ succeeded: Bool, _ data: AnyObject) -> ()) {
    
   
        appDelegate.ShowProgress(viewController)

    
    if isRechable() == false
    {
        
        let dt : NSDictionary = NSDictionary(object: "The Internet seems to be unavailable. Please check your connection and try again.", forKey: kMessage as NSCopying)
        postCompleted(false, dt)

      
            appDelegate.HideProgress()
        
        
        return
    }
    
    //appDelegate.ShowProgress()
    var request = URLRequest(url: URL(string: url)!)
    let session = URLSession.shared
    request.httpMethod = isMethod
    if params != nil {
        request.httpBody = try! JSONSerialization.data(withJSONObject: params!, options: [])
    }
    
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    
    if AuthToken.isEmpty == false {
        request.addValue(AuthToken, forHTTPHeaderField: "Authorisation-Token")
    }
    
    let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
        //appDelegate.HideProgress()
//        print("Response: \(response)")
//        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        print("Body: \(strData)")

        var statusCode : Int = 0
        if let status = response as? HTTPURLResponse {
            print("status code \(status.statusCode)")
            statusCode = status.statusCode
        }
        
        DispatchQueue.main.async {
            appDelegate.HideProgress()
        }
        
        if data == nil {
            print("%@",error.debugDescription)
            let dt : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
            postCompleted(false, dt)
        }else{
            
            do {
                
                if statusCode == 200 {
                    
                    let json: AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject?
                    
                    
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json
                    {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        
                        if statusCode == 200 {
                            postCompleted(true, parseJSON)
                        }else{
                            postCompleted(false, parseJSON)
                        }
                        
                        
                    }else if statusCode == 200 {
                        let dt : NSDictionary = NSDictionary(object: kMessageText, forKey: kMessage as NSCopying)
                        postCompleted(true, dt)
                    }
                    else {
                        
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: \(String(describing: jsonStr))")
                        let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
                        postCompleted(false, dt)
                        
                    }
                }
                else {
                    
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: \(jsonStr ?? "<#default value#>")")
                    let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
                    postCompleted(false, dt)
                    
                }
                
                
                
                
            } catch {
                print(error.localizedDescription)
            }
            
           /* let json: AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject?
            
            
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it

                if statusCode == 200 {
                    postCompleted(true, parseJSON)
                }else{
                    postCompleted(false, parseJSON)
                }
                
                
            }else if statusCode == 200 {
                let dt : NSDictionary = NSDictionary(object: kMessageText, forKey: kMessage as NSCopying)
                postCompleted(true, dt)
            }
            else {
                
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: \(jsonStr)")
                let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
                postCompleted(false, dt)
                
            }*/
        }
        
    })
    
    task.resume()
}

func TNMWSMethodNoLoading(_ params : AnyObject?, url : String,isMethod : String, AuthToken : String, postCompleted : @escaping (_ succeeded: Bool, _ data: AnyObject) -> ()) {
    
    if isRechable() == false {
        
        let dt : NSDictionary = NSDictionary(object: "The Internet seems to be unavailable. Please check your connection and try again.", forKey: kMessage as NSCopying)
        postCompleted(false, dt)
        
        return
    }
    
    //appDelegate.ShowProgress()
    var request = URLRequest(url: URL(string: url)!)
    let session = URLSession.shared
    request.httpMethod = isMethod
    if params != nil {
        request.httpBody = try! JSONSerialization.data(withJSONObject: params!, options: [])
    }
    
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    
    if AuthToken.isEmpty == false {
        request.addValue(AuthToken, forHTTPHeaderField: "Authorisation-Token")
    }
    
    let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
        
        
        var statusCode : Int = 0
        if let status = response as? HTTPURLResponse {
            print("status code \(status.statusCode)")
            statusCode = status.statusCode
        }
        
        
        if data == nil {
            print("%@",error.debugDescription)
            let dt : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
            postCompleted(false, dt)
        }else{
            let json: AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject?
            
            
            // check and make sure that json has a value using optional binding.
            if let parseJSON = json {
                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                
                if statusCode == 200 {
                    postCompleted(true, parseJSON)
                }else{
                    postCompleted(false, parseJSON)
                }
                
                
            }else if statusCode == 200 {
                let dt : NSDictionary = NSDictionary(object: kMessageText, forKey: kMessage as NSCopying)
                postCompleted(true, dt)
            }
            else {
                
                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("Error could not parse JSON: \(String(describing: jsonStr))")
                let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
                postCompleted(false, dt)
                
            }
        }
        
    })
    
    task.resume()
}

func TNMWSMultiFormMethod(_ params : AnyObject?, url : String,isMethod : String, AuthToken : String,viewController : UIViewController, postCompleted : @escaping (_ succeeded: Bool, _ data: AnyObject) -> ()) {
    
    DispatchQueue.main.async {
        appDelegate.ShowProgress(viewController)
    }
    
    
    if isRechable() == false {
        
        let dt : NSDictionary = NSDictionary(object: "The Internet seems to be unavailable. Please check your connection and try again.", forKey: kMessage as NSCopying)
        postCompleted(false, dt)
        
        DispatchQueue.main.async {
            appDelegate.HideProgress()
        }
        
        return
    }
    
    let session = URLSession.shared
    
    let requestUrl = URL(string: url)
    let request = SimpleHTTPRequest.multipartRequest(with: requestUrl, andMethod: isMethod, andDataDictionary: params as! [AnyHashable: Any])

    
//    let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in

    
    let task = session.dataTask(with: (request as URLRequest?)!) { (data, response, error) in
        //appDelegate.HideProgress()
        //        print("Response: \(response)")
        //        let strData = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //        print("Body: \(strData)")
        
        var statusCode : Int = 0
        if let status = response as? HTTPURLResponse {
            print("status code \(status.statusCode)")
            statusCode = status.statusCode
            
        }
        print(error.debugDescription)
        DispatchQueue.main.async {
            appDelegate.HideProgress()
        }
        
        if data == nil
        {
            let dt : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
            postCompleted(false, dt)
        }else
        {
            do {
                
                if statusCode == 200
                {
                    
                    let json: AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject?
                    
                    
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json {
                        // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                        
                        if statusCode == 200 {
                            postCompleted(true, parseJSON)
                        }else{
                            postCompleted(false, parseJSON)
                        }
                        
                        
                    }else if statusCode == 200 {
                        let dt : NSDictionary = NSDictionary(object: kMessageText, forKey: kMessage as NSCopying)
                        postCompleted(true, dt)
                    }
                    else {
                        
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("Error could not parse JSON: \(String(describing: jsonStr))")
                        let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
                        postCompleted(false, dt)
                        
                    }
                }
                else
                {
                    
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("Error could not parse JSON: \(String(describing: jsonStr))")
                    let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
                    postCompleted(false, dt)
                    
                }
                
                
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            /* let json: AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject?
             
             
             // check and make sure that json has a value using optional binding.
             if let parseJSON = json {
             // Okay, the parsedJSON is here, let's get the value for 'success' out of it
             
             if statusCode == 200 {
             postCompleted(true, parseJSON)
             }else{
             postCompleted(false, parseJSON)
             }
             
             
             }else if statusCode == 200 {
             let dt : NSDictionary = NSDictionary(object: kMessageText, forKey: kMessage as NSCopying)
             postCompleted(true, dt)
             }
             else {
             
             // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
             let jsonStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
             print("Error could not parse JSON: \(jsonStr)")
             let dt : NSDictionary = NSDictionary(object: jsonStr!, forKey: kMessage as NSCopying)
             postCompleted(false, dt)
             
             }*/
        }
        
    }
    
    task.resume()
}


func isRechable() -> Bool{
    var isConnected : Bool = false
    let status = Reachability().connectionStatus()
    switch status {
    case .unknown, .offline:
        print("Not connected")
        isConnected = false
    case .online(.wwan):
        print("Connected via WWAN")
        isConnected = true
    case .online(.wiFi):
        print("Connected via WiFi")
        isConnected = true
    }
    return isConnected
}
