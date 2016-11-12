//
//  PhotoJson.swift
//  Tutorial
//
//  Created by Ernesto García on 11/11/16.
//
//
import SwiftyJSON

enum Field {
  
  static let title = "title"
  static let photo = "photo"
  static let id = "id"
  static let photos = "photos"
  static let error = "error"
}


extension KituraPhoto {
  
  var json: JSON  {
    
    
    return JSON([
      Field.title: title,
      Field.id: self.id,
      Field.photo: self.data.base64EncodedString(),
      ])
  }
  
  init?(json: JSON ) {
    guard let id = json[Field.id].string,
          let title = json[Field.title].string,
          let imageBase64 = json[Field.photo].string,
          let image =   Data(base64Encoded:imageBase64, options: .ignoreUnknownCharacters) else {
      return nil
    }
    self.id = id
    self.title = title
    self.data = image
    
    
  }
}

enum RequestError: String {
  
  case parseID          = "Could not parse photo ID"
  case invalidContentType   = "Invalid Content Type. Should be application/json"
  case invalidContent   = "Invalid request content"
  case invalidJSON      = "Invalid JSON"
  case insert           = "Error inserting the photo"
  
  var json:JSON {
    return JSON( [Field.error : rawValue ])
  }
}

extension Sequence where Iterator.Element == KituraPhoto {
  


  var json:JSON {
    var jsonValue = JSON([:])
    
    let photos = JSON( self.map{ $0.json } )
    jsonValue[Field.photos] = photos
    return jsonValue
  }

  static func from(json: JSON) -> [KituraPhoto]? {
    
    guard let array = json[Field.photos].array?.flatMap({ KituraPhoto(json: $0) }) else {
      return nil
    }
    return array
  }
  

  
}


