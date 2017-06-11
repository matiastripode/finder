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
             success: @escaping BasicClosure,
             failure: @escaping FailureClosure) {
     
        //1. Upload File
        KairosManager.shared.upload(member, success: { result in
            var updated = member
            updated.image_url = result.url
            
            UserManager.shared.currentUser?.family?.append(updated)
            UserManager.shared.saveFamily()

            // 2. Enroll
            KairosManager.shared.enroll(user,
                                        member: updated,
                                        success: {
                                            
                                            let data = ["phone": user.phone,
                                                        "name": user.name]
                                            
                                            
                                            DataService.shared.writeData(by: "reporters/\(user.phone)",
                                                data: data as RawDataType, success: { _ in
                                                    
                                                    //Add member to firebase
                                                    let memberId = user.phone + member.name
                                                    let data = ["name": member.name,
                                                                "status": "notLost",
                                                                "reporterId": user.phone]
                                                    DataService.shared.writeData(by: "people/\(memberId)",
                                                        data: data as RawDataType,
                                                        success: { _ in success()},
                                                        failure: failure)
                                            
                                            
                                            },
                                                                         failure: failure)
                                            
                                            
//                                            //3. Add to firebase
//                                            let dictionary = [ "username": user.name ]
//                                            
//                                            DataService.shared.writeData(by: "users/",
//                                                                         data: dictionary as RawDataType, success: { (result) in
//                                                                            succes()
//                                            }, failure: failure)
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
                guard let result = result,
                    let owner = result["reporterid"] as? String else {
                        return failure(NSError())
                }
                
                DataService.shared.retrieveData(by: "reporters/\(String(describing: owner))",
                                                success: { (result) in
                                                    guard let result = result else{
                                                            return failure(NSError())
                                                        }

                        let name = result["name"] as? String ?? ""
                        let phone = result["phone"] as? String ?? ""
                                                    
                        //4. Send push notificaitons
                        NotificationManager.shared.notify(owner,
                                                          phone: phone,
                                                          name: name,
                                                          success: succes,
                                                          failure: failure)
                }, failure: failure)
            }, failure: failure)
        }, failure: failure)
        
        
    }
}
