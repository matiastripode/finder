//
//  DatabaseService.swift
//  Finder
//
//  Created by Carlos Matias Tripode on 6/10/17.
//  Copyright © 2017 Nicolas Porpiglia. All rights reserved.
//

import Foundation


import Foundation

public typealias RawDataType = [String: AnyObject]

public typealias BasicClosure = () -> Void
public typealias SuccessClosure = (AnyObject?) -> Void
public typealias FailureClosure = (NSError) -> Void

public protocol DataServiceType
{
    func retrieveData(by path: String?,
                      success: @escaping SuccessClosure,
                      failure: @escaping FailureClosure)
    
    func retrieveDataStream(by path: String?,
                            success: @escaping SuccessClosure,
                            failure: @escaping FailureClosure) -> CustomDatabaseReference
    
    func writeData(by path: String,
                   data : RawDataType,
                   success: @escaping SuccessClosure,
                   failure: @escaping FailureClosure)
    
    func updateData(by path: String,
                    data : RawDataType,
                    success: @escaping SuccessClosure,
                    failure: @escaping FailureClosure)
}

public struct DataService : DataServiceType
{
    private let db: FirebaseWrapperType
    
    public init()
    {
        self.db = FirebaseWrapper()
    }
    
    public func retrieveData(by path: String?,
                             success: @escaping SuccessClosure,
                             failure: @escaping FailureClosure)
    {
        db.retrieveData(by: path, success: success, failure: failure)
    }
    
    public func retrieveDataStream(by path: String?,
                                   success: @escaping SuccessClosure,
                                   failure: @escaping FailureClosure) -> CustomDatabaseReference
    {
        return db.retrieveDataStream(by: path, success: success, failure: failure)
    }
    
    public func writeData(by path: String,
                          data: RawDataType,
                          success: @escaping SuccessClosure,
                          failure: @escaping FailureClosure)
    {
        db.writeData(by: path,
                     data: data,
                     success: success,
                     failure: failure)
        
    }
    
    public func updateData(by path: String,
                           data : RawDataType,
                           success: @escaping SuccessClosure,
                           failure: @escaping FailureClosure) {
        
        db.updateData(by: path,
                      data: data,
                      success: success,
                      failure: failure)
    }
    
}
