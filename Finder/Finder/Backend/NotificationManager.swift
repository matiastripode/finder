//
//  NotificationManager.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation

struct RecieveNotificationResult {
    var name: String
    var phone: String
}
typealias NotificationSuccess = (RecieveNotificationResult)->()

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func notify(_ reporterid: String,
                phone: String,
                name: String,
                success: @escaping BasicClosure,
                failure: @escaping FailureClosure) {
        
        let data = ["phone": phone,
                    "name": name]
        DataService.shared.writeData(by: "notifications/\(reporterid)",
            data: data as RawDataType,
            success: { _ in success()},
            failure: failure)
    }
    
    func listen(_ reporterid: String,
                success: @escaping NotificationSuccess,
                failure: @escaping FailureClosure) {
        
        DataService.shared.retrieveDataStream(by: "notifications/\(reporterid)",
            success: { (result) in
                guard let result = result else{
                    return failure(NSError())
                }
                let name = result["name"] as? String ?? ""
                let phone = result["phone"] as? String ?? ""
                
                let data = RecieveNotificationResult(name: name, phone: phone)
                
                success(data)
        }, failure: failure)
    }
}



