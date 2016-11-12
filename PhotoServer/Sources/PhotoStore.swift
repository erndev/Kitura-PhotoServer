//
//  Protocols.swift
//  Tutorial
//
//  Created by Ernesto García on 11/11/16.
//
//

import Foundation


public protocol  PhotoStore {
  func savePhoto( title: String, image:Data ) -> Photo?
  func allPhotos() -> [Photo]
  func deletePhoto( _ photoID: String) -> Bool
}
