//
//  KituraPhotoRepository.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit
import SwiftyJSON

class KituraPhotoRepository {
  
  fileprivate enum Constants {
    static let photoPath = "/photo"
    static let error = "error"
    static let errorDomain = "kituraErrorDomain"
  }
  
  let baseURL: URL
  let httpClient: KituraHTTPClient
  
  init( baseURL: URL ) {
    self.baseURL = baseURL
    self.httpClient = KituraHTTPClient(baseURL: baseURL)
  }
  
  func photoURL( photoID: String? = nil ) -> URL? {
    
    guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
      return nil
    }
    
    var path = Constants.photoPath
    if let photoID = photoID {
      path = (path as NSString).appendingPathComponent(photoID)
    }
    urlComponents.path = path
    return urlComponents.url
  }
  
}

extension KituraPhotoRepository: PhotoRepository {
  
  
  func allPhotos(completion: @escaping ([Photo], Error?) -> Void) {
    guard let url = photoURL() else {
      return
    }
    
    httpClient.requestWithURL(url, method: .get, json: nil) { (json, error) in
      
      if let error = error {
        completion([], error)
        return
      }
      guard let json = json, let photos = [KituraPhoto].from(json: json) else {
        completion([], error)
        return
      }
      
      let appPhotos = photos.flatMap{ (photo) -> Photo? in
        
        guard let image = UIImage(data: photo .data) else {
          return nil
        }
        return Photo(identifier: photo.id, image: image,  title: photo.title)
      }
      completion( appPhotos, nil)
    }
  }
  
  func deletePhoto(_ photoID: String, completion: @escaping (Error?) -> Void) {
    guard let url = photoURL(photoID: photoID) else {
      return
    }
    
    httpClient.requestWithURL(url, method: .delete, json: nil ) { (json, error) in
      completion(error)
    }
  }
  
  func insertPhoto(_ photo: UIImage, title: String, completion: @escaping (Photo?, Error?) -> Void) {
    guard let url = photoURL(), let base64Image = photo.base64 else {
      return
    }
    
    
    let addPhotoJson = JSON([ Field.title: title, Field.photo: base64Image])
    
    httpClient.requestWithURL(url, method: .post, json: addPhotoJson) { (json, error) in
      
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let json = json, let id = json[Field.id].string else {
        completion(nil, NSError(domain: Constants.errorDomain, code: 0 , userInfo: [ NSLocalizedDescriptionKey: "Invalid JSON received in the response from server. No photoID 'id" ]) )
        return
      }
      
      completion( Photo(identifier: id, image: photo, title: title), nil)
    }
  }
  
}
