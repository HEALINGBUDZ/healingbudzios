
//  AppDelegate.swift
//  BaseProject
//
//  Created by Vengile on 14/06/2017.
//  Copyright © 2017 Wave. All rights reserved.
//

import UIKit
import IQKeyboardManager
import Fabric
import Crashlytics
import OneSignal
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import CoreLocation
import Stripe
import GoogleMobileAds
import GooglePlaces
var txtUrlMain:String = ""
var isfromYoutubePlayer : Bool = false 
var blinking_count = 0
var isProfileBlinkingClose  = false
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate ,OSPermissionObserver, OSSubscriptionObserver {
    let interstitial: GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/8691691433")
    func reloadvideoAdd() {
        let request = GADRequest()
        interstitial.load(request)
    }
    var active_navigation_controller : UINavigationController?
    var isShownPremioumpopup = true
    let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
    var isSideMenudisabled : Bool = false
    var isBaseNavigation : Bool = false
	var window     : UIWindow?
    var isPopQuestion   = false
    var keywords = HBUserDafalts.sharedInstance.getKeyword()
     var orignalkeywords = HBUserDafalts.sharedInstance.getKeyword()
    var badgeCount: Int = 0
    var isIphoneX : Bool = false
    var rootViewController = UINavigationController()
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
    }
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //Google Adds
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~3347511713")
        self.initFreshchatSDK()
        reloadvideoAdd()
        notificationFeedbackGenerator.prepare()
        rootViewController = self.window!.rootViewController as! UINavigationController

//        STPPaymentConfiguration.shared().publishableKey = "pk_test_kBD5CZDk3MBZNRLeWqrfvhew"
        // In House Test Key
        
          STPPaymentConfiguration.shared().publishableKey = "pk_test_oJX1vAPXtFBkeX6mZuOestxD" //Client Test Key
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
//        GIDSignIn.sharedInstance().clientID = "529251596135-0e4in31a0nm8conadpoqmhhsqjic7u4s.apps.googleusercontent.com"
        
        // live hb account
        GIDSignIn.sharedInstance().clientID = "700098895046-d3t4qgepf0foklf9213vi9s980hisj9q.apps.googleusercontent.com"
        
        
//        GMSPlacesClient.provideAPIKey("AIzaSyA36vEmSvJs5_tUUc__uJ2hxu2jQ8-7GIg")
//        GMSPlacesClient.provideAPIKey("AIzaSyDHIEg4XvVaiDq9CCL5VItz5Pg6ZkEZ80g")
         GMSPlacesClient.provideAPIKey("AIzaSyB1v06JaOpoyATQJKGIu0lnQ5kfJ7bkaSc")
//        GMSPlacesClient.provideAPIKey("AIzaSyCiDgdLD46NLVGAV3AKcEZt4DKTtCeprQE")
        //AIzaSyCiDgdLD46NLVGAV3AKcEZt4DKTtCeprQE
//         GMSServices.provideAPIKey("AIzaSyB1v06JaOpoyATQJKGIu0lnQ5kfJ7bkaSc")
        GIDSignIn.sharedInstance().delegate = self
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().previousNextDisplayMode = .alwaysHide
		UIApplication.shared.statusBarStyle = .lightContent
		
		NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.PushMainView), name: NSNotification.Name(rawValue: "PushMainView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.openMessageVc), name: NSNotification.Name(rawValue: "openMessageVc"), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.PushLoginView), name: NSNotification.Name(rawValue: "PushLoginView"), object: nil)
		  

        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            self.notificationFeedbackGenerator.notificationOccurred(.success)
            print("Received Notification: \(notification!.payload.notificationID)")
            print("launchURL = \(String(describing: notification?.payload.launchURL))")
//            notification!.payload.setlaunchURL = ""
            print("content_available = \(String(describing: notification?.payload.contentAvailable))")
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewNotification"), object: nil)
        }
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            let payload: OSNotificationPayload? = result?.notification.payload
//             result!.payload.launchURL = ""
            print("Message = \(payload!.body)")
            print("badge number = \(String(describing: payload?.badge))")
            print("notification sound = \(String(describing: payload?.sound))")
            if let additionalData = result!.notification.payload!.additionalData {
                UIApplication.shared.applicationIconBadgeNumber = 0
                let badgeCount: Int = 0
                let application = UIApplication.shared
                application.registerForRemoteNotifications()
                application.applicationIconBadgeNumber = badgeCount
                 print(additionalData)
                if (additionalData["activityToBeOpened"] as? String) != nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                        self.toBeOpende(data: additionalData as [AnyHashable : Any])
                        
                    })
                }
                //TODO FOR This VAR activityToBeOpened
            } 
        }
        //139//4d45602b-c1af-4de2-94eb-e6ed693160eb
        //138//7bba51a3-1389-4a7e-980d-d91c81b77d91
        //139Live//b9e61456-239b-46e1-b22d-84991b7814ad
        //HB Dev // 6d19c4df-d4f0-4e1c-a43e-be772051e974
        // HB Live // f48525e4-ef44-4788-8a94-cdbf97b6ba7b
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true , kOSSSettingsKeyPromptBeforeOpeningPushURL : true , kOSSettingsKeyInFocusDisplayOption: OSNotificationDisplayType.none.rawValue] as [String : Any]
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "f48525e4-ef44-4788-8a94-cdbf97b6ba7b", handleNotificationReceived: notificationReceivedBlock, handleNotificationAction: notificationOpenedBlock, settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none


        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Add your AppDelegate as an obsserver
        OneSignal.add(self as OSPermissionObserver)
        
        OneSignal.add(self as OSSubscriptionObserver)
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                isIphoneX = false
                print("iPhone 5 or 5S or 5C")
            case 1334:
                isIphoneX = false
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                isIphoneX = false
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                isIphoneX = true
                print("iPhone X")
            default:
                isIphoneX = false
                print("unknown")
            }
        }
        if ((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID) != nil) {
            if (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!.characters.count > 0 {
                let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")
                userDefaults?.set(DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID ,forKey: "sskey")
                userDefaults?.synchronize()
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let nav1 = BaseNavigationController()
                let MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "EmailLoginViewController")
                nav1.viewControllers = [MainContainer]
                self.window?.rootViewController = nil
                self.window?.rootViewController = nav1
            }else {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let nav1 = BaseNavigationController()
                let MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
                nav1.viewControllers = [MainContainer]
                self.window?.rootViewController = nil
                self.window?.rootViewController = nav1
            }
        }else {
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let nav1 = BaseNavigationController()
            let MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
            nav1.viewControllers = [MainContainer]
            self.window?.rootViewController = nil
            self.window?.rootViewController = nav1
        }
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor(hexColor: "676669")
//        let menuVC = MenuVC.menuVC()
//        contentNavigationController = UINavigationController(rootViewController: menuVC)
//        contentNavigationController?.isNavigationBarHidden = true
//        self.window?.rootViewController = contentNavigationController
        if let url = launchOptions?[.url] as? URL {
            return executeDeepLink(with: url)
        }
        
		return true
	}
    
    // Add this new method
    func onOSPermissionChanged(_ stateChanges: OSPermissionStateChanges!) {
        
        // Example of detecting answering the permission prompt
        if stateChanges.from.status == OSNotificationPermission.notDetermined {
            if stateChanges.to.status == OSNotificationPermission.authorized {
                print("Thanks for accepting notifications!")
            } else if stateChanges.to.status == OSNotificationPermission.denied {
                print("Notifications not accepted. You can turn them on later under your iOS settings.")
            }
        }
    }
    
    // Output:
    /*
     Thanks for accepting notifications!
     PermissionStateChanges:
     Optional(<OSSubscriptionStateChanges:
     from: <OSPermissionState: hasPrompted: 0, status: NotDetermined>,
     to:   <OSPermissionState: hasPrompted: 1, status: Authorized>
     >
     */
    
    // TODO: update docs to change method name
    // Add this new method
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    
    func initFreshchatSDK() {
        let fchatConfig = FreshchatConfig.init(appID: "57a3a6ae-a145-4bb2-a33c-5a8b05cfd6cd", andAppKey: "b9b562e4-ee91-4038-b22c-96758b81bf8b") //Enter your AppID and AppKey here
        fchatConfig?.gallerySelectionEnabled = false
        fchatConfig?.cameraCaptureEnabled = false
        Freshchat.sharedInstance().initWith(fchatConfig)
    }
    
    public func executeDeepLink(with url: URL) -> Bool {
        let recognizer = DeepLinkRecognizer(deepLinkTypes: [
            openQuestionDetail.self,
            openShoutOut.self,
            openBudzSpecial.self,
            openBudzServices.self,
            openBudzProduct.self,
            openBudzReview.self,
            openBudzMapLink.self,
            openStrainReview.self,
            openStrainProduct.self,
            openStrainDetail.self,
            openPostLink.self,
            openForgetPassword.self,
            openStrainDetailShow.self
            ])
        guard let deepLink = recognizer.deepLink(matching: url) else {
            print("Unable to match URL: \(url.absoluteString)")
            return false
        }
        switch deepLink {
        case let question_detail as openQuestionDetail:
            print(question_detail.question_id)
             self.openQuestionDetailScreeen(id: "\(question_detail.question_id)")
            return true
        case _ as openShoutOut:
            let viewpush = self.GetView(nameViewController: "ShoutOutListVC", nameStoryBoard: "ShoutOut") as! ShoutOutListVC
            isBaseNavigation = true
            let nav1 = BaseNavigationController()
            nav1.navigationBar.isHidden = true
            nav1.viewControllers = [viewpush]
            self.window?.rootViewController = nil
            self.window?.rootViewController = nav1
            return true
        case let budz_special as openBudzSpecial:
            self.openBudzMap(id: "\(budz_special.budz_map_id)" , isSpecial: false)
            return true
        case let budz_Services as openBudzServices:
             self.openBudzMap(id: "\(budz_Services.budz_map_id)", isSpecial: false)
            return true
        case let budz_product as openBudzProduct:
             self.openBudzMap(id: "\(budz_product.budz_map_id)", isSpecial: false)
            return true
        case let budz_review as openBudzReview:
             self.openBudzMap(id: "\(budz_review.budz_map_id)", isSpecial: false)
            return true
        case let budz_map as openBudzMapLink:
             self.openBudzMap(id: "\(budz_map.budz_map_id)", isSpecial: false)
            return true
        case let strain_review as openStrainReview:
                self.openStrain(id: "\(strain_review.strain_id)")
            return true
        case let strain_product as openStrainProduct:
            self.openStrain(id: "\(strain_product.strain_id)")
            return true
        case let strain as openStrainDetail:
                  self.openStrain(id: "\(strain.strain_id)")
            return true
        case let post as openPostLink:
                self.openPost(index: "\(post.post_id)")
            return true
        case let strain as openStrainDetailShow:
            self.openStrain(id: "\(strain.strain_id)")
            return true
        case let pass as openForgetPassword:
            self.openForgotPassword(token: pass.token)
            return true
        default:
            fatalError("Unsupported DeepLink: \(type(of: deepLink))")
        }
    }
    
    func GetView(nameViewController : String , nameStoryBoard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        
        return viewObj
        
    }
    func OpenProfileVC(id : String, feedDataController: FeedDataController? = nil) {
         isBaseNavigation = true
        let profile_vc = self.GetView(nameViewController: "UserProfileViewController", nameStoryBoard: StoryBoardConstant.Profile) as! UserProfileViewController
        profile_vc.user_id = id
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [profile_vc]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    func PushViewWithStoryBoard(nameViewController : String , nameStoryBoard : String) {
         isBaseNavigation = true
        let storyboard = UIStoryboard(name: nameStoryBoard, bundle: nil)
        let viewObj = (storyboard.instantiateViewController(withIdentifier: nameViewController)) as UIViewController
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [viewObj]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    func openPost(index: String!){
        isBaseNavigation = true
        let feedDetail = self.GetView(nameViewController: "FeedDetail", nameStoryBoard: "Wall") as! FeedDetailViewController
        feedDetail.fromActivityLog = true
        feedDetail.fromActivityID = Int(index!)
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [feedDetail]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
   
    func openForgotPassword(token: String!){
        isBaseNavigation = true
        let feedDetail = self.GetView(nameViewController: "ChangePasswordVC", nameStoryBoard: "ProfileView") as! ChangePasswordVC
        feedDetail.token = token
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [feedDetail]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    
    func toBeOpende(data: [AnyHashable : Any]){
        print(data)
        var id_type = 0
        if let type_id = data["type_id"] as? Int {
            id_type = type_id
        }else if let type_id = data["type_id"] as? String {
            id_type = Int(type_id)!
        }
         if id_type != 0 {
            if let dataType = data["activityToBeOpened"] as? String {
                switch dataType{
                case "Questions" , "Question":
                    self.openQuestionDetailScreeen(id: String(id_type))
                    break;
                case "Answers":
                    self.openQuestionDetailScreeen(id:  String(id_type))
                    break;
                case "Budz Map" , "SubUser", "Budz", "Budz Adz":
                    self.openBudzMap(id:  String(id_type), isSpecial: false)
                    break
                case "Special":
                    self.openBudzMap(id:  String(id_type), isSpecial: true)
                    break
                case "Strains" , "Strain":
                    self.openStrain(id:  String(id_type))
                    break;
                case "Users" , "users":
                    self.OpenProfileVC(id:  String(id_type))
                    break;
                case "Comment" , "Post":
                    self.openPost(index:  String(id_type))
                    break;
                case "ShoutOut" , "shout_out" , "shoot_out" , "ShootOut":
                    if let shout_out = data["shout_out"] as? [String: AnyObject] {
                        if let id = shout_out["shout_out_id"] as? String {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let data:[String: Any] = ["sout_out_id": id]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenShoutOut"), object: nil, userInfo: data)
                            }
                           
                        }else if let id = shout_out["shout_out_id"] as? Int {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let data:[String: Any] = ["sout_out_id": String(id)]
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenShoutOut"), object: nil, userInfo: data)
                            }
                            
                        }
                    }else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let data:[String: Any] = ["sout_out_id": String(id_type)]
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OpenShoutOut"), object: nil, userInfo: data)
                        }
                    }
                    break;
                default:
                    break;
                }
            }
         }else if  let dataType = data["activityToBeOpened"] as? String {
            if dataType == "Chat"{
                if let msg_data  = data["message"] as? [String : AnyObject]{
                    print(msg_data)
                    if let chat_id = msg_data["chat_id"] as? Int , let budz_id = msg_data["budz_id"] as? Int {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
                        let messe_user = Message(json: msg_data)
                        vc.isSelectUser = false
                        vc.chat_id = "\(chat_id)"
                        vc.bud_map_id = "\(budz_id)"
                        vc.msg_data_modal = messe_user
                        isBaseNavigation = true
                        let nav1 = BaseNavigationController()
                        nav1.navigationBar.isHidden = true
                        nav1.viewControllers = [vc]
                        self.window?.rootViewController = nil
                        self.window?.rootViewController = nav1
                    }else if let chat_id = msg_data["chat_id"] as? String , let budz_id = msg_data["budz_id"] as? String  {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
                        let messe_user = Message(json: msg_data)
                        vc.isSelectUser = false
                        vc.chat_id = chat_id
                        vc.bud_map_id = budz_id
                        vc.msg_data_modal = messe_user
                        isBaseNavigation = true
                        let nav1 = BaseNavigationController()
                        nav1.navigationBar.isHidden = true
                        nav1.viewControllers = [vc]
                        self.window?.rootViewController = nil
                        self.window?.rootViewController = nav1
                    }else if let chat_id = msg_data["chat_id"] as? Int , let budz_id = msg_data["budz_id"] as? String  {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
                    let messe_user = Message(json: msg_data)
                    vc.isSelectUser = false
                    vc.chat_id = "\(chat_id)"
                    vc.bud_map_id = budz_id
                    vc.msg_data_modal = messe_user
                    isBaseNavigation = true
                    let nav1 = BaseNavigationController()
                    nav1.navigationBar.isHidden = true
                    nav1.viewControllers = [vc]
                    self.window?.rootViewController = nil
                    self.window?.rootViewController = nav1
                    }else if let chat_id = msg_data["chat_id"] as? String , let budz_id = msg_data["budz_id"] as? Int  {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "BussinessMessageChatVC") as! BussinessMessageChatVC
                        let messe_user = Message(json: msg_data)
                        vc.isSelectUser = false
                        vc.chat_id = chat_id
                        vc.bud_map_id = "\(budz_id)"
                        vc.msg_data_modal = messe_user
                        isBaseNavigation = true
                        let nav1 = BaseNavigationController()
                        nav1.navigationBar.isHidden = true
                        nav1.viewControllers = [vc]
                        self.window?.rootViewController = nil
                        self.window?.rootViewController = nav1
                    }else{
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MessageChatVC") as! MessageChatVC
                        let messe_user = Message(json: msg_data)
                        vc.msg_data_modal = messe_user
                        isBaseNavigation = true
                        let nav1 = BaseNavigationController()
                        nav1.navigationBar.isHidden = true
                        nav1.viewControllers = [vc]
                        self.window?.rootViewController = nil
                        self.window?.rootViewController = nav1
                    }
                }
            }else if dataType == "Reminder" {
                let storyboard = UIStoryboard(name: "ProfileView", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CompleteProfileVC") as! CompleteProfileVC
                isBaseNavigation = true
                let nav1 = BaseNavigationController()
                nav1.navigationBar.isHidden = true
                nav1.viewControllers = [vc]
                self.window?.rootViewController = nil
                self.window?.rootViewController = nav1
            }
            
        }
    }
    
    func openQuestionDetailScreeen(id : String)  {
        isBaseNavigation = true
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        let DetailQuestionVc = self.GetView(nameViewController: "DetailQAViewController", nameStoryBoard: StoryBoardConstant.QA) as! DetailQAViewController
        DetailQuestionVc.QuestionID = id
        DetailQuestionVc.isFromProfile = false
        nav1.viewControllers = [DetailQuestionVc]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    func openBudzMap(id : String , isSpecial: Bool) {
         isBaseNavigation = true
        let viewpush = self.GetView(nameViewController: "DispensaryDetailVC", nameStoryBoard: StoryBoardConstant.Main) as! DispensaryDetailVC
        viewpush.budz_map_id = id
        if (isSpecial){
           viewpush.isSpecialShown = true
        }
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [viewpush]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    func openStrain(id : String)  {
         isBaseNavigation = true
        let detailView = self.GetView(nameViewController: "StrainDetailViewController", nameStoryBoard: StoryBoardConstant.Main) as! StrainDetailViewController
        detailView.IDMain = id
        
        let nav1 = BaseNavigationController()
        nav1.navigationBar.isHidden = true
        nav1.viewControllers = [detailView]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if let user = DataManager.sharedInstance.user{
            UIApplication.shared.applicationIconBadgeNumber = (user.notifications_count.intValue)
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
            application.applicationIconBadgeNumber = (user.notifications_count.intValue)
        }//TextSharedHas
    
        let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")
        var ssKey = userDefaults?.object(forKey: "sskey") as! String
        print("TextSharedHas")
        print(ssKey)
        
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        self.badgeCount = 0
        let application = UIApplication.shared
        application.registerForRemoteNotifications()
        application.applicationIconBadgeNumber = self.badgeCount
        let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")
        var ssKey = userDefaults?.object(forKey: "sskey") as! String
        print("TextSharedHas")
        print(ssKey)
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if let user = DataManager.sharedInstance.user{
            UIApplication.shared.applicationIconBadgeNumber = (user.notifications_count.intValue)
            let application = UIApplication.shared
            application.registerForRemoteNotifications()
            application.applicationIconBadgeNumber = (user.notifications_count.intValue)
            NetworkManager.PostCall(UrlAPI: "offline_user", params: ["session_key" : DataManager.sharedInstance.user?.sessionID as AnyObject]) { (isSuccess, responseString, data) in
               print("offline api called")
                print(data)
            }
            sleep(5)
        }
	}

    
    
    static func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func openMessageVc() {
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let nav1 = BaseNavigationController()
        let MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "MyMessageVC")
        nav1.viewControllers = [MainContainer]
        self.window?.rootViewController = nil
        self.window?.rootViewController = nav1
    }
    func PushMainView(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as! MFSideMenuContainerViewController
        let menuSide = mainStoryBoard.instantiateViewController(withIdentifier: "MainMenu")
        let MapSide = mainStoryBoard.instantiateViewController(withIdentifier: "MainTabbar")
        self.window?.rootViewController = MainContainer
        MainContainer.leftMenuViewController = menuSide
        MainContainer.centerViewController = MapSide
	}
	
	func PushLoginView(){
		
		let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
		
		let nav1 = BaseNavigationController()
        var MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "LoginVC")
//        if ((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID) != nil) {
//            if (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!.characters.count > 0 {
//                MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "EmailLoginViewController")
//            }
//        }
		
		nav1.viewControllers = [MainContainer]
		
		self.window?.rootViewController = nil
		
		self.window?.rootViewController = nav1
		
	}
    private func application(application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        if url.absoluteString.contains("google") {
            
            return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)

        }
        
        return  FBSDKApplicationDelegate.sharedInstance().application(application,open: url as URL?,sourceApplication: sourceApplication,annotation: annotation)
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url.scheme ?? "test")
        print(url.absoluteString)
        if   url.scheme == "hbscheme" {
            return executeDeepLink(with: url)
        }
        let userDefaults = UserDefaults(suiteName: "group.com.healingbudz.ios")//group.com.healingbudz.ios
        if let key = url.absoluteString.components(separatedBy: "=").last,
            let sharedArray = userDefaults?.object(forKey: key) as? String {
            if ((DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID) != nil) {
                if (DataManager.sharedInstance.getPermanentlySavedUser()?.sessionID)!.characters.count > 0 {
//                    isBaseNavigation = true
//                    let postFeedViewController = self.GetView(nameViewController: "UserWallViewController", nameStoryBoard: "Main") as! UserWallViewController
////                    let postFeedViewController = postFeedNavigationController.topViewController as! PostFeedViewController
////                    postFeedViewController.feedDataController = FeedDataController()
//                    postFeedViewController.txtUrl = sharedArray
//                    txtUrlMain = sharedArray
////                    let nav1 = BaseNavigationController()
////                    nav1.navigationBar.isHidden = true
////                    nav1.viewControllers = [postFeedViewController]
//////                    self.window?.rootViewController = nil
////                    self.window?.rootViewController = nav1
//                    let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//                    let nav1 = BaseNavigationController()
//                    let MainContainer = mainStoryBoard.instantiateViewController(withIdentifier: "EmailLoginViewController")
//                    nav1.viewControllers = [MainContainer]
//                    self.window?.rootViewController = nil
//                    self.window?.rootViewController = nav1
//                    var mainParam: [String : AnyObject]
//                    mainParam = ["description": sharedArray as AnyObject,
//                                 "images": "" as AnyObject,
//                                 "video": "" as AnyObject,
//                                 "poster": "" as AnyObject,
//                                 "tagged": "" as AnyObject,
//                                 "thumb": "" as AnyObject,
//                                 "ratio": "" as AnyObject,
//                                 "json_data": "" as AnyObject,
//                                 "posting_user": "" as AnyObject,
//                                 "repost_to_wall": 1 as AnyObject,
//                                 "url": sharedArray as AnyObject]
//                    NetworkManager.PostCall(UrlAPI: WebServiceName.save_post.rawValue, params: mainParam) { (Isdone, ResMessage, response) in
//                        print(Isdone)
//                        print(ResMessage)
//                        print(response)
//                        if (!Isdone){
//                            var mainParam: [String : AnyObject]
//                            mainParam = ["description": sharedArray as AnyObject,
//                                         "images": "" as AnyObject,
//                                         "video": "" as AnyObject,
//                                         "poster": "" as AnyObject,
//                                         "tagged": "" as AnyObject,
//                                         "thumb": "" as AnyObject,
//                                         "ratio": "" as AnyObject,
//                                         "json_data": "" as AnyObject,
//                                         "posting_user": "" as AnyObject,
//                                         "repost_to_wall": 1 as AnyObject,
//                                         "url": sharedArray as AnyObject]
//                            NetworkManager.PostCall(UrlAPI: WebServiceName.save_post.rawValue, params: mainParam) { (Isdone, ResMessage, response) in
//                                print(Isdone)
//                                print(ResMessage)
//                                print(response)
//
//                            }
//                        }
//                    }
                    return false
                }
            }
            
        }
        if #available(iOS 9.0 , *){
            if url.absoluteString.contains("google") {
                
                return GIDSignIn.sharedInstance().handle(url,
                                                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplicationOpenURLOptionsKey.annotation])
            }else{
                  return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
            }
        }
        return true
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notifications.googleSignInNotification), object: user)
            print(user.description)
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        //print(error.description)
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        print("Continue User Activity called: ")
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            let url = userActivity.webpageURL!
            print(url.absoluteString)
            if url.absoluteString.contains("?token="){
               let url_new =  URL.init(string: url.absoluteString.replacingOccurrences(of: "?token=", with: "/"))
                return executeDeepLink(with: url_new!)
            }else{
                return executeDeepLink(with: url)
            }
            
        }
        return true
    }
}

