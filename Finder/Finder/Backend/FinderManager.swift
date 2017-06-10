//
//  FinderManager.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation

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
}
