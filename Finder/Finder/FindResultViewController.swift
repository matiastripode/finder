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
    @IBOutlet weak var phoneLabel : UILabel!
    @IBOutlet weak var imageView : UIImageView!
    
    let latitude = 25.8011416
    let longitude = -80.2044331
    var imageURL: String? = nil
    var phone: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let phone = self.phone {
            self.phoneLabel.text = phone
        }
        
        if let imageURL = imageURL, let url = URL(string: imageURL) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)
                }
            }
        }

        self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        mapView.addAnnotation(annotation)
        
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(region, animated: false)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func callPhone () {
        self.callNumber(phoneNumber: self.phone!)
    }
    
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
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
