//
//  AppDelegate.swift
//  Wopho1
//
//  Created by Sebastian Schmitt on 14.09.19.
//  Copyright © 2019 Sebastian Schmitt. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver, SKPaymentQueueDelegate, SKRequestDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        SKPaymentQueue.default().add(self)
        
        return true
    }
    
    // MARK: - IAP
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                print("---|||| .failed \(transaction)")
            case .purchased:
                queue.finishTransaction(transaction)
                print("---|||| .purchased \(transaction)")
            case .restored:
                queue.finishTransaction(transaction)
                print("---|||| .restored \(transaction)")
            case .deferred:
                print("---|||| .deferred \(transaction)")
            case .purchasing:
                print("---|||| .purchasing \(transaction)")
            @unknown default:
                print("---|||| .defaul \(transaction)")
            }
        }
    }
    
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        <#code#>
//    }
    
    
    
//    func refreshPurchasedProducts() async {
//        // Iterate through the user's purchased products.
//        for await verificationResult in Transaction.currentEntitlements {
//            switch verificationResult {
//            case .verified(let transaction): 
//                // Check the type of product for the transaction
//                // and provide access to the content as appropriate.
//                
//            case .unverified(let unverifiedTransaction, let verificationError):
//                // Handle unverified transactions based on your
//                // business model.
//                
//            }
//            break
//        }
//    }
    
    
    func getReceipt(forTransaction transaction: SKPaymentTransaction?) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
        do {
            let receipt = try Data(contentsOf: receiptURL)
            receiptValidation(receiptData: receipt, transaction: transaction)
        } catch {
            let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
            appReceiptRefreshRequest.delegate = self
            appReceiptRefreshRequest.start()
        }
    }

    func receiptValidation(receiptData: Data?, transaction: SKPaymentTransaction?) {
        guard let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0)) else { return }
        verifyIAPreceipt(receipt_String: receiptString, transaction: transaction)
    }

    func verifyIAPreceipt(receipt_String receiptString: String, transaction: SKPaymentTransaction?) {
        let params: [String: Any] = ["receipt-data": receiptString, "password": "1verson36Sandbox", "exclude-old-transactions": true]

    }
    
    
    
//    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
//        guard let url = dynamicLink.url else {
//            print("link object has no url")
//            return
//        }
//        print("Link is incoming \(url.absoluteString)")
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }
//        for queryItem in queryItems {
//            print("Parameter \(queryItem.name) has a value of \(queryItem.value ?? "")")
//        }
//        dynamicLink.matchType == .unique
//    }
    
    
    
    func handleIncomingDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            print("DynamicLink object hat keine URL---")
            print("link test 1")
            return
        }
//        print("linke parameter kommt rein \(url.absoluteString)")
        guard (dynamicLink.matchType == .unique || dynamicLink.matchType == .default) else {
            // Nicht stark genug. Lass uns jetzt nicht machen
//            print("Nicht stark genug match type fortsetzen")
            print("link test 2")
            return
        }
        print("link test 3")
        // Parse the linke parameter
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return }
        print("link test 4")
        if components.path == "/posts" {
            print("link test 5")
            if let postsIDQueryItem = queryItems.first(where: {$0.name == "postsID"}) {
                print("link test 6 \(postsIDQueryItem.value) oder .....\(postsIDQueryItem)")
                guard let postID = postsIDQueryItem.value else { return }
                //let appdelegate = UIApplication.shared.delegate as! AppDelegate
                print("link test 7")
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                guard let newDetailVC = storyboard.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController else { return }
                newDetailVC.getPostForId(postId: postID)
                //guard let newDetailVC = storyboard.instantiateViewController(identifier: "HomeViewController") as? HomeViewController else { return }
                
//                let nav = UINavigationController(rootViewController: newDetailVC)
//                appdelegate.window?.rootViewController = nav
                
                //(self.window?.rootViewController as? UINavigationController)?.pushViewController(newDetailVC, animated: true)
//                (self.window?.rootViewController as? UINavigationController)?.present(newDetailVC, animated: true, completion: {
//
//                })
//                (self.window?.rootViewController as? UITabBarController)?.present(newDetailVC, animated: true, completion: {
//                })
                
                guard let _tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else { return }
                
                
                guard let firstNavi = storyboard.instantiateViewController(withIdentifier: "NavigationControllerFirst") as? UINavigationController else { return }
                guard let secondNavi = storyboard.instantiateViewController(withIdentifier: "NavigationControllerSecond") as? UINavigationController else { return }
                guard let thirdNavi = storyboard.instantiateViewController(withIdentifier: "NavigationControllerThird") as? UINavigationController else { return }
                guard let fourthNavi = storyboard.instantiateViewController(withIdentifier: "NavigationControllerFourth") as? UINavigationController else { return }
                guard let vc = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController else { return }
                
                _tabBarController.viewControllers = [firstNavi, secondNavi, thirdNavi, fourthNavi]
                

                

                self.window = UIWindow.init(frame: UIScreen.main.bounds)
                self.window?.rootViewController = _tabBarController
                self.window?.makeKeyAndVisible()
                
                vc.getPostForId(postId: postID)
                firstNavi.pushViewController(vc, animated: true)
                //firstNavi.present(vc, animated: true, completion: nil)
                
                //firstNavi.pushViewController(vc, animated: true)
                
                //tabBarController.present(vc, animated: true, completion: nil)
                
                
                
                //vc.getLink(postId: postID)
//                newDetailVC.getLink(postId: postID)
//                newDetailVC.modalPresentationStyle = .fullScreen
//                guard let tabBarTest = window?.rootViewController as? UITabBarController else { return }
//                tabBarTest.tabBar.isHidden = false
//
//                tabBarTest.present(_tabBarController, animated: true) {
//                }
                
//                newDetailVC.modalPresentationStyle = .fullScreen
//                newDetailVC.hidesBottomBarWhenPushed = false
//                window = UIWindow(frame: UIScreen.main.bounds)
//                window?.makeKeyAndVisible()
//                let objNav = UINavigationController(rootViewController: UITabBarController())
//                //objNav.isNavigationBarHidden = true
//                objNav.hidesBottomBarWhenPushed = false
//                objNav.tabBarController?.tabBar.isHidden = false
//                window?.rootViewController = objNav
//                //objNav.pushViewController(newDetailVC, animated: true)
//
//                objNav.present(tabBarController, animated: true, completion: nil)
                
//                guard let tabBarTest = window?.rootViewController as? UITabBarController else { return }
//                window?.makeKeyAndVisible()
//                window?.isHidden = false
//                window?.layoutIfNeeded()
//                tabBarTest.viewControllers?.enumerated()
//                tabBarTest.present(newDetailVC, animated: true) {
//                }
                
                //newDetailVC.getPostForId(postId: postID)
                
//                let tabBarController = UITabBarController()
//                tabBarController.viewControllers = newDetailVC
//
//                window?.rootViewController = tabBarController
//                window?.makeKeyAndVisible()
//
//                tabBarController.present(newDetailVC, animated: true)
                
//                func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//
////                    if viewController is SearchResultViewController {
////                        if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") {
////
////                            tabBarController.present(newVC, animated: true) {
////                            }
////                            return false
////                        }
////                    }
////                    return true
//                    return true
//                }
                
                
                
//                guard let newDetailVC = storyboard.instantiateViewController(identifier: "TabBarController") as? UITabBarController else { return }
//                let newDetailVC = storyboard.instantiateViewController(identifier: "SearchPostViewController") as SearchPostViewController
//                newDetailVC.loadViewIfNeeded()
                print("link test 8")
                print("kommst du soweit mit dem link")
                //print("\(newDetailVC.debugDescription)")
                //newDetailVC.getPostForId(postId: postID)
                
                //newDetailVC.getLink(postId: postID)
                
                // When Searchresult VC than uncommend
                //newDetailVC.reachedIndexFromWish = 0
                //newDetailVC.loadViewIfNeeded()
//                let nav = UINavigationController(rootViewController: newDetailVC)
//                appdelegate.window?.rootViewController = nav
//
//                (self.window?.rootViewController as? UINavigationController)?.pushViewController(newDetailVC, animated: true)
//                (self.window?.rootViewController as? UITabBarController)?.present(newDetailVC, animated: true, completion: {
//
//                })
                

                //
                
                //newDetailVC.modalPresentationStyle = .fullScreen
                
//                newDetailVC.tabBarController?.selectedIndex = 0
//                newDetailVC.tabBarController?.selectedViewController = newDetailVC.tabBarController?.viewControllers![1]
                
//                tabBarTest.tabBar.window?.makeKeyAndVisible()
//                tabBarTest.selectedIndex = 1
//                tabBarTest.hidesBottomBarWhenPushed = false
//                tabBarTest.modalPresentationStyle = .fullScreen
                
                
//                tabBarTest.navigationController?.pushViewController(newDetailVC, animated: true)
                
                print("link test 9")
                
//                UINavigationController
//                newDetailVC.postCardCell.translatesAutoresizingMaskIntoConstraints = false
                
//                newDetailVC.postCardCell.clipsToBounds = true
//                newDetailVC.updateViewConstraints()
//                newDetailVC.loadViewIfNeeded()
                
//                newDetailVC.viewWillLayoutSubviews()
//                if newDetailVC.postCardCell == nil {
//                    newDetailVC.loadViewIfNeeded()
//                    newDetailVC.viewDidLayoutSubviews()
//                    newDetailVC.viewWillLayoutSubviews()
//                }
                
                
                
//                (self.window?.rootViewController as? UINavigationController)?.popToViewController(newDetailVC, animated: true)
            }
        }
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            print("incoming URL is \(incomingURL)")
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { (dynamicLink, error) in
                guard error == nil else {
                    print("Found an error! \(error?.localizedDescription)")
                    return
                }
//                print("Dynamich link error 1.0")
                if let dynamicLink = dynamicLink {
                    self.handleIncomingDynamicLink(dynamicLink)
                    print("incoming 2")
//                    print("Dynamich link error 2.0")
                }
            }
            if linkHandled {
                print("incoming 3")
                return true
            } else {
                // Maybe do other things with our incoming URL?
//                print("error by linkHandled 3.5")
                print("incoming false ")
                return false
                
            }
        }
        print("false by nothing 3.6")
        return false
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("I have recieved a URL through a custom scheme! \(url.absoluteString)")
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            self.handleIncomingDynamicLink(dynamicLink)
            print("kommt da auch was 00000000000000000000000")
            return true
        } else {
            // handle Google or Facebook sign-in here
            return false
        }
        
        

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        self.saveContext()
    }
    
    // MAR   K: - Core Data stack

        var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

}
