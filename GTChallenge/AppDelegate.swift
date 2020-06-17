//
//  AppDelegate.swift
//  GTChallenge
//
//  Created by Micah Napier on 15/6/20.
//  Copyright © 2020 Micah Napier. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  private lazy var coordinator: WeatherCoordinator = {
    let coordinator = WeatherCoordinator()
    return coordinator
  }()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    
    window.rootViewController = coordinator.navigationController
    window.makeKeyAndVisible()
    return true
  }

}


