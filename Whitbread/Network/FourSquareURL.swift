//
//  FourSquareURL.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import Foundation

class FourSquareURL {
    let url: URL
    
    init(method: String, parameters: [String: Any])
    {
        var url = URLComponents()
        url.scheme = FourSquareConstants.API.Scheme
        url.host = FourSquareConstants.API.Host
        url.path = "/\(FourSquareConstants.API.BasePath)/\(method)"
        
        url.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        url.queryItems!.append(URLQueryItem(name: FourSquareConstants.ParameterKeys.ClientId,
                                            value: FourSquareConstants.API.ClientId))
        url.queryItems!.append(URLQueryItem(name: FourSquareConstants.ParameterKeys.ClientSecret,
                                            value: FourSquareConstants.API.ClientSecret))
        url.queryItems!.append(URLQueryItem(name: FourSquareConstants.ParameterKeys.VersionDate,
                                            value:
            ISO8601DateFormatter.string(from: Date(),
                                        timeZone: TimeZone.current,
                                        formatOptions: [.withYear, .withMonth, .withDay])))
        
        self.url = url.url!
    }
}
