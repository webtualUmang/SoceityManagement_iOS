//
//  BlogViewController.swift
//  BeUtopian
//
//  Created by TNM3 on 11/18/16.
//  Copyright © 2016 tnmmac4. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController,UIWebViewDelegate
{

    var navigationTitle : String = ""
    var websiteUrl : String = ""
    @IBOutlet var webview : UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  appDelegate.ShowProgress(self)

        self.SetNavigationButton()
        
      //  self.perform("OpenWebSite", with: nil, afterDelay: 0.5)
        self.OpenWebSite()
    }
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    func OpenWebSite(){
        if navigationTitle.isEmpty == false
        {
            self.navigationItem.title = navigationTitle
        }else
        {
            self.navigationItem.title = "Website"
        }
        
        if self.websiteUrl.isEmpty == false
        {
            self.webview.loadRequest(URLRequest(url: URL(string: self.websiteUrl)!))
        }
    }
    func webView(_ webView: UIWebView!, didFailLoadWithError error: Error?) {
        print("Webview fail with error \(error)");
        appDelegate.HideProgress()
    }
        
    func webViewDidStartLoad(_ webView: UIWebView!) {
        print("Webview started Loading")
        appDelegate.ShowProgress(self)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView!) {
        print("Webview did finish load")
        appDelegate.HideProgress()
    }
    func SetNavigationButton(){
        
        let lblFrame = CGRect(x: 0, y: 0, width: 75,height: 50)
        let titleLabel = UILabel(frame: lblFrame)
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "OPEN IN BROWSER"
        
        let userframe = CGRect(x: 0, y: 0, width: 75, height: 50)
        let userButton = UIButton(frame: userframe)
        userButton.addTarget(self, action:#selector(self.OpenBrowser), for: .touchUpInside)
        let viewframe = CGRect(x: 0, y: 0, width: 62, height: 50)
        
        let rightView = UIView(frame: viewframe)
        rightView.backgroundColor = UIColor.clear
        rightView.addSubview(titleLabel)
        rightView.addSubview(userButton)
        
        let rightButton = UIBarButtonItem(customView: rightView)
        
        self.navigationItem.rightBarButtonItem = rightButton
    }
    @objc func OpenBrowser(){
        if self.websiteUrl.isEmpty == false {
            UIApplication.shared.openURL(URL(string: self.websiteUrl)!)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
