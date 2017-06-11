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
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var buttonPicture: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.buttonPicture.layer.cornerRadius = 15
        self.hintView.layer.cornerRadius = 10
        
        
        let myColor : UIColor = UIColor( red: 136/255, green: 214/255, blue:188/255, alpha: 1.0 )
        self.hintView.layer.borderColor = myColor.cgColor
        self.hintView.layer.borderWidth = 1
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
