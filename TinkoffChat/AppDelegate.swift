//
//  AppDelegate.swift
//  tinkoffChat
//
//  Created by Anton on 20.09.2018.
//  Copyright © 2018 Switch. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static let rootAssembly = RootAssembly()
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //storageManager = CoreDataDiskStorage(coreDataStack: <#ICoreDataStack#>)
        AppDelegate.rootAssembly.presentationAssembly.communicationFacade.start()
        AppDelegate.rootAssembly.presentationAssembly.themeFacade.retriveAndApplyTheme()
        return true
    }
    func application(_ application: UIApplication,
                     willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        = nil) -> Bool {
        return true
    }
    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
        //storageManager.terminateSave()
    }
}
