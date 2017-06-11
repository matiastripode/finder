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
                imageUrl: String,
                success: @escaping BasicClosure,
                failure: @escaping FailureClosure) {
        
        let data = ["phone": UserManager.shared.currentUser?.phone,
                    "name": name,
                    "imageUrl": imageUrl]
        DataService.shared.writeData(by: "notifications/\(phone)",
            data: data as RawDataType,
            success: { _ in success()},
            failure: failure)        
    }
    
    func listen(_ reporterid: String,
                success: @escaping NotificationSuccess,
                failure: @escaping FailureClosure) {
        
        _ = DataService.shared.retrieveDataStream(by: "notifications/\(reporterid)",
            success: { (result) in
                guard let result = result,
                    let name = result["name"] as? String,
                    let phone = result["phone"] as? String  else{
                    return failure(NSError())
                }
                
                let data = RecieveNotificationResult(name: name, phone: phone)
                
                success(data)
        }, failure: failure)
    }
    
    func remove(_ reporterid: String) {
        DataService.shared.deleteData(by:  "notifications/\(reporterid)",
                                      success: { (_) in
                                        
        }) { (_) in
            
        }
    }
    
    func notifyLed() {
        let url = "https://api.particle.io/v1/devices/33003e001147343339383037/newMatch?"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        let postString = "access_token=0eca45ed744c891850f1add8441e222a402f8861"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
        }
        task.resume()
    }
}



