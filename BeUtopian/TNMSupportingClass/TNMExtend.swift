//
//  TNMExtend.swift
//  BeUtopian
//
//  Created by Jeevan on 21/11/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import Foundation

extension String {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            print("error:", error)
//            return nil
//        }
//    }
//    var html2String: String {
//        return html2AttributedString?.string ?? ""
//    }
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension String {
    /*
    var html2AttributedString: NSAttributedString? {
        guard
            let data = data(using: String.Encoding.utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute:String.Encoding.utf8], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    */
    var EncodeHtmlString : String {
        let data = self.data(using: String.Encoding.utf8)
        let base64String = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    var DecodeHtmlString : String {
        let decodedData = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let decodedString = String(data: decodedData!, encoding: String.Encoding.utf8)
        return decodedString!
    }
}

extension String {
    
    var base64Encoded : String {
        let plainData = data(using: String.Encoding.utf8)
        if plainData != nil {
            let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            return base64String!
        }
        return ""
    }
    
    var base64Decoded : String {
        let decodedData = Data(base64Encoded: self, options:NSData.Base64DecodingOptions(rawValue: 0))
        if decodedData != nil {
            let decodedString = NSString(data: decodedData!, encoding: String.Encoding.utf8.rawValue)
            if let tempStr = decodedString as? String {
                return tempStr
            }
        }
        
        return ""
    }
}
