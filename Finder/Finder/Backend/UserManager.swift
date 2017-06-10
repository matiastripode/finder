//
//  UserManager.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation


class UserManager {
    static let shared = UserManager()
    
    var currentUser: User?
    
    
    func saveFamily () {
        if let family = self.currentUser?.family {
            var i = 0
            for member in family {
                let dic = member.toDictionary()
                UserDefaults.standard.set(dic, forKey: "member" + String(describing: i))
                i += 1
            }
        }
    }
    
    func getFamily () {
        self.currentUser?.family = []
        
        var i = 0
        while (UserDefaults.standard.object(forKey: "member" + String(describing: i)) != nil) {
            let f:FamilyMember = FamilyMember.toObject(dic: UserDefaults.standard.object(forKey: "member" + String(describing: i)) as! [String : Any])
            self.currentUser?.family?.append(f)
            i += 1
        }

    }

}
