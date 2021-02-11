//
//  AppDelegate.swift
//  BeUtopian
//
//  Created by desap on 12/09/16.
//  Copyright © 2016 desap. All rights reserved.
//com.beutopiansmartsociety.app
//com.Wgate.smartsociety
import UIKit
import Firebase

let iDeviceType : String = "iphone"
var iDeviceToken : String = "0"
var iDeviceUDID : String = "0"
var AppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

//let appDelegate: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
let appDelegate = UIApplication.shared.delegate as! AppDelegate

var isDataAddedToSociety : Bool = false
var LoginUserID : String = ""


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?
//    var viewController: JASidePanelController?
    var navController: UINavigationController?

    var ProgressView : GSIndeterminateProgressView!
    
    var DeskboardCommonObject = NSDictionary()
    
    var CompanyID : String = ""
    var EmployeeID : String = ""
    
    var LoginUserID : String = ""
    var SocietyID : String = ""
    var FlatID : String = ""
    var EmailID : String = ""

//    var ClientTag : String = ""
    var ClientTag : String = "56ED3233-CD60-4F70-A830-002A2144DD9E"

//    var ClientTag : String = ""
  
    //Testing with space new user name and password
    var AuthToken : String = ""
    var homeUserId = ""

//    var AuthToken : String = "BTe+KMdoKOSY2oRtdy+b8YYeWYQFdnLa/zPDbOpYKZVkkl8lZXzLE6ZObiN1LMyBjg1ALbXEzC9DHMgZ2ipefg=="
    
    
    //loader
    let activityIndicatorView = DGActivityIndicatorView(type: (DGActivityIndicatorAnimationType.triplePulse ), tintColor: UIColor.white)
    var PulseAnimationView = UIView(frame: UIScreen.main.bounds)
    
//    var PulseAnimationView = UIVisualEffectView(frame: UIScreen.mainScreen().bounds)
    
    var gmailloading: GmailLikeLoadingView?
    
    //************ WGATE Data **************
    var HomeDelightData = NSMutableDictionary()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Firebase integration
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        
        CopyData().coyDatabase()
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared.enable = true

//        viewController = JASidePanelController()
//        viewController?.shouldDelegateAutorotateToVisiblePanel = false
//        viewController?.leftPanel = LeftNavigationMenu()

        let loginData = getLoginUser()
        if let userId = loginData.object(forKey: "userID") as? String {
            self.LoginUserID = userId
        }
        if let socityId = loginData.object(forKey: "societyID") as? String {
            self.SocietyID = socityId
        }
        if let emailId = loginData.object(forKey: "email") as? String {
            self.EmailID = emailId
        }
        if let flatId = loginData.object(forKey: "flatID") as? String {
            self.FlatID = flatId
        }
        
        if let userid = UserDefaults.standard.value(forKey: "HomeDelightUserID") as? String {
            self.homeUserId = userid
        }
        
        if LoginUserID == ""
        {
//            let navigate = UINavigationController(rootViewController: LoginViewController())
            
            
            //let navigate = UINavigationController(rootViewController: HelpViewController())
//            let navigate = UINavigationController(rootViewController: VerifyMobileViewController())
            
//            viewController?.centerPanel = navigate
          //  self.window?.rootViewController = navigate;
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HelpViewController")
                 let navigate = UINavigationController(rootViewController: vc)
                self.SetNavigationBar(navigate)

                    self.window?.rootViewController = navigate;
        }else{
            
            let navigate = UINavigationController(rootViewController: HomeRootViewController())
//            let navigate = UINavigationController(rootViewController: DemoSocietyController())
            
            
            self.SetNavigationBar(navigate)
//            self.viewController?.centerPanel = navigate
            self.window?.rootViewController = navigate;
        }
        
       //Configuration PushNotification
        self.ConfigurationPushNotification()
        
//        self.window?.rootViewController = viewController;
        self.window?.makeKeyAndVisible()
        
       
        if let tempStr = UIDevice.current.identifierForVendor?.uuidString {
            iDeviceUDID = tempStr
        }
        
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)

        return true
    }
    
    func ConfigurationPushNotification(){
        let application = UIApplication.shared
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            
            let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound])
            let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
            //            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: categories as? Set<UIUserNotificationCategory>)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        var deviceTokenString = ""
        
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            deviceTokenString = token
            iDeviceToken = deviceTokenString
          }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceTokenString = ""
//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//
//                print("Remote instance ID token: \(result.token)")
//                deviceTokenString = result.token
//                iDeviceToken = deviceTokenString
//
//                print("Device Token: "+deviceTokenString)
//            }
//        }
        
        
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        

//        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )

//        let deviceTokenString: String = ( deviceToken.description as NSString ).trimmingCharacters( in: characterSet ).replacingOccurrences( of: " ", with: "" ) as String
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        iDeviceToken = "0"
        print("Filed to register : \(error.localizedDescription)")
    }

    // TODO: Rewrite this method with notifications
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        //        self.didReciverNotifcation(userInfo)
//        print(userInfo)
//    }
    
    func application(_ application: UIApplication,  didReceiveRemoteNotification userInfo: [AnyHashable: Any],  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
        print(userInfo)
        
        self.window?.rootViewController?.dismiss(animated: false, completion: {
            
        })
        
//        print(userInfo)
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        if application.applicationState == UIApplication.State.active
        {
            self.NotificationActionWhenActiveApp(userInfo as NSDictionary)
        }
        else
        {
            self.HandleNotificationPayload(userInfo as NSDictionary)
        }
    }
    
    //MARK:- Notification Handler -
    func HandleNotificationPayload(_ userInfo : NSDictionary){
        if let apsDic = userInfo["aps"] as? NSDictionary
        {
            if let alertData = apsDic["type"] as? NSDictionary {
                if let resultData = alertData.object(forKey: "type") as? NSDictionary {
                    if let notificationType = resultData.object(forKey: "push_type") as? String {
             
                        //Notice
                        if notificationType.caseInsensitiveCompare("notice") == .orderedSame
                        {
                          //  let viewController = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier: "NoticeViewController")
                            
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Complain
                        else if notificationType.caseInsensitiveCompare("complain") == .orderedSame {
                           // let viewController = ComplainsViewController(nibName: "ComplainsViewController", bundle: nil)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                       let viewController = storyboard.instantiateViewController(withIdentifier: "ComplainsViewController")
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Event
                        else if notificationType.caseInsensitiveCompare("event") == .orderedSame {
                            let viewController = EventsViewController(nibName: "EventsViewController", bundle: nil)
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Gallery
                        else if notificationType.caseInsensitiveCompare("gallery") == .orderedSame {
                            let viewController = GalleryViewController(nibName: "GalleryViewController", bundle: nil)
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Discussion
                        else if notificationType.caseInsensitiveCompare("discussion") == .orderedSame {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController:DiscussionViewController = storyboard.instantiateViewController(withIdentifier: "DiscussionViewController") as! DiscussionViewController
                           // let viewController = DiscussionViewController(nibName: "DiscussionViewController", bundle: nil)
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Meeting
                        else if notificationType.caseInsensitiveCompare("meeting") == .orderedSame {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let objRoot = storyboard.instantiateViewController(withIdentifier: "MeetingViewController")
                           
                            let notificationNavigation = UINavigationController(rootViewController: objRoot)
                            
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Facility
                        else if notificationType.caseInsensitiveCompare("facility") == .orderedSame
                        {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                     let objRoot = storyboard.instantiateViewController(withIdentifier: "FacilityViewController")
                                     
                        
                            let notificationNavigation = UINavigationController(rootViewController: objRoot)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //poll
                        else if notificationType.caseInsensitiveCompare("poll") == .orderedSame {
                            let viewController = PollsViewController(nibName: "PollsViewController", bundle: nil)
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Rule
                        else if notificationType.caseInsensitiveCompare("rule") == .orderedSame {
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let objRoot = storyboard.instantiateViewController(withIdentifier: "RulesViewController")
                          
                            let notificationNavigation = UINavigationController(rootViewController: objRoot)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //Vendor
                        else if notificationType.caseInsensitiveCompare("vendor") == .orderedSame {
                            let viewController = VendorViewController(nibName: "VendorViewController", bundle: nil)
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //bazaar
                        else if notificationType.caseInsensitiveCompare("bazaar") == .orderedSame {
                            
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController:BazzarViewController = storyboard.instantiateViewController(withIdentifier: "BazzarViewController") as! BazzarViewController
                            
                         
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                        //bazaar
                        else if notificationType.caseInsensitiveCompare("directory") == .orderedSame {
                            let viewController = DirectoryViewController(nibName: "DirectoryViewController", bundle: nil)
                            let notificationNavigation = UINavigationController(rootViewController: viewController)
                            self.SetNavigationBar(notificationNavigation)
                            self.window?.rootViewController!.present(notificationNavigation, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
    }
    
    func NotificationActionWhenActiveApp(_ userInfo : NSDictionary) {
        
        /*
        if let apsDic = userInfo["aps"] as? NSDictionary
        {   
            if let alertData = apsDic["alert"] as? NSDictionary {
                print(alertData)
                
                if let bodyMessage = alertData.objectForKey("body") as? String {
                    // Show notification view
                    HDNotificationView.showNotificationViewWithImage(UIImage(named: "appLogo"), title: kAppName, message: bodyMessage, isAutoHide: true, onTouch: {() -> Void in
                        /// On touch handle. You can hide notification view or do something
                        HDNotificationView.hideNotificationViewOnComplete({ () -> Void in
                            self.HandleNotificationPayload(userInfo)
                            
                        })
                    })
                }
                
            }
        }
         */
        if let apsDic = userInfo["aps"] as? NSDictionary
        {
            if let bodyMessage = apsDic["alert"] as? String {
                HDNotificationView.show(with: UIImage(named: "appLogo"), title: kAppName, message: apsDic["desc"] as? String, isAutoHide: true, onTouch: {() -> Void in
                    /// On touch handle. You can hide notification view or do something
                    HDNotificationView.hide(onComplete: { () -> Void in
                        self.HandleNotificationPayload(userInfo)
                        
                    })
                })
                
            }
        }
        
    }
    
    
    //MARK - SetNavigationBar
    
    func SetNavigationBar(_ navigation: UINavigationController){
        navigation.navigationBar.barTintColor = NSTheme().GetNavigationBGColor()
        navigation.navigationBar.tintColor = NSTheme().GetNavigationTitleColor()
        
        navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: NSTheme().GetNavigationTitleColor()]

//        navigation.navigationBar.translucent = false
    }

    func SetNavigationBarColor(_ navigation: UINavigationController){
        
        let themeColor = UIColor(red: 143.0/255.0, green: 197.0/255.0, blue: 2.0/255.0, alpha: 1.0)
        navigation.navigationBar.lt_setBackgroundColor(themeColor.withAlphaComponent(1))
    }
    
    //MARK - SetTwoButtonInNavigationBar
    
    func SetTwoButtonInNavigationBar(_ nav:UINavigationItem,viewController:UIViewController)
    {
        // nav.hidesBackButton = false
        
        let backbtn = UIBarButtonItem(image: UIImage(named: "btnMenu"), style: .plain, target: viewController, action: Selector("BackClick"))
        nav.leftBarButtonItem = backbtn
        
        let rightbtn = UIBarButtonItem(image: UIImage(named: "SearchIcon"), style: .plain, target: viewController, action: Selector("RightMenuClick"))
        nav.rightBarButtonItem = rightbtn
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = nav.title
        
        nav.titleView?.sizeToFit()
        nav.titleView = label
    }
    
    func RightMenuClick(_ viewController : UIViewController )
    {
        
//        let modalViewController = SearchViewController(nibName: "SearchViewController", bundle: nil)
//        
//        viewController.navigationController?.presentViewController(modalViewController, animated: true, completion: nil)
        //  viewController.navigationController?.pushViewController(modalViewController, animated: true)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    //MARK: - Loader -
    func HideProgress(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if(UIApplication.shared.isIgnoringInteractionEvents){
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        ProgressHUD.dismiss()
//        if(gmailloading != nil){
//            gmailloading?.stopAnimating()
//            gmailloading?.removeFromSuperview()
//        }
        
//        if(self.ProgressView != nil){
//            self.ProgressView.progressTintColor = NSTheme().GetNavigationBGColor()
//            self.ProgressView.stopAnimating()
//            self.ProgressView.hidden = true
//            
//            self.ProgressView.removeFromSuperview()
//            
//            for subview in (UIApplication.sharedApplication().keyWindow?.subviews)! {
//                if subview.isKindOfClass(GSIndeterminateProgressView) == true {
//                    subview.removeFromSuperview()
//                }
//            }
//        }

        
    }
    
    func ShowProgress(_ viewController : UIViewController){
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
       
        ProgressHUD.show("Loading...")
        
//        gmailloading = GmailLikeLoadingView(frame: CGRectMake(((window?.frame.size.width)! / 2)-25, ((window?.frame.size.height)! / 2)-25, 50, 50))
//        window?.addSubview(gmailloading!)
//        gmailloading?.startAnimating()
        
       
//        let navigationBar = viewController.navigationController?.navigationBar
//        if(navigationBar != nil){
//            let frame = CGRectMake(0, (navigationBar?.frame.size.height)! - 4, (navigationBar?.frame.size.width)!, 4)
//            let progressView = GSIndeterminateProgressView(frame: frame)
//            
//            //                    FrameprogressView.progressTintColor = UIColor(red: 75.0/255.0, green: 146.0/255.0, blue: 222.0/255.0, alpha: 1)
//            
//            progressView.progressTintColor = UIColor(hexString:"00ac44")
//            //                    progressView.progressTintColor = UIColor.magentaColor()
//            progressView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleTopMargin]
//            self.ProgressView = progressView
//            self.ProgressView.removeFromSuperview()
//            self.ProgressView.hidden = false
//            navigationBar?.addSubview(self.ProgressView)
//            progressView.startAnimating()
//            
//            
//        }

        
        
    }
    
    //MARK: - Loader -
    func PulseHideProgress(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if(UIApplication.shared.isIgnoringInteractionEvents){
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        self.PulseAnimationView.removeFromSuperview()
        
    }
    
    func PulseShowProgress(){
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        self.PulseAnimationView.effect = blurEffect
        self.PulseAnimationView.backgroundColor = NSTheme().GetNavigationBGColor()
        let mainFrame = self.PulseAnimationView.frame
        
        var frame = activityIndicatorView?.frame
        frame?.origin.x = mainFrame.size.width / 2
        frame?.origin.y = mainFrame.size.height / 2
        activityIndicatorView?.frame = frame!
        
        self.PulseAnimationView.addSubview(activityIndicatorView!)
        
        UIApplication.shared.keyWindow?.addSubview(self.PulseAnimationView)
        activityIndicatorView?.startAnimating()
        
    }

    
    //MARK: - TNM Error Alert -
    func TNMErrorMessage(_ title : String, message : String){
        var titleStr = title
        if titleStr.isEmpty == true
        {
            titleStr = kAppName
        }
        
        let refreshAlert = UIAlertController(title: titleStr, message: message, preferredStyle: UIAlertController.Style.alert)
        
        //        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
        //
        //        }))
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            
        }))
        DispatchQueue.main.async {
            self.window?.visibleViewController?.present(refreshAlert, animated: true, completion: { () -> Void in
                
            })
            
        }
        
        
    }
    //MARK:- Common -
    func DownloadImageFromUrl(_ urlStr : String)
    {
        let objRoot: FullScreenViewController = FullScreenViewController(nibName: "FullScreenViewController", bundle: nil)
        objRoot.resultData = urlStr
        let navigation = UINavigationController(rootViewController: objRoot)
        appDelegate.window?.rootViewController?.present(navigation, animated: true, completion: { () -> Void in
            
        })
    }
    func ShareDetailsResult(_ tempData : NSArray){
       let shareList = NSMutableArray()
        for data in tempData {
            if let tempStr = data as? String {
                shareList.add(tempStr)
            }
        }
                    
        let sharePicker = UIActivityViewController(activityItems: shareList as [AnyObject], applicationActivities: [])
        
        appDelegate.window?.rootViewController?.present(sharePicker, animated: true, completion: { () -> Void in
            
        })
    }
    
    func GetEmptyString(_ tempStr : String) -> String{
        var newStr = ""
        if tempStr == "nil" || tempStr == "(nil)" || tempStr == "<null>" {
            newStr = ""
        }else{
            newStr = tempStr
        }
        return newStr
    }

}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}



////////Remiaining changes
/*
 1) ComplainAddViewController
 
 Method to be commented
 func GetCatagoryType(){
 func AddComplain()
 
 
 
 2)AddVendorViewController
 
 func AddVendor()
 
 
 
 3)UrlConnection
 init(url: NSString,param : NSDictionary?, isGet : Bool)
 */
