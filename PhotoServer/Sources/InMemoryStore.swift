//
//  InMemoryStore.swift
//  Tutorial
//
//  Created by Ernesto García on 11/11/16.
//
//

import Foundation
import KituraCache




class CacheStore {


  let cache = KituraCache()
  
  init(photos: [Photo]) {
    
    for photo in photos {
      savePhoto(photo: photo)
    }
  }
  
}

extension CacheStore: PhotoStore {

  public func deletePhoto(_ photoID: String) -> Bool {
    cache.removeObject(forKey: photoID)
    return true
  }
  
  func allPhotos() -> [Photo] {
    
    let photos =  (cache.keys() as? [String] ?? [] ).flatMap{
      return cache.object(forKey: $0) as? Photo
    }
    return photos
  }
  func savePhoto( photo: Photo) {
    cache.setObject(photo, forKey: photo.id)

  }
  func savePhoto(title: String, image: Data) -> Photo? {
    let photo = Photo(id: UUID().uuidString, title: title, data: image)
    savePhoto(photo: photo)
    return photo
  }
}
