//
//  NavigationViewController.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

  override func viewDidLoad() {
    
    self.navigationBar.barTintColor = UIColor(hue: 240.0/365, saturation: 9.0/100.0, brightness: 22.0/100.0, alpha: 1.0)
    self.navigationBar.tintColor = UIColor.white
    self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.navigationBar.isTranslucent = false
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}
