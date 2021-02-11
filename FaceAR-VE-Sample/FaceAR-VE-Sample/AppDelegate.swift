//
//  AppDelegate.swift
//  FaceAR-VE-Sample
//
//  Created by Gleb Markin on 2/9/21.
//

import UIKit
import BanubaSdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    BanubaSdkManager.initialize(
      resourcePath: [Bundle.main.bundlePath + "/effects"],
      clientTokenString: banubaClientToken
    )
    return true
  }
}

