//
//  KairosManager.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation
import UIKit

typealias Base64ImageData = String
typealias UploadSuccessClosure = (UploadResult) -> Void

struct KairosImageData {
    var image: Base64ImageData
}

struct UploadResult {
    var url: String
}
class KairosManager {
    static let shared = KairosManager()
    
 
    func detect( _ data: KairosImageData,
                 success: @escaping BasicClosure,
                 failure: @escaping FailureClosure) {
        
        
        let base64ImageData = KairosAPI.shared.convertImageToBase64String(file: "elizabeth.jpg")
        
        // setup json request params, with base64 data
        let jsonBodyDetect = [
            "image": base64ImageData
        ]
        
        KairosAPI.shared.request(method: "enroll", data: jsonBodyDetect) { data in
            // check image key exist and get data
            if let image = ((data as? [String : AnyObject])!["images"])![0] {
                // get root image and primary key objects
                let attributes = (image as? [String : AnyObject])!["attributes"]
                let transaction = (image as? [String : AnyObject])!["transaction"]
                
                // get specific enrolled attributes
                var gender = (attributes as? [String : AnyObject])?["gender"]!["type"]!! as! String
                let gender_type = (gender == "F") ? "female" : "male"
                let age = (attributes as? [String : AnyObject])!["age"]! as! Int
                let confidence_percent = 100 * ((transaction as? [String : AnyObject])!["confidence"]! as! Double)
                
                // display results
                print("\n--- Enroll (face recognition, using image url)\n")
                print("Gender: \(gender_type)")
                print("Age: \(age)")
                print("Confidence: \(confidence_percent)% \n")
                
                success()
            }
            else {
                print("Error - Enroll: unable to get image data")
                let error = NSError()
                failure(error)
            }
        }

    }
    
    func upload(_ member: FamilyMember,
                success: @escaping UploadSuccessClosure,
                failure: @escaping FailureClosure){
    
        guard let image = member.image else {
            return failure(NSError())
        }
        
        let imageData: NSData = UIImageJPEGRepresentation(image, 0.4)! as NSData
        let imageStr = imageData.base64EncodedData(options: .endLineWithCarriageReturn)
        
        
        let body = [
            "file": ["data": imageStr],
            "folder": "user1",
            "upload_preset": "personfinder"
            
        ] as [String : Any]
    
        // Example - /v2/media
        KairosAPI.shared.request(method: "globanthackmiami/image/upload",
                                 data: body) { (result) in
                                    
            let url = result["url"] as! String
            let data = UploadResult(url: url)
            success(data)
        }
        
        

    
    }
    
    func enroll(_ user: User,
                member: FamilyMember,
                success: @escaping BasicClosure,
                failure: @escaping FailureClosure){
        
        let jsonBody = [
            "image": member.image_url,  //"https://media.kairos.com/test1.jpg",
            "gallery_name": user.galleryName,
            "subject_id": member.name//"test1"
        ]
        
        KairosAPI.shared.request(method: "enroll", data: jsonBody) { data in
            // check image key exist and get data
            if let image = ((data as? [String : AnyObject])!["images"])![0] {
                // get root image and primary key objects
                let attributes = (image as? [String : AnyObject])!["attributes"]
                let transaction = (image as? [String : AnyObject])!["transaction"]
                
                // get specific enrolled attributes
                var gender = (attributes as? [String : AnyObject])?["gender"]!["type"]!! as! String
                let gender_type = (gender == "F") ? "female" : "male"
                let age = (attributes as? [String : AnyObject])!["age"]! as! Int
                let confidence_percent = 100 * ((transaction as? [String : AnyObject])!["confidence"]! as! Double)
                
                // display results
                print("\n--- Enroll")
                print("Gender: \(gender_type)")
                print("Age: \(age)")
                print("Confidence: \(confidence_percent)% \n")
                
                success()
            }
            else {
                let error = NSError()
                
                print("Error - Enroll: unable to get image data")
                failure(error)
            }
        }

    }
}


