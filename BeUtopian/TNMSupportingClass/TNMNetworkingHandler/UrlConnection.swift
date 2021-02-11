//
//  UrlConnection.swift
//  Annecto UK
//
//  Created by TNM_ios2 on 10/04/15.
//  Copyright (c) 2015 TechNet Media. All rights reserved.
//

import Foundation
let TIMEOUT_INTERVAL = 90
let CONTENT_TYPE = "Content-Type"
let URL_ENCODED = "application/x-www-form-urlencoded"
let POST = "POST"


typealias connectionBlock = (_ obj : NSDictionary?, _ connection : UrlConnection) -> Void

class UrlConnection :NSObject ,NSURLConnectionDelegate,NSURLConnectionDataDelegate{
    
    var jsondata : NSMutableData?
    var connection : NSURLConnection?
    var errorBlock : connectionBlock?
    var completeBlock : connectionBlock?
    
    
    let isWait : Bool = false
    
//    
//    func hideNetworkIndicator(){
//        if(UIApplication.sharedApplication().isIgnoringInteractionEvents()){
//            UIApplication.sharedApplication().endIgnoringInteractionEvents()
//        }
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//        //        defaultIndicator.stopAnimation(isWait)
//        dispatch_async(dispatch_get_main_queue()) {
//            // update some UI
//            appDelegate.HideProgress()
//        }
//        
//        
//        
//    }
//    func ShowIndicator(){
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
//        
//        
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//        //        var  wind : UIWindow?
//        //        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        //        if (delegate.respondsToSelector("window")) {
//        //            wind = delegate.window
//        //        }
//        //        else {
//        //            wind = UIApplication.sharedApplication().keyWindow
//        //        }
//        //        let frame = wind?.bounds
//        //        defaultIndicator = SpringIndicator(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
//        //        defaultIndicator.center = CGPointMake(frame!.size.width  / 2,
//        //            frame!.size.height / 2);
//        //
//        //        defaultIndicator.lineColor = UIColor(red: 19/255, green: 126/255, blue: 192/255, alpha: 1)
//        //        defaultIndicator.strokeDuration = 1
//        //        defaultIndicator.lineWidth = 7
//        //        wind!.addSubview(defaultIndicator)
//        //        defaultIndicator.startAnimation()
//        
//        //        let navigationController = UIApplication.sharedApplication().windows[0].rootViewController as? UINavigationController
//        appDelegate.ShowProgress(UIViewController())
//    }
//    
    init(url: NSString,param : NSDictionary?){
        super.init()
        
        //        TNMProgressHUD.show(status: "Loading...")
        appDelegate.ShowProgress(UIViewController())
        let postData = serializeParams(param)
        print(postData)
        let request : NSMutableURLRequest = getNSMutableURLRequestUsingPOSTMethodWithUrl(url, postdata: postData)
        connection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        jsondata = NSMutableData()
        
        
    }
    
    init(url: NSString, user : NSString,pass : NSString){
        super.init()
        
        
//        TNMProgressHUD.show(status: "Loading...")
        appDelegate.ShowProgress(UIViewController())
        let request : NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url as String)!)
        request.httpMethod = "GET"
        let authenticationString = "\(user):\(pass)" as NSString
        let authenticationData = authenticationString.data(using: String.Encoding.utf8.rawValue) as Data?
        let authenticationValue = authenticationData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
        let auth = "Basic \(authenticationValue)"
       
        request.setValue(auth, forHTTPHeaderField: "Authorization")
        
        connection = NSURLConnection(request: request as URLRequest, delegate: self, startImmediately: true)!
        jsondata = NSMutableData()
        
        
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
//        defaultIndicator.stopAnimation(isWait)
        appDelegate.HideProgress()
//        TNMProgressHUD.dismiss()
        if(isRechable() == true)
        {
//            errorBlock?(obj: error, connection: self)
        }else{
            self.showRetry()
        }
    }
    func jsonSerial(){
        do {
            let json = try JSONSerialization.jsonObject(with: jsondata! as Data, options: []) as! [String: AnyObject]
            print(json)
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        if((jsondata) != nil)
        {
//            jsonSerial()
//            NSLog("\(NSString(data: jsondata!, encoding: NSUTF8StringEncoding))")
            let json: AnyObject? = try? JSONSerialization.jsonObject(with: jsondata! as Data, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
//            print(json)
            
            
            if(json != nil && json!.isKind(of: NSDictionary.classForCoder())  && json?.object(forKey: "Status") as? String  == "0")
            {
                errorBlock?(json as? NSDictionary, self)
                
            }
            else if(json != nil)
            {
                completeBlock?(json! as? NSDictionary, self)
            }
            else
            {
                let dt : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: "Message" as NSCopying)
                errorBlock?(dt, self)
            }
        }
        else
        {
            let dt : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: "Message" as NSCopying)
            errorBlock?(dt, self)
        }
        appDelegate.HideProgress()
//        defaultIndicator.stopAnimation(isWait)
//        TNMProgressHUD.dismiss()
    }
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        jsondata?.append(data)
    }
//    func connection(connection: NSURLConnection, didReceiveAuthenticationChallenge challenge: NSURLAuthenticationChallenge) {
//        if (username != nil && password != nil) {
//            if (challenge.previousFailureCount == 0) {
//                NSLog("received authentication challenge")
//                let newCredential = NSURLCredential(user: username!, password: password!, persistence: NSURLCredentialPersistence.None)
//                NSLog("credential created")
//                challenge.sender.useCredential(newCredential, forAuthenticationChallenge: challenge)
//                NSLog("responded to authentication challenge")
//            }
//            else {
//                NSLog("previous authentication failure")
//            }
//        }
//    }
    func serializeParams(_ params : NSDictionary?) -> NSString {
        if (params == nil) {
            return ""
        }
        let pairs: NSMutableArray = NSMutableArray()
        params?.enumerateKeysAndObjects({ (key, value, stop) in
            let escaped_value = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as String?
            pairs.add(NSString(string: "\(key)=\(String(describing: escaped_value))" ))
        })
        
        return pairs.componentsJoined(by: "&") as NSString
    }
    
    
    func getNSMutableURLRequestUsingPOSTMethodWithUrl (_ url : NSString, postdata : NSString) -> NSMutableURLRequest {
        
//        _ = "\(url)?\(postdata)"
        let  req = NSMutableURLRequest(url: URL(string: url as String)!) as NSMutableURLRequest
        
        req.httpMethod = POST
        req.addValue(URL_ENCODED, forHTTPHeaderField: CONTENT_TYPE)
        req.httpBody = postdata.data(using: String.Encoding.utf8.rawValue)
        return req
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
    @objc func showRetry(){
        let refreshAlert = UIAlertController(title: "Oops...", message: "The Internet seems to be unavailable. Please check your connection and try again.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
            let dt : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: "Message" as NSCopying)
            self.errorBlock?(dt, self)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action: UIAlertAction!) in
            
            if(self.isRechable() == true){
//                TNMProgressHUD.show(status: "Loading...")
                appDelegate.ShowProgress(UIViewController())
                self.connection?.start()
            }else{
                self.perform(#selector(UrlConnection.showRetry), with: nil, afterDelay: 0.1)
            }
            
            
        }))
        
        appDelegate.window?.rootViewController!.present(refreshAlert, animated: true, completion: nil)
    }
    
    //MARK: - Rest API Call - 
    
    init(url: NSString,param : NSDictionary?, isGet : Bool)
    {
        super.init()
        /*
        appDelegate.ShowProgress(UIViewController())
        
//        TNMProgressHUD.show(status: "Please wait...")
        let postData = serializeParams(param)
        do {
            
            let strUrl  = String(format: "%@?%@",url,postData)
            var opt : HTTP!
            if isGet ==  true {
                opt = try HTTP.GET(strUrl)
            }else{
                opt = try HTTP.POST(strUrl)
                
            }
//            let opt = try HTTP.GET(strUrl)

            opt.start { response in
                if response.statusCode == 500
                {
//                    errorBlock?(obj: json, connection: self)
                   
//                    dispatch_async(dispatch_get_main_queue(), {
//                        TNMProgressHUD.dismiss()
//                        appDelegate.showAlertMessage("There was a problem, please try again")
//                    })
//                    return
                    
                    let errorData : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
                    self.errorBlock?(errorData, self)
                    appDelegate.HideProgress()
                }
                else
                {
                    let json: AnyObject? = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                    if(json != nil)
                    {
                        if let data = json as? NSDictionary {
                            self.completeBlock?(data, self)
                            //RemoveLog Runtime
                            print("Request URL : \(url) \nRequest Result : \(data)")
                           
                        }else{
                            let errorData : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
                            self.errorBlock?(errorData, self)
                            
                        }
                        
                    }else{
                        let errorData : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
                        self.errorBlock?(errorData, self)
                    }
                    appDelegate.HideProgress()
                    
                    print("Status Code: \(response.statusCode) \nError Message: \(response.error)")
                }
                
            }
        } catch let error {
//            TNMProgressHUD.dismiss()
//             completeBlock?(obj: json!, connection: self)
            print("got an error creating the request: \(error)")
//            let errorStr = String(format: "%@", arguments: [error])
            let errorData : NSDictionary = NSDictionary(object: "Something went wrong please try again later.", forKey: kMessage as NSCopying)
            self.errorBlock?(errorData, self)
            appDelegate.HideProgress()
        }
 */
    }

}
