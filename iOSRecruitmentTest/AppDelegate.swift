//
//  AppDelegate.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit
import Foundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = MainViewController()
        let viewModel = MainViewModel()
        viewModel.model = MainModel()
        viewController.viewModel = viewModel
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

