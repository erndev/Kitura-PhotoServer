//
//  CollectionViewCell.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  
  override func delete(_ sender: Any?) {
    
    var nextResponder = next
    while nextResponder != nil {
      
      if let collectionView = nextResponder as? UICollectionView,
        let delegate = collectionView.delegate,
        let indexPath = collectionView.indexPath(for: self)
      {
        delegate.collectionView?(collectionView, performAction: #selector(delete(_:)), forItemAt: indexPath, withSender: sender )
        
      }
      
      nextResponder = nextResponder?.next
    }
    
  }
  
}
