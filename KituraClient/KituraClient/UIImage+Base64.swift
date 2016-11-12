//
//  UIImage+Base64.swift
//  Kitura-iOS
//
//  Created by Ernesto García on 11/11/16.
//  Copyright © 2016 cocoawithchurros. All rights reserved.
//

import UIKit


extension UIImage {
  
  convenience init?( base64Encoded: String ) {
    
    guard let data = Data( base64Encoded: base64Encoded, options: .ignoreUnknownCharacters) else {
      return nil
    }
    self.init(data: data)
  }
  
  var base64:String? {
    
    guard let data = UIImagePNGRepresentation(self) else {
      return nil
    }
    return data.base64EncodedString()
  }
}
