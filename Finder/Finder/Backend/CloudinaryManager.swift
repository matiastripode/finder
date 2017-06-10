//
//  CloudinaryManager.swift
//  Finder
//
//  Created by Adel Abdelamseih  on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation
import Cloudinary

typealias CloudinaryClosure = (String?, Error?) -> Void

enum StatusCode : Int{
    case success = 200
}

class CloudinaryManager {
    
    static let shared = CloudinaryManager()
    
    let user_folder = "user1"
    let upload_preset = "personfinder"
    let cloundinaryURL = "cloudinary://896457683152776:69tk9WsBBNojuVJ6hbG87pZmZVs@globanthackmiami"
    
    
    func upload(image: UIImage, completion: @escaping CloudinaryClosure) {
        let config = CLDConfiguration(cloudinaryUrl: cloundinaryURL)
        let cloudinary = CLDCloudinary(configuration: config!)
        
        let data = UIImageJPEGRepresentation(image, 0)
        
        let params = CLDUploadRequestParams()
        _ = params.setFolder(user_folder)

        cloudinary.createUploader().upload(data: data!, uploadPreset: upload_preset, params: params, progress: nil) { (result, error) in
            if error == nil {
                completion(result?.secureUrl, nil)
            }
            
            completion(nil, error)
        }
    }
}
