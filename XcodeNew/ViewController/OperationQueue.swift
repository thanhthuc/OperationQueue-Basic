
//
//  OperationQueue.swift
//  XcodeNew
//
//  Created by Thuc on 4/29/18.
//  Copyright © 2018 NetworkingThuc. All rights reserved.
//

import UIKit
import Foundation

class NetworkOperation: AsynchronousOperation  {
    
    private let url: URL
    private var networkOperationCompletionHandler: ((_ data: Data?,_ error: Error?) -> Void)?
    weak var task: URLSessionDataTask?
    
    init(url: URL, networkOperationCompletionHandler: ((_ data: Data?,_ error: Error?) -> Void)?) {        
        self.url = url
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        super.init()
    }
    
    override func main() {
        task = URLSession.shared.dataTask(with: url, completionHandler: { 
            [weak self] (data, response, error) in
            if let data = data {
                self?.networkOperationCompletionHandler?(data, nil)  
                self?.completeOpration()
                return
            }
            if let error = error {
                self?.networkOperationCompletionHandler?(nil, error)
                self?.completeOpration()
                return
            }
        })
        task?.resume()
    }
    
    override func cancel() {
//        task?.cancel()
        super.cancel()
    }
    
}


class AsynchronousOperation: Operation {
    
    override public var isAsynchronous: Bool { return true }
    private let stateLock = NSLock()
    
    private var _executing: Bool = false
    override private(set) public var isExecuting: Bool {        
        get {
            return stateLock.withCriticalScope(block: { _executing })
        }
        set(newValue) {
            willChangeValue(forKey: "isExecuting")
            stateLock.withCriticalScope(block: { _executing = newValue })
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished: Bool = false
    override private(set) public var isFinished: Bool {
        get {
            return stateLock.withCriticalScope(block: { _finished })
        }
        set(newValue) {
            willChangeValue(forKey: "isFinished")
            stateLock.withCriticalScope(block: { _finished = newValue })
            didChangeValue(forKey: "isFinished")
        }
    }
    
    /// Complete the operation
    ///
    /// This will result in the appropriate KVN isFinish and isExecuting
    public func completeOpration() {
        if isExecuting {
            isExecuting = false
        }
        if !isFinished {
            isFinished = true
        }
    }
    
    override public func start() {
        if isCancelled {
            isFinished = true
            return
        }
        isExecuting = true
        main()
    }
    
    override public func main() {
        fatalError("subclass ust override main")
    }
}


extension NSLock {
    /// Perform closure within lock
    ///
    /// An extension to 'NSLock' to simplify executing critical code
    ///
    /// - parameter block: The closure to be performed.
    
    func withCriticalScope<T>(block: () -> T) -> T {
        
        lock()
        
        let value = block()
        
        unlock()
        
        return value
        
    }
}
