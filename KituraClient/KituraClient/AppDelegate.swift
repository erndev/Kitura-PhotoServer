//
//  AppDelegate.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    if let window = window, let navVC = window.rootViewController as? UINavigationController, let photosVC = navVC.topViewController as? PhotosViewController  {
      
      photosVC.photosRepository = KituraPhotoRepository( baseURL: URL(string: "http://localhost:8090")!)
    
    }
    return true
  }




}

