//
//  URLRequest.swift
//  SwiftDemo
//
//  Created by rajesh jain on 10/26/17.
//  Copyright © 2017 Jay And Jov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

typealias MaincompletionType = (_ Dict:NSDictionary) -> Void

extension UIViewController
{
    func JsonAdsPostImageRequest(APINAME:String,ParamDict:NSDictionary,ImageData:NSMutableArray,key:String,view:UIViewController,completion: @escaping MaincompletionType)
    {
        
        
        if isRechable() == false
           {
               
//               let dt : NSDictionary = NSDictionary(object: "The Internet seems to be unavailable. Please check your connection and try again.", forKey: kMessage as NSCopying)
//               postCompleted(false, dt)

            let responseObject:NSDictionary = ["status":"1","message":"The Internet seems to be unavailable. Please check your connection and try again."]
                   appDelegate.HideProgress()
               
               
            completion(responseObject)

           }
        //appDelegate.PulseShowProgress()
        appDelegate.ShowProgress(view)

        let WEBURL:String = APINAME
        let ParametersDict = ParamDict ;
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
//        if AuthToken.isEmpty == false {
//            request.addValue(AuthToken, forHTTPHeaderField: "Authorisation-Token")
//        }
        let headers =
            [
                "Content-Type": "application/json; charset=utf-8"
                ,"Authorization" : appDelegate.AuthToken
        ]
        print(WEBURL)
        print(ParametersDict)
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                
                if ImageData.count > 0
                {
                    for i in 0..<ImageData.count
                    {
                        let data = ImageData[i] as? Data ?? Data()
                        multipartFormData.append(data, withName:key, fileName:"user.jpeg", mimeType:"image/jpeg")
                    }
                }
                
                for (key, val) in ParamDict
                {
                    
                    if let value =  val as? Int
                    {
                        multipartFormData.append(("\(value)").data(using: String.Encoding.utf8)!, withName: key as! String)
                        
                    }
                    else
                    {
                        multipartFormData.append((val as! String).data(using: String.Encoding.utf8)!, withName: key as! String)
                    }
                }
                
        },
            to:WEBURL ,headers:headers ,
            encodingCompletion: { encodingResult in
                switch encodingResult
                {
                case .success(let upload, _, _):
                    upload.responseJSON
                        {
                            response in
                            
                            print(response)
                            appDelegate.HideProgress()
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                            do
                            {
                               // let Dict = response.result.value as? NSDictionary ?? [:]
                                if let data = response.data
                                {
                                    print(response.response?.statusCode ?? "0")
                                    
                                        appDelegate.HideProgress()
                                    let responseObject:NSDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary ;
                                        completion(responseObject);
                                  
                                }
                            }
                            catch _ as NSError
                            {
                               let str =  response.error?.localizedDescription ?? ""
                               let responseObject:NSDictionary = ["status":"1","message":str]
                                appDelegate.HideProgress()
                                                                  
                                completion(responseObject)
                               
                            }
                    }
                case .failure(let encodingError):
                    appDelegate.HideProgress()

                    print(encodingError)
                    let responseObject:NSDictionary = ["status":"1","message":encodingError.localizedDescription]
                    appDelegate.HideProgress()
                                                      
                    completion(responseObject)
                }
        }
        )
    }
    
    
    
  
    
    
}



