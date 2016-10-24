//
//  TransportationMethod.swift
//  TravelPlanner
//
//  Created by Adriana Elizondo on 10/23/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
class TransportationMethod{
    private let logoSize = "63"
    
    var providerLogo : String?{
        didSet{
            providerLogo = providerLogo?.replacingOccurrences(of: "{size}", with: logoSize)
        }
    }
    
    var price : String?{
        didSet{
            price = "€ " + price
        }
    }
    var departure : String?
    var arrival : String?
    var numberOfStops : Int?
    
}
