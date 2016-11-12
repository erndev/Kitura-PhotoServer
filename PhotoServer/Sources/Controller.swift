//
//  Controller.swift
//  Tutorial
//
//  Created by Ernesto García on 11/11/16.
//
//

import Kitura
import LoggerAPI
import Foundation
import SwiftyJSON


fileprivate enum Routes {
  
  static let photo = "/photo"
  static let photoID = "photoid"
}

class Controller {
  
  fileprivate let store: PhotoStore
  internal let router = Router()
  
  init( store: PhotoStore ) {
    
    self.store = store
    setup()
  }
  
  func setup() {
    let deleteRoute = Routes.photo + "/:" + Routes.photoID
    
    router.get(Routes.photo, handler: listAllPhotos )
      .post(Routes.photo, handler: addPhoto )
      .delete(deleteRoute, handler: deletePhoto )
    
  }
  
  func deletePhoto(request: RouterRequest, response: RouterResponse, next: ()->Void) -> Void {
    
    defer {
      next()
    }
    guard request.parameters.count == 1,  let photoID = request.parameters[Routes.photoID] else {
      Log.warning("Could not parse ID")
      response.status(.badRequest).send( json: RequestError.parseID.json)
      return
    }
    _ = store.deletePhoto(photoID)
    response.status(.OK).send( photoID )
  }
  
  func listAllPhotos(request: RouterRequest, response: RouterResponse, next: ()->Void) -> Void {
    let json = store.allPhotos().json
    response.status(.OK).send(json: json)
    next()
  }
  
  
  func addPhoto(request: RouterRequest, response: RouterResponse, next: ()->Void) -> Void {
    defer {
      next()
    }
    do {
      
      
      guard request.accepts(header: "Content-Type", type:"application/json") != nil,
        let string = try request.readString() else {
          response.status(.badRequest).send( json: RequestError.invalidContentType.json )
          return
      }
      
      let json = JSON.parse(string: string)
      guard let title = json[Field.title].string,
        let base64Image = json[Field.photo].string,
        let imageData = Data(base64Encoded:base64Image, options: .ignoreUnknownCharacters) else {
          response.status(.badRequest).send(json: RequestError.invalidJSON.json )
          return
      }
      
      if let photo = store.savePhoto(title: title, image: imageData) {
        let json =  JSON( [ Field.id: photo.id] )
        print( "\(json)")
        response.status(.OK).send(json: json  )
        return
      }
      else {
        response.status(.internalServerError).send(json: RequestError.insert.json )

      }
    }
      
    catch {
      response.status(.badRequest).send(json: RequestError.invalidContent.json )
    }
    
  }
}
