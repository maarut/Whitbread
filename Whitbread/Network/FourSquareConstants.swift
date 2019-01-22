//
//  FourSquareConstants.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import Foundation

struct FourSquareConstants {
    struct API
    {
        static let Scheme = "https"
        static let Host = "api.foursquare.com"
        static let BasePath = "v2"
        static let ClientId = kFourSquareClientId
        static let ClientSecret = kFourSquareClientSecret
    }
    
    struct ParameterKeys {
        static let ClientId = "client_id"
        static let ClientSecret = "client_secret"
        static let VersionDate = "v"
    }
}
