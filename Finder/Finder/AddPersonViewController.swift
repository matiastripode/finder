//
//  AddPersonViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddPersonViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    let imagePicker = UIImagePickerController()

    var imageUploaded: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        let myColor : UIColor = UIColor( red: 136/255, green: 214/255, blue:188/255, alpha: 1.0 )
        self.textField.layer.borderColor = myColor.cgColor
        self.textField.layer.borderWidth = 1
        
        
        self.doneButton.layer.cornerRadius = 15
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) &&
            UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let alertController = UIAlertController(title: "Source", message: nil, preferredStyle: .alert)
            
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
            
            if let user = UserManager.shared.currentUser {
                
                MBProgressHUD.showAdded(to: self.view, animated: true)

                let familyMember = FamilyMember (image: self.imageView.image, image_url: "", name:text)
                FinderManager.shared.add(familyMember, to: user, success: {
                    
                    DispatchQueue.main.async {
                        self.navigationController!.popViewController(animated: true)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }

                }, failure: {_ in
                    DispatchQueue.main.async {
                        self.navigationController!.popViewController(animated: true)
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                })
            }

            
            
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
