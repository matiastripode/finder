//
//  FirebaseWrapper.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//



import Foundation
import Firebase


public struct CustomDatabaseReference
{
    var reference: DatabaseReference
    
    init(reference: DatabaseReference) {
        self.reference = reference
    }
    
    func removeAllListeners()
    {
        reference.removeAllObservers()
    }
}


public protocol FirebaseWrapperType {
    
    func retrieveData(by path: String?,
                      success: @escaping SuccessClosure,
                      failure: @escaping FailureClosure)
    
    func retrieveDataStream(by path: String?,
                            success: @escaping SuccessClosure,
                            failure: @escaping FailureClosure) -> CustomDatabaseReference
    
    func writeData(by path: String,
                   data: RawDataType,
                   success: @escaping SuccessClosure,
                   failure: @escaping FailureClosure)
    
    func updateData(by path: String,
                    data: RawDataType,
                    success: @escaping SuccessClosure,
                    failure: @escaping FailureClosure)
    
    func deleteData(by path: String,
                    success: @escaping SuccessClosure,
                    failure: @escaping FailureClosure)
}

public struct FirebaseWrapper : FirebaseWrapperType {
    private var db: DatabaseReference!
    private let dbPath = "https://disneyapp.firebaseio.com/"
    
    public init()
    {
        db = Database.database().reference()
    }
    
    //MARK: Reading data
    
    public func retrieveData(by path: String?,
                             success: @escaping SuccessClosure,
                             failure: @escaping FailureClosure)
    {
        let ref = (path != nil) ? db.child(path!) : db
        observeSingleEventType(by: ref!, success:success, failure:failure)
    }
    
    public func retrieveDataStream(by path: String?,
                                   success: @escaping SuccessClosure,
                                   failure: @escaping FailureClosure) -> CustomDatabaseReference
    {
        let ref = (path != nil) ? db.child(path!) : db
        observeEventType(by: ref!, success:success, failure:failure)
        
        return CustomDatabaseReference(reference: ref!)
    }
    
    //MARK: Writing/Updating/Removing data
    
    public func writeData(by path: String,
                          data: RawDataType,
                          success: @escaping SuccessClosure,
                          failure: @escaping FailureClosure)
    {
        let ref = db.child(path)
        ref.setValue(data)
        
        //TO-DO: Check if always return success is fine.
        success(nil)
    }
    
    public func updateData(by path: String,
                           data : RawDataType,
                           success: @escaping SuccessClosure,
                           failure: @escaping FailureClosure)
    {
        let ref = db.child(path)
        ref.updateChildValues(data)
        
        //TO-DO: Check if always return success is fine.
        success(nil)
    }
    
    public func deleteData(by path: String,
                           success: @escaping SuccessClosure,
                           failure: @escaping FailureClosure)
    {
        let ref = db.child(path)
        ref.removeValue()
        
        //TO-DO: Check if always return success is fine.
        success(nil)
    }
    
    //MARK: Private methods
    
    private func observeSingleEventType(by ref: DatabaseReference,
                                        success: @escaping SuccessClosure,
                                        failure: @escaping FailureClosure)
    {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            success(snapshot.value as AnyObject)
        }) { (error) in
            print(error)
            failure(error as NSError)
        }
    }
    
    private func observeEventType(by ref: DatabaseReference,
                                  success: @escaping SuccessClosure,
                                  failure: @escaping FailureClosure)
    {
        // open func observe(_ eventType: DataEventType, andPreviousSiblingKeyWith block: @escaping (DataSnapshot, String?) -> Swift.Void) -> UInt
        
        ref.observe(.value, with: { (snapshot) in
            success(snapshot.value as AnyObject)
        })
        /*
        ref.observe(of: .value, with: { (snapshot) in
            success(snapshot.value as AnyObject)
        }) { (error) in
            print(error)
            failure(error as NSError)
        }*/
    }
}
