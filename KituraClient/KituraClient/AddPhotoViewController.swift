//
//  AddPhotoViewController.swift
//  KituraClient
//
//  Created by Ernesto García on 12/11/16.
//  Copyright © 2016 erndev. All rights reserved.
//

import UIKit


protocol AddPhotoDelegate : class {
  
  func addPhotoController( _ controller: AddPhotoViewController, didFinishWithTitle title: String?, image: UIImage?, cancelled: Bool )
  
}

class AddPhotoViewController: UIViewController {
  var delegate: AddPhotoDelegate?
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleTextField: UITextField!
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.layer.cornerRadius = 4.0
    updateSaveButton()
  }
  
  @IBAction fileprivate func titleTextChanged(sender: AnyObject ) {
    
    updateSaveButton()
  }
  
  fileprivate func updateSaveButton() {
    guard let item = navigationItem.rightBarButtonItem else {
      return
    }
    item.isEnabled = (imageView.image != nil && !(titleTextField.text?.isEmpty ?? true)  )
  }
  
  @IBAction func cancelButton( sender: AnyObject) {
    delegate?.addPhotoController(self, didFinishWithTitle: nil, image: nil, cancelled: true)
  }
  
  
  @IBAction func saveButton( sender: AnyObject) {
 
      delegate?.addPhotoController(self, didFinishWithTitle: self.titleTextField.text, image: imageView.image, cancelled: false)
  }
  
  
  @IBAction func didTapImage( sender: AnyObject ) {
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    present(imagePicker, animated: true, completion: nil)
    
  }
}

extension AddPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
   
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
      updateSaveButton()
    }
    picker.dismiss(animated: true, completion: nil)
  }
  
}
