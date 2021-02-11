//
//  TNMUrlsConstant.swift
//  StretfordEnd
//
//  Created by TNM3 on 7/15/16.
//  Copyright © 2016 shoebpersonal. All rights reserved.
//

import Foundation

//API Constant
let kAppName = "WGATE"
let kMessage = "message"
let kMessageText = "No results found"
let kSomethingWrongMessage = "Something went wrong please try again later."
let kSuccess = "success"

let kPostMethod = "POST"
let kGetMethod = "GET"

//Local Value For Key
let kCompanyID = "CompanyId"
let kEmployeeID = "EmployeeID"
let kCacheUserName = "CacheUserName"
let kLoginResult = "LoginResult"
let kAuthorisationToken = "AuthorisationToken"
let userDetail = "userDetail"





//Sandbox Url
//let kMainDomainUrl = "http://www.beutopian.com/mapp/index.php"
//let kCMainDomainUrl = "http://www.beutopian.com/capp/index.php"

let kMainDomainUrl = "http://sms.thewebtual.com/mapp/index.php"
let kCMainDomainUrl = "http://sms.thewebtual.com/mapp/index.php"

//LiveUrl
//let kMainDomainUrl = "https://aplantservices.aplant.com/AshteadServices"


let kDesapAuthDomainUrl = "http://aplant.desap.net/ApproveWS.asmx/GetToken"

let BaseUrl = "http://sms.thewebtual.com/webservice"

let kGetServices = "\(BaseUrl)/getServices"
let kGetTopServices = "\(BaseUrl)/getTopServices"
let kGetServicesCat = "\(BaseUrl)/getServicesCat"
let kGetServicesType = "\(BaseUrl)/servicesType"

let kGetSmartsocietySignup = "\(BaseUrl)/smartsociety_signup"
let kAddUserAddress = "\(BaseUrl)/addUserAddress"
let kGetUserAddressList = "\(BaseUrl)/userAddressList"
let kBookService = "\(BaseUrl)/bookService"



let kImageUrl = "http://sms.thewebtual.com/"
let kIconUrl = "http://sms.thewebtual.com/assests/subservices/"



//LoginDefault
//MARK: Set & Get Login Data
func setLoginUser(_ data : NSDictionary){
    let dataStore = NSKeyedArchiver.archivedData(withRootObject: data)
    UserDefaults.standard.set(dataStore, forKey: kLoginResult)
    UserDefaults.standard.synchronize()
    
}

func getLoginUser() -> NSDictionary
{
    var dict : NSDictionary = NSDictionary()
    if(UserDefaults.standard.object(forKey: kLoginResult) != nil ){
        let outData = UserDefaults.standard.data(forKey: kLoginResult)
        dict = (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary)!
        
    }
    
    return dict
}
func setUserDetails(_ data : NSDictionary){
    let dataStore = NSKeyedArchiver.archivedData(withRootObject: data)
    UserDefaults.standard.set(dataStore, forKey: userDetail)
    UserDefaults.standard.synchronize()
    
}

func getUserDetails() -> NSDictionary
{
    var dict : NSDictionary = NSDictionary()
    if(UserDefaults.standard.object(forKey: userDetail) != nil )
    {
        let outData = UserDefaults.standard.data(forKey: userDetail)
        dict = (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary)!
        
    }
    
    return dict
}

func RemoveLoginUser(){

    if(UserDefaults.standard.object(forKey: kLoginResult) != nil ){
        UserDefaults.standard.removeObject(forKey: kLoginResult)
        UserDefaults.standard.removeObject(forKey: userDetail)

        UserDefaults.standard.synchronize()
    }

}
func RemoveCacheObjectForKey(_ keyStr : String){
    UserDefaults.standard.removeObject(forKey: keyStr)
    UserDefaults.standard.synchronize()
}

func GetDateOrTime(_ dateString : String)-> (dateStr : String, timeStr : String){
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    var dateObj = dateFormatter.date(from: dateString)
    if dateObj == nil {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateObj = dateFormatter.date(from: dateString)
    }
    dateFormatter.dateFormat = "dd/MM/yyyy"
    var dateStr = ""
    if dateObj != nil {
        dateStr = dateFormatter.string(from: dateObj!)
    }
    //        print("Dateobj: \(dateStr))")
    
    dateFormatter.dateFormat = "HH:mm"
    var timeStr = ""
    if dateObj != nil {
        timeStr = dateFormatter.string(from: dateObj!)
    }
    //        print("Dateobj: \(timeStr))")
//    let newStr = String(format: "%@ Time: %@", arguments: [dateStr,timeStr])
    return (dateStr,timeStr)
}


func GetFormatedDateromString(_ dateString : String)-> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    var dateObj = dateFormatter.date(from: dateString)
    if dateObj == nil {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateObj = dateFormatter.date(from: dateString)
    }
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    var dateStr = ""
    if dateObj != nil {
        dateStr = dateFormatter.string(from: dateObj!)
    }
    //        print("Dateobj: \(dateStr))")
    
    dateFormatter.dateFormat = "HH:mm"
    var timeStr = ""
    if dateObj != nil {
        timeStr = dateFormatter.string(from: dateObj!)
    }
    //        print("Dateobj: \(timeStr))")
    let newStr = String(format: "%@ Time: %@", arguments: [dateStr,timeStr])
    return newStr
}

func GetFormatedDateNoMilliSecondfromString(_ dateString : String)-> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
    var dateObj = dateFormatter.date(from: dateString)
    if dateObj == nil {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateObj = dateFormatter.date(from: dateString)
    }
    
    dateFormatter.dateFormat = "dd/MM/yyyy"
    var dateStr = ""
    if dateObj != nil {
        dateStr = dateFormatter.string(from: dateObj!)
    }
    //        print("Dateobj: \(dateStr))")
    
    dateFormatter.dateFormat = "HH:mm"
    var timeStr = ""
    if dateObj != nil {
        timeStr = dateFormatter.string(from: dateObj!)
    }
    //        print("Dateobj: \(timeStr))")
    let newStr = String(format: "%@ Time: %@", arguments: [dateStr,timeStr])
    return newStr
}

func GetNewDicationary(_ data : NSDictionary) -> NSDictionary{
    let tempData = NSMutableDictionary()
    for object in data.allKeys {
        if let keyStr = object as? String {

            if let _ = data.object(forKey: keyStr) as? NSNull {
                tempData.setObject("", forKey: keyStr as NSCopying)
            }else{
                tempData.setObject(data.object(forKey: keyStr)!, forKey: keyStr as NSCopying)
            }
            
        }
        
    }
    return tempData
}


func GetTodayDate(_ isTommorow : Bool)-> String{
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
    let calendar = Calendar.current
    
    let todayDate = Date()
    
    var components = (calendar as NSCalendar).components([.day , .month, .year ], from: todayDate)
    components.hour = 0
    components.minute = 0
    components.second = 0
    if isTommorow == true {
        components.day = components.day! + 1
    }
    let newDate = calendar.date(from: components)
    dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    var dateStr = dateFormatter.string(from: newDate!)
    
    if dateStr.isEmpty == true {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateStr = dateFormatter.string(from: newDate!)
    }
    //print("newDate: \(dateStr)")
    if isTommorow == true {
        print("Today: \(dateStr)")
    }else{
        print("Tommorow: \(dateStr)")
    }
    
    return dateStr
   
}
func serializeParams(_ params : NSDictionary?) -> NSString {
    if (params == nil) {
        return ""
    }
    let pairs: NSMutableArray = NSMutableArray()
    params?.enumerateKeysAndObjects({ (key, value, stop) in
        let escaped_value = (value as! String).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) as String?
        pairs.add(NSString(string: "\(key)=\(escaped_value)" ))
    })
   
    return pairs.componentsJoined(by: "&") as NSString
}
