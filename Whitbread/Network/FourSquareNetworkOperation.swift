//
//  FourSquareNetworkOperation.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import Foundation

// MARK: - FourSquareNetworkOperationRequestor Protocol
protocol FourSquareNetworkOperationRequestor
{
    var request: URLRequest { get }
}

// MARK: - FourSquareNetworkOperationProcessor Protocol
protocol FourSquareNetworkOperationProcessor
{
    func handle(error: NSError)
    func process(data: Data)
}

// MARK: - FourSquareNetworkOperationError Enum
enum FourSquareNetworkOperationError: Int
{
    case invalidStatus = 900
    case response
    case jsonParse
}

// MARK: - FourSquareNetworkOperation Class
class FourSquareNetworkOperation: Operation {
    fileprivate let incomingData = NSMutableData()
    fileprivate var sessionTask: URLSessionTask?
    fileprivate lazy var session: URLSession = {
        return Foundation.URLSession(configuration: URLSessionConfiguration.default,
                                     delegate: self, delegateQueue: nil)
    }()
    fileprivate var processor: FourSquareNetworkOperationProcessor
    fileprivate let requestor: FourSquareNetworkOperationRequestor
    
    var _finished: Bool = false
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    init(processor: FourSquareNetworkOperationProcessor, requestor: FourSquareNetworkOperationRequestor)
    {
        self.processor = processor
        self.requestor = requestor
        super.init()
    }
    
    override func start()
    {
        if isCancelled {
            isFinished = true
            return
        }
        sessionTask = session.dataTask(with: requestor.request)
        sessionTask!.resume()
    }
}

// MARK: - NSURLSessionDataDelegate Implementation
extension FourSquareNetworkOperation: URLSessionDataDelegate
{
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        if isCancelled {
            sessionTask?.cancel()
            isFinished = true
            completionHandler(.cancel)
            return
        }
        if let response = response as? HTTPURLResponse {
            if !(response.statusCode ~= 200 ..< 300) {
                
                let invalidStatusProcessor = InvalidStatusProcessor(processor: processor)
                processor = invalidStatusProcessor
            }
        }
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data)
    {
        if isCancelled {
            sessionTask?.cancel()
            isFinished = true
            return
        }
        incomingData.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)
    {
        defer { isFinished = true }
        if isCancelled {
            sessionTask?.cancel()
            return
        }
        guard error == nil else {
            processor.handle(error: error! as NSError)
            return
        }
        processor.process(data: NSData(data: incomingData as Data) as Data)
    }
}

// MARK: - InvalidStatusProcessor
private class InvalidStatusProcessor: FourSquareNetworkOperationProcessor
{
    let processor: FourSquareNetworkOperationProcessor
    init(processor: FourSquareNetworkOperationProcessor)
    {
        self.processor = processor
        NSLog("Invalid status detected")
    }
    
    func handle(error: NSError)
    {
        processor.handle(error: error)
    }
    
    func process(data: Data)
    {
        guard let parsedJson = parseJson(data) else { return }
        guard let json = parsedJson as? [String: AnyObject] else {
            
            let userInfo = [NSLocalizedDescriptionKey: "Returned data could not be formatted in to JSON."]
            let error = NSError(domain: "InvalidStatusProcessor.processData",
                                code: FourSquareNetworkOperationError.jsonParse.rawValue, userInfo: userInfo)
            handle(error: error)
            return
        }
        if let message = json["message"] as? String {
            let userInfo = [NSLocalizedDescriptionKey: message]
            let error = NSError(domain: "InvalidStatusProcessor.processData",
                                code: FourSquareNetworkOperationError.invalidStatus.rawValue, userInfo: userInfo)
            handle(error: error)
        }
        else {
            let userInfo = [NSLocalizedDescriptionKey: "Invalid status received."]
            let error = NSError(domain: "InvalidStatusProcessor.processData",
                                code: FourSquareNetworkOperationError.invalidStatus.rawValue, userInfo: userInfo)
            handle(error: error)
        }
        
    }
    
    func parseJson(_ data: Data) -> Any?
    {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        }
        catch let error as NSError {
            let userInfo = [NSLocalizedDescriptionKey: "Unable to parse JSON object",
                            NSUnderlyingErrorKey: error] as [String : Any]
            let error = NSError(domain: "InvalidStatusProcessor.parseJson",
                                code: FourSquareNetworkOperationError.response.rawValue, userInfo: userInfo)
            handle(error: error)
        }
        return nil
    }
}
