//
//  FinderViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit

class FinderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    var image: UIImage? = nil
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier == "finderResult") {
            if let viewController = segue.destination as? UINavigationController {
                let root = viewController.viewControllers[0]
                (root as! FinderResultViewController).image = self.image
            }
        }
    }
    
    @IBAction func onASearchPerson () {
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
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.image = pickedImage
        }

        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "finderResult", sender: nil)
        })

    }

}
