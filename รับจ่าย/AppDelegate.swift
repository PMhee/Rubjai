//
//  AppDelegate.swift
//  รับจ่าย
//
//  Created by Tanakorn on 7/10/2559 BE.
//  Copyright © 2559 Tanakorn. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        // Set navigation bar tint / background colour
        UINavigationBar.appearance().barTintColor = UIColor (red: 0.357, green: 0.302, blue: 0.608, alpha: 1.0)
        
        // Set Navigation bar Title colour
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //UpdateRealm
        Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 3, migrationBlock: { migration, oldSchemaVersion in
            // The enumerateObjects:block: method iterates
            // over every 'Person' object stored in the Realm file
            migration.enumerate(Account.className()) { oldObject, newObject in
                
                if oldSchemaVersion < 1 {
                    //
                    newObject!["test"] = ""
                }
                
                
            }
            
            migration.enumerate(Accounts.className()) { oldObject, newObject in
                if oldSchemaVersion < 1 {
                    let setting = Setting.allObjects()
                    let income = Income.allObjects()
                    for j in 0..<setting.count{
                        var sumAll = 0.0
                        for i in 0..<income.count{
                            if (income[i] as! Income).account_id == (setting[j] as! Setting).account_id{
                                if (income[i] as! Income).money_type == "income"{
                                    sumAll += (income[i] as! Income).money
                                }else{
                                    sumAll -= (income[i] as! Income).money
                                }
                            }
                        }
                        let realm = RLMRealm.defaultRealm()
                        realm.beginWriteTransaction()
                        let account = Accounts()
                        let s = setting[j] as! Setting
                        account.account_id = s.account_id
                        account.account_name = s.account_id
                        account.currentMoney = sumAll
                        realm.addObject(account)
                        try! realm.commitWriteTransaction()
                    }
                }
                
                
                
                
            }
            migration.enumerate(WishingList.className()) { oldObject, newObject in
                if oldSchemaVersion < 2 {
                    //
                    newObject!["wishingList_image"] = ""
                }
            }
            
        })
        
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        let realm = try! Realm()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

