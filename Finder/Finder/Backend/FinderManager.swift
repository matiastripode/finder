//
//  FinderManager.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation
import UIKit

typealias SuccessMemberClosure = (FamilyMember?) -> Void


class FinderManager {
    static let shared = FinderManager()
    
    func add(_ member: FamilyMember,
             to user: User,
             succes: @escaping BasicClosure,
             failure: @escaping FailureClosure) {
     
        //1. Upload File
        KairosManager.shared.upload(member, success: { result in
            var updated = member
            updated.image_url = result.url
            // 2. Enroll
            KairosManager.shared.enroll(user,
                                        member: member,
                                        success: {
                                            
                                            //3. Add to firebase
                                            let dictionary = [ "username": user.name ]
                                            
                                            DataService.shared.writeData(by: "users/",
                                                                         data: dictionary as RawDataType, success: { (result) in
                                                                            succes()
                                            }, failure: failure)
            }, failure: failure)

        }, failure: failure)
    }
    
    
    func add(_ members: [FamilyMember],
             to user: User,
             succes: @escaping BasicClosure,
             failure: @escaping FailureClosure) {
        
    }
    
    
    func retrieveFamily(_ user: User,
                        succes: @escaping SuccessMemberClosure,
                        failure: @escaping FailureClosure) {
        
    }
    
    func report (_ image: UIImage,
                 succes: @escaping BasicClosure,
                 failure: @escaping FailureClosure) {
        
        //1. recognize
        KairosManager.shared.recognize(image, success: { data in
            //2. find match in firebase
            
            DataService.shared.retrieveData(by: "people/\(data.subject_id)", success: { (result) in
                //3. find the owner
                if let result = result  {
                    let owner = result["reporterid"] as? String
                    
                    DataService.shared.retrieveData(by: "reporters/\(String(describing: owner))",
                                                    success: { (result) in
                                                        guard let result = result else{
                                                            return failure(NSError())
                                                        }

                            //4. Send push notificaitons
                                                        
                    }, failure: failure)
                }
                
                
                
            }, failure: failure)
            
        }, failure: failure)
        
        
    }
}
