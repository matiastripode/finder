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
    func add(_ member: FamilyMember,
             to user: User,
             succes: @escaping BasicClosure,
             failure: @escaping FailureClosure) {
        
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
