//
//  FinderResultViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit

class FinderResultViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let image = image else {
            return
        }
        
        self.imageView.image = image
        
        
        FinderManager.shared.report(image,
                                    succes: {
                                        DispatchQueue.main.async {
                                            let alertController = UIAlertController(title: "Result", message: "The person is missing, the family will contact you soon. Call police if necessary", preferredStyle: .alert)
                                            
                                            let cameraAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                                            }
                                            alertController.addAction(cameraAction)
                                            
                                            self.present(alertController, animated: true) {
                                            }
                                            
                                            self.resultImageView.backgroundColor = .green
                                        }
                                        
        }, failure: { (error) in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Result", message: "The person is not missing. Thank you for validating anyway", preferredStyle: .alert)
                
                let cameraAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                }
                alertController.addAction(cameraAction)
                
                self.present(alertController, animated: true) {
                }
                self.resultImageView.backgroundColor = .red
            }

        })
        
           }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack () {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
