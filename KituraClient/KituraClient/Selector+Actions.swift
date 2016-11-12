//
//  Selector+Actions.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit

extension Selector {
  
  var isDelete: Bool {
    return ( self == #selector(UIResponder.delete(_:)) )
  }
}
