//
//  HTTPClient.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import Foundation
import SwiftyJSON

enum HTTPMethod: String  {
  case get    = "GET"
  case delete = "DELETE"
  case post   = "POST"
  
}

class KituraHTTPClient {
  fileprivate enum Constants {
    static let error = "error"
    static let errorDomain = "kituraErrorDomain"
  }
  
  let baseURL:URL
  let session = URLSession( configuration: URLSessionConfiguration.ephemeral)
  init( baseURL: URL) {
    
    self.baseURL = baseURL
  }
  
  internal func requestWithURL( _ url: URL, method: HTTPMethod, json: JSON?, completion: @escaping (_ json: JSON?, _ error: Error?) -> Void) {
    
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    if let body = try? json?.rawData() {
      request.httpBody = body
    }
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = session.dataTask(with: request ){ (data, response, error) in
      if let error = error {
        completion(nil, error)
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse, let data = data, !data.isEmpty else {
        completion(nil, error)
        return
      }
      // 2
      let json = JSON(data: data)
      if let jsonError = json.error  {
        completion(nil, jsonError)
        return
      }
      
      // 3
      if let errorString = json[Constants.error].string {
        let appError = NSError(domain: Constants.errorDomain, code: httpResponse.statusCode, userInfo: [ NSLocalizedDescriptionKey: errorString])
        completion(nil, appError)
        return
      }
      
      // 1
      guard  200..<300 ~= httpResponse.statusCode else  {
        let connError = NSError(domain: Constants.errorDomain, code: httpResponse.statusCode , userInfo: [ NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode) ] )
        completion(nil, connError)
        return
      }
      
      
      // 4
      completion(json, error)
    }
    task.resume()
  }
  

}
