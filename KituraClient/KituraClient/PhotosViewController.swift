//
//  ViewController.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
  
  enum Constants {
    
    static let photoCellID = "photoCellID"
  }
  var photosRepository: PhotoRepository?
  var photos:[Photo] = []
  var alertController: UIAlertController?
  
  
  @IBOutlet  var refreshItem: UIBarButtonItem!
  @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
  @IBOutlet weak var collectionView: UICollectionView!
  var progressItem:UIBarButtonItem!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    progressItem = UIBarButtonItem(customView: progressIndicator)
    reloadPhotos()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard let identifier = segue.identifier, let segEnum = Segue(rawValue: identifier) else {
      return
    }
    if segEnum == .addPhoto, let destinationNav = segue.destination as? UINavigationController, let destination = destinationNav.topViewController as? AddPhotoViewController{
      destination.delegate = self
    }
  }
  
  func showError( _ error: Error) {
    if alertController != nil {
      return
    }
    
    self.alertController = UIAlertController(title: "Oops", message: error.localizedDescription, preferredStyle: .alert)
    let error = error as NSError
    
    alertController?.title = "Oops!!"
    alertController?.message = error.localizedDescription
    let action = UIAlertAction(title: "Close", style: .default) { action in
      self.alertController = nil
    }
    alertController?.addAction(action )
    
    
    present( alertController!, animated: true, completion: nil)
  }
  
  @IBAction func refresh ( sender: AnyObject ) {
    reloadPhotos()
  }
  
  func showProgress( _ show: Bool ) {
    
    self.navigationItem.leftBarButtonItem = (show ? progressItem : refreshItem)
    show ? progressIndicator.startAnimating() : progressIndicator.stopAnimating()
  }
  
}

extension PhotosViewController {
  
  func reloadPhotos() {
    showProgress(true)
    photosRepository?.allPhotos { (photos, error) in
      DispatchQueue.main.async {
        self.showProgress(false)
        if let error = error {
          print("Error \(error)")
          self.showError(error)
          return
        }
        else {
          self.photos = photos
          self.collectionView?.reloadData()
        }
      }
    }
    collectionView.reloadData()
  }
  
  func deleteImageAt( indexPath: IndexPath) {
    showProgress(true)
    
    let photo = photos[indexPath.row]
    photosRepository?.deletePhoto(photo.identifier) { error in
      DispatchQueue.main.async {
        self.showProgress(false)
        
        if let error = error {
          self.showError(error)
          return
        }
        
        self.photos.remove(at: indexPath.row )
        self.collectionView?.deleteItems(at: [indexPath])
      }
    }
    
  }
  
  func savePhotoWithImage( _ image: UIImage, title: String ) {
    showProgress(true)
    
    photosRepository?.insertPhoto(image, title: title, completion: { (photo, error) in
      DispatchQueue.main.async {
        self.showProgress(false)
        
        if let error = error {
          self.showError(error)
          return
        }
        
        if let photo = photo {
          let last = self.photos.count
          self.photos.append(photo)
          self.collectionView?.insertItems(at: [ IndexPath(row:last, section:0)])
        }
      }
    })
    
  }
  
}

extension PhotosViewController: UICollectionViewDataSource {
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.photoCellID, for: indexPath)
    if let cell = cell as? CollectionViewCell {
      let photo = photos[indexPath.row]
      cell.imageView.image = photo.image
      cell.label.text = photo.title
      cell.layer.cornerRadius = 4.0

    }
    return cell
  }
  
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  
}

extension PhotosViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    if action.isDelete {
      deleteImageAt(indexPath: indexPath)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
    return action.isDelete
  }
  
  func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
    return true
  }
}

extension PhotosViewController: AddPhotoDelegate {
  
  func addPhotoController( _ controller: AddPhotoViewController, didFinishWithTitle title: String?, image: UIImage?, cancelled: Bool ) {
    
    self.dismiss(animated: true, completion: nil)
    if let title = title, let image = image , !cancelled {
      savePhotoWithImage(image, title: title)
    }
  }
  
}
