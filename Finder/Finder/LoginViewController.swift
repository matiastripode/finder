//
//  LoginViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        
        if (self.textField.text != nil && self.textField.text != ""){
            
            UserManager.shared.currentUser = User(family: nil,
                                                  name: "User1",
                                                  phone: self.textField.text!,
                                                  galleryName: "globant123")
            UserDefaults.standard.set(self.textField.text!, forKey: "userPhone")

            return true
        }
        
        return false
    }

}
