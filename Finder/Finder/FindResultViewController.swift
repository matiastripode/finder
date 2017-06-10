//
//  FindResultViewController.swift
//  Finder
//
//  Created by Nicolas Porpiglia on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import UIKit
import MapKit

class FindResultViewController: UIViewController {

    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var phoneLabel : UITextField!
    @IBOutlet weak var imageView : UIImageView!

    let latitude = 0
    let longitude = 0
    let imageURL: String? = nil
    let phone: String? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.phoneLabel.text = phone

        
        if let imageURL = imageURL, let url = URL(string: imageURL) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        mapView.addAnnotation(annotation)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
