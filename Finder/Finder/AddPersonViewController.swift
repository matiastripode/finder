//
//  AddPersonViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit

class AddPersonViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!

    let imagePicker = UIImagePickerController()

    var imageUploaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) &&
            UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let alertController = UIAlertController(title: "Source", message: "Select a source", preferredStyle: .alert)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
            
            let libraryAction = UIAlertAction(title: "Photo library", style: .default) { action in
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(libraryAction)
            
            self.present(alertController, animated: true) {
                
            }

        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        self.dismiss(animated: true, completion: nil);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    @IBAction func dismissKeyboard() {
        self.textField.resignFirstResponder()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            imageUploaded = true
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onAddPerson () {
        if let text = self.textField.text, imageUploaded, text != "" {
            let familyMember = FamilyMember (image: self.imageView.image, image_url: "", name:text)
            
            if let user = UserManager.shared.currentUser {
                FinderManager.shared.add(familyMember, to: user, succes: {
                    self.dismiss(animated: true, completion: nil)
                }, failure: {_ in
                    print ("There was an error adding the family member")
                    self.dismiss(animated: true, completion: nil)
                })
            }
            //TODO: Add family member to user
            self.navigationController!.dismiss(animated: true, completion: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Image and name are required", preferredStyle: .alert)
            
            let cameraAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            }
            alertController.addAction(cameraAction)
            
            self.present(alertController, animated: true) {
            }
        }
    }
    
    

}
