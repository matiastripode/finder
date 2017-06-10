//
//  FamilyMember.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation
import UIKit

struct FamilyMember {
    var image: UIImage?
    var image_url: String
    var name: String
    
    
    
    func toDictionary () ->  [String : Any]{
        
        var dic: [String : Any] = [:]
        
        dic ["image_url"] = image_url
        dic ["name"] = name
        
        return dic
        
    }
    
    static func toObject (dic : [String : Any]) -> FamilyMember {
        
        let f:FamilyMember = FamilyMember (image: nil,
                                           image_url: dic ["image_url"] as! String ,
                                           name: dic ["name"] as! String)

        return f
    }
}

