//
//  TransportationMethod.swift
//  TravelPlanner
//
//  Created by Adriana Elizondo on 10/23/16.
//  Copyright © 2016 Adriana Elizondo. All rights reserved.
//

import Foundation
import ObjectMapper

class Trip : Mappable{
    private let logoSize = "63"
    
    var providerLogo : String?{
        didSet{
            providerLogo = providerLogo?.replacingOccurrences(of: "{size}", with: logoSize)
        }
    }
    
    var price : Any?
    var departure : String?
    var arrival : String?
    var numberOfStops : Int?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        providerLogo    <- map["provider_logo"]
        price         <- map["price_in_euros"]
        departure      <- map["departure_time"]
        arrival       <- map["arrival_time"]
        numberOfStops  <- map["number_of_stops"]
    }
    
}
