//
//  AppDelegate.swift
//  FaceAR-VE-Sample
//
//  Created by Gleb Markin on 2/9/21.
//

import UIKit
import BanubaSdk
import BanubaEffectPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let bundleRoot = Bundle.init(for: BNBEffectPlayer.self).bundlePath
    let dirs = [bundleRoot + "/bnb-resources", Bundle.main.bundlePath + "/effects"]
    BanubaSdkManager.initialize(
      resourcePath: dirs,
      clientTokenString: banubaClientToken,
      logLevel: .info
    )
    return true
  }
}

