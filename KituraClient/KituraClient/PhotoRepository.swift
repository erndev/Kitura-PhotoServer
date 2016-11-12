//
//  File.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit


protocol PhotoRepository {
  
  func allPhotos( completion: @escaping ( _ photos: [Photo], _ error:Error? ) -> Void )
  func insertPhoto(  _ photo: UIImage, title: String, completion: @escaping ( _ photo: Photo?, _ error: Error?) -> Void)
  func deletePhoto( _ photoID: String, completion: @escaping (_ error: Error? ) -> Void  )
}
