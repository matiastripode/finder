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
typealias RecognizeSuccessClosure = (RecognizeResult) -> Void

struct KairosImageData {
    var image: Base64ImageData
}

struct UploadResult {
    var url: String
}

struct RecognizeResult {
    var subject_id: String
    var image_url: String
}

class KairosManager {
    static let shared = KairosManager()

    let cloudManager = CloudinaryManager.shared
 
    func detect( _ data: KairosImageData,
                 success: @escaping BasicClosure,
                 failure: @escaping FailureClosure) {
        
        
        let base64ImageData = KairosAPI.shared.convertImageFileToBase64String(file: "elizabeth.jpg")
        
        // setup json request params, with base64 data
        let jsonBodyDetect = [
            "image": base64ImageData
        ]
        
        KairosAPI.shared.request(method: "enroll", data: jsonBodyDetect) { data in
            // check image key exist and get data
            if let imageData = data as? [String : AnyObject],
                let imageArray = imageData["images"] as? [AnyObject?],
                let image = imageArray[0] {
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

    func recognize(_ image: UIImage,
                success: @escaping RecognizeSuccessClosure,
                failure: @escaping FailureClosure){
        
        cloudManager.upload(image: image, completion: { (url, error) in
            if error == nil {
                if let url = url {
                    
                    let body  = [
                        "gallery_name":"globant123",
                        "image":url
                    ]
                    
                    // Example - /v2/media
                    KairosAPI.shared.request(method: "recognize",
                                             data: body) { (result) in
                                                print(result)
                                                guard let images = result["images"] as? [Any],
                                                    let image = images[0]  as? [String:Any],
                                                    let transaction = image["transaction"] as? [String:Any],
                                                    //let candidate = candidates[0] as? [String:Any],
                                                    let subject_id = transaction["subject_id"] as? String else {
                                                        return failure(NSError())
                                                }
                                                
                                                let recognize = RecognizeResult(subject_id: subject_id, image_url: url)
                                                success(recognize)
                    }

                    
                }
            } else {
                failure(error!)
            }
        })
    }

    
    func upload(_ member: FamilyMember,
                success: @escaping UploadSuccessClosure,
                failure: @escaping FailureClosure){
    
        guard let image = member.image else {
            return failure(NSError())
        }

    
        cloudManager.upload(image: image, completion: { (url, error) in
            if error == nil {
                if let url = url {
                    let data = UploadResult(url: url)
                    success(data)
                }
            } else {
                failure(error!)
            }
        })
    }
    
    func enroll(_ user: User,
                member: FamilyMember,
                success: @escaping BasicClosure,
                failure: @escaping FailureClosure){
        
        let jsonBody = [
            "image": member.image_url,  //"https://media.kairos.com/test1.jpg",
            "gallery_name": user.galleryName,
            "subject_id": user.phone + member.name//"test1"
        ]
        
        KairosAPI.shared.request(method: "enroll", data: jsonBody) { data in
            // check image key exist and get data
            if let imageData = data as? [String : AnyObject],
                let imageArray = imageData["images"] as? [AnyObject?],
                let image = imageArray[0] {
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


