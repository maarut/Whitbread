//
//  Range+Utils.swift
//  Whitbread
//
//  Created by Maarut Chandegra on 22/01/2019.
//  Copyright © 2019 Maarut Chandegra. All rights reserved.
//

import Foundation

public func ~=<I : Comparable>(value: I, pattern: Range<I>) -> Bool where I : Comparable
{
    return pattern ~= value
}
