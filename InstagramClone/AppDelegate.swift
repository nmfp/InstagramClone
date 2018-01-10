//
//  AppDelegate.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 02/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        window = UIWindow()
        window?.rootViewController = MainTabBarController()
        
        attemptRegisterForNotifications(application: application)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications: ", deviceToken)
    }
    
    //Listen for user notifications
    //Ao implementar as push notifications com o FCM se a aplicacao estiver aberta quando enviada uma notificacao de teste, esta so aparece quando a app esta em background
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registred with FCM with token: ", fcmToken)
    }
    
    private func attemptRegisterForNotifications(application: UIApplication) {
        print("Attempting to register APNS...")
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        //user notifications auth
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
            if let err = err {
                print("Failed to request auth: ", err)
                return
            }
            
            if granted {
                print("Auth granted")
            }
            else {
                print("Auth denied ")
            }
        }
        
        
        application.registerForRemoteNotifications()
    }
    
    
    //Este metodo e chamado sempre que o utilizador carrega numa notificacao
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //Objecto da notificacao onde consta a informacao passada no objecto criado do lado do Firebase Cloud Functions
        let userInfo = response.notification.request.content.userInfo
        
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            
            //Mostrar o userProfileController do follower
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.userId = followerId
            
            //Como aceder ao main UI na AppDelegate
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                
                //Uma vez que abaixo se esta a fazer o cast para a homeController e necessario alterar o index da tabBar para 0 evitando assim ter que validar
                //todas as ViewController da tabBar
                mainTabBarController.selectedIndex = 0
                
                //Como o user pode estar na altura da notificacao a postar uma fotografia, essa ViewController das fotografias foi ja anteriormente colocada na
                //stack da NavigationController, ou seja, a alteracao para o userProfileController e feita mas o user so se apercebe depois da ViewController das
                //fotografias desaparece.
                //Para isto nao acontecer, faz-se dismiss das ViewControllers presentes actualmente e assim o user tem sempre a precepcao do aparecimento
                //do userProfileController
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil)
                
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                    homeNavigationController.pushViewController(userProfileController, animated: true)
                }
            }
        }
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
    }


}

