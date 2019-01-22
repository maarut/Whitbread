//
//  FourSquareClient.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import UIKit

class FourSquareClient {
    static let instance: FourSquareClient = FourSquareClient()
    
    private let queue = OperationQueue()
    
    private init() { }
    
    func getVenues(_ searchCriteria: FourSquareVenueSearchCriteria,
                   resultsProcessor: FourSquareVenueSearchResultsProcessor) {
        let processor = FourSquareVenueSearch(resultsHandler: resultsProcessor)
        let networkOp = FourSquareNetworkOperation(processor: processor, requestor: searchCriteria)
        queue.addOperation(networkOp)
    }
}
